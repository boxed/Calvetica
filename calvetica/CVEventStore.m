//
//  CVEventStore.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventStore.h"
#import "EKEvent+Utilities.h"
#import "EKReminder+Calvetica.h"
#import "EKCalendarItem+Calvetica.h"
#import "CVEventSquare.h"
#import "CVDebug.h"



@implementation CVEventStore

static CVEventStore *__sharedStore = nil;

+ (CVEventStore *)sharedStore
{
    if (__sharedStore == nil) {
        __sharedStore = [[CVEventStore alloc] init];
        __sharedStore.eventStore = [[EKEventStore alloc] init];
    }

    return __sharedStore;
}

+ (void)reset
{
    __sharedStore = nil;
}



#pragma mark - Events

+ (NSArray *)eventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly
{

    NSMutableArray *calendars = nil;
    if (activeCalsOnly) {
        calendars = [CVSettings selectedEventCalendars];
        
        // passing in an empty array to "calendars" is like passing nil, which will return all calendars
        if (calendars.count == 0) {
            return [NSMutableArray array];
        }
    }
    
    NSPredicate *predicate = [[CVEventStore sharedStore].eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];
    NSMutableArray *events = [NSMutableArray arrayWithArray:[[CVEventStore sharedStore].eventStore eventsMatchingPredicate:predicate]];

//	[events filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//		EKEvent *event = evaluatedObject;
//		if ([event.endingDate isEqualToDate:startDate]) return NO;
//		return YES;
//	}]];

	return events;
}

+ (NSArray *)chainedEventDataHoldersFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly includeAllDayEvents:(BOOL)includeAllDayEvents
{
	startDate = [startDate dateByAddingTimeInterval:-1];

    // grab all the events we need
    NSMutableArray *weekEvents = [NSMutableArray arrayWithArray:[CVEventStore eventsFromDate:startDate
                                                                                      toDate:endDate
                                                                          forActiveCalendars:activeCalsOnly]];
    
    // sort the events in chrono order
    [weekEvents sortUsingComparator:(NSComparator)^(id obj1, id obj2){
        EKEvent *e1 = obj1;
        EKEvent *e2 = obj2;
        return [e1 compareStartDateWithEvent:e2];
    }];
	
	NSMutableArray *chainedEvents = [NSMutableArray array]; // a collection of events that are chained together by any occurence of simultaneous overlap
	NSMutableArray *concurrentEvents = [NSMutableArray array]; // a collection of events that occur simultaneously
	NSMutableArray *eventsToRemoveFromConcurrent = [NSMutableArray array];
	NSMutableArray *eventSquareDataHolders = [NSMutableArray array];
	for (EKEvent *event in weekEvents) {
		
		CVEventSquare *eventSquareDataHolder = [[CVEventSquare alloc] init];
		eventSquareDataHolder.event = event;
        eventSquareDataHolder.startSeconds = [event.startingDate timeIntervalSinceDate:startDate];
        eventSquareDataHolder.endSeconds = [event.endingDate timeIntervalSinceDate:startDate];
		
		if (![event spansEntireDayOfDate:startDate] || includeAllDayEvents) {
            
            // if any concurrent events end before this one starts, it is no longer concurrent
			for (CVEventSquare *e in concurrentEvents) {
				if (e.endSeconds <= eventSquareDataHolder.startSeconds) {
					[eventsToRemoveFromConcurrent addObject:e];
				}
			}
			
			for (CVEventSquare *e in eventsToRemoveFromConcurrent) {
				[concurrentEvents removeObject:e];
			}
			[eventsToRemoveFromConcurrent removeAllObjects];
			
			
			// chained events array is only emptied if there are no concurrent events
			if (concurrentEvents.count == 0) {
				[chainedEvents removeAllObjects];
			}
			
            // loop n^2 to make sure that any offset checked before an increment was not missed
			eventSquareDataHolder.offset = 0;
			for (NSInteger i=0; i < concurrentEvents.count; i++) {
				for (CVEventSquare *ie in concurrentEvents) {
					if ( ie.offset == eventSquareDataHolder.offset ) {
						eventSquareDataHolder.offset++;
					}
				}
			}
			
            // add the event to both sets because it's either a continuation or a start of a chain
			[chainedEvents addObject:eventSquareDataHolder];
			[concurrentEvents addObject:eventSquareDataHolder];
			
            // change the overlap count of all chained events to the max overlap count (so they are all the same width)
			NSInteger maxOverlaps = 0;
			for (CVEventSquare *e in chainedEvents) {
				if (e.overlaps < concurrentEvents.count) {
					e.overlaps = concurrentEvents.count;
				}
				
				if (e.overlaps > maxOverlaps) {
					maxOverlaps = e.overlaps;
				}
			}
			
			if (maxOverlaps > eventSquareDataHolder.overlaps) {
				eventSquareDataHolder.overlaps = maxOverlaps;
			}
		}
		
		[eventSquareDataHolders addObject:eventSquareDataHolder];
	}
    
    return  eventSquareDataHolders;
}

+ (NSArray *)eventsSearchedWithText:(NSString *)text startDate:(NSDate *)startDate endDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly
{    
	// get the list of calendars to include
    NSMutableArray *calendars = nil;
    if (activeCalsOnly) {
        calendars = [CVSettings selectedEventCalendars];
        
        // passing in an empty arry to "calendars" is like passing nil, which will return all calendars
        if (calendars.count == 0) {
            return [NSMutableArray array];
        }
        
    }
    
    // create search predicate
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ || notes CONTAINS[cd] %@ || location CONTAINS[cd] %@", text, text, text];
    
    
	// create an array that we will add all our found events to
	NSMutableArray *foundEvents = [NSMutableArray array];
	
	for (NSInteger i = 0; i < [endDate mt_monthsSinceDate:startDate]; i++) {
		NSPredicate *predicate = [[CVEventStore sharedStore].eventStore predicateForEventsWithStartDate:[startDate mt_dateMonthsAfter:i] endDate:[startDate mt_dateMonthsAfter:i+1] calendars:calendars];
		NSMutableArray *events = [NSMutableArray arrayWithArray:[[CVEventStore sharedStore].eventStore eventsMatchingPredicate:predicate]];
		
		[events filterUsingPredicate:searchPredicate];

		[foundEvents addObjectsFromArray:events];
	}
    
    return foundEvents;
}

+ (EKEvent *)event
{
    return [EKEvent eventWithEventStore:[CVEventStore sharedStore].eventStore];
}

+ (EKEvent *)eventWithIdentifier:(NSString *)identifier
{
	return (EKEvent *)[EKCalendarItem calendarItemWithIdentifier:identifier];
}

+ (NSError *)saveEvent:(EKEvent *)event forAllOccurrences:(BOOL)forAll
{
    NSError *error = nil;
    EKSpan span = forAll ? EKSpanFutureEvents : EKSpanThisEvent;
    [[CVEventStore sharedStore].eventStore saveEvent:event span:span error:&error];
    return error;
}

+ (NSError *)removeEvent:(EKEvent *)event forAllOccurrences:(BOOL)forAll
{
    NSError *error = nil;
    [[CVEventStore sharedStore].eventStore removeEvent:event span:(forAll ? EKSpanFutureEvents : EKSpanThisEvent) error:&error];
    return error;
}

+ (NSArray *)eventCalendars
{
	NSArray *array = [[CVEventStore sharedStore].eventStore calendarsForEntityType:EKEntityTypeEvent];
	if (array.count == 0) {
		EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:[CVEventStore sharedStore].eventStore];
		[calendar save];
		array = @[calendar];
	}
	return array;
}

+ (EKCalendar *)defaultCalendarForNewEvents
{
    return [CVEventStore sharedStore].eventStore.defaultCalendarForNewEvents;    
}




#pragma mark - Reminders

+ (NSArray *)remindersFromDate:(NSDate *)startDate toDate:(NSDate *)endDate activeCalendars:(BOOL)activeCalsOnly
{

    NSMutableArray *calendars = nil;
    if (activeCalsOnly) {
        calendars = [CVSettings selectedReminderCalendars];
        if (calendars.count == 0) return [NSArray array];
    }

    NSPredicate *predicate = [[CVEventStore sharedStore].eventStore predicateForRemindersInCalendars:calendars];

	__block NSArray *reminders = nil;
	__block BOOL fetched = NO;

    [[CVEventStore sharedStore].eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *rems) {
		reminders = rems;
		fetched = YES;
	}];

	while (!fetched) {
		[NSThread sleepForTimeInterval:0.01];
	}

	NSDate *today = [NSDate date];

	NSMutableArray *filteredReminders = [NSMutableArray array];
	for (EKReminder *reminder in reminders) {
		
		NSDate *date = reminder.preferredDate;

		// if its not completed, it should appear on today if the start/due date has passed.
		if (!reminder.isCompleted && [startDate mt_isOnOrBefore:today] && [endDate mt_isOnOrAfter:today] && [reminder.startDate mt_isOnOrBefore:today] && [reminder.dueDate mt_isOnOrBefore:today])
			[filteredReminders addObject:reminder];

		// if its completed, it should show up on the day it was completed
		else if (reminder.isCompleted && [reminder.completionDate mt_isOnOrAfter:startDate] && [reminder.completionDate mt_isOnOrBefore:endDate])
			[filteredReminders addObject:reminder];

		// if we're viewing days in the future, only show reminders that start or are due on this day
		else if (!reminder.isCompleted && date && [date mt_isOnOrAfter:startDate] && [date mt_isOnOrBefore:endDate])
			[filteredReminders addObject:reminder];
	}

	return filteredReminders;
}

+ (NSArray *)remindersSearchedWithText:(NSString *)text forActiveCalendars:(BOOL)activeCalsOnly
{
	// get the list of calendars to include
    NSMutableArray *calendars = nil;
    if (activeCalsOnly) {
        calendars = [CVSettings selectedReminderCalendars];
        if (calendars.count == 0) return [NSArray array];
    }

	NSPredicate *predicate = [[CVEventStore sharedStore].eventStore predicateForRemindersInCalendars:calendars];

	__block NSArray *reminders = nil;
	__block BOOL fetched = NO;

	[[CVEventStore sharedStore].eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *rems) {
		reminders = rems;
		fetched = YES;
	}];

	while (!fetched) {
		[NSThread sleepForTimeInterval:0.0001];
	}

	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ || notes CONTAINS[cd] %@ || location CONTAINS[cd] %@", text, text, text];
	return [reminders filteredArrayUsingPredicate:searchPredicate];
}

+ (EKReminder *)reminder
{
    return [EKReminder reminderWithEventStore:[CVEventStore sharedStore].eventStore];
}

+ (EKReminder *)reminderWithIdentifier:(NSString *)identifier
{
	return (EKReminder *)[EKCalendarItem calendarItemWithIdentifier:identifier];
}

+ (NSError *)saveReminder:(EKReminder *)reminder
{
    NSError *error = nil;
    [[CVEventStore sharedStore].eventStore saveReminder:reminder commit:YES error:&error];
    return error;
}

+ (NSError *)removeReminder:(EKReminder *)reminder
{
    NSError *error = nil;
    [[CVEventStore sharedStore].eventStore removeReminder:reminder commit:YES error:&error];
    return error;
}

+ (NSArray *)reminderCalendars
{
    NSArray *array = [[CVEventStore sharedStore].eventStore calendarsForEntityType:EKEntityTypeReminder];
	if (array.count == 0) {
		EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:[CVEventStore sharedStore].eventStore];
		[calendar save];
		array = @[calendar];
	}
	return array;
}

+ (EKCalendar *)defaultCalendarForNewReminders
{
    return [CVEventStore sharedStore].eventStore.defaultCalendarForNewReminders;
}




#pragma mark - Calendars

+ (NSArray *)editableCalendarsForEntityType:(EKEntityType)entityType
{
    NSMutableArray *editableCals = [NSMutableArray array];
    for (EKCalendar *c in [[CVEventStore sharedStore].eventStore calendarsForEntityType:entityType]) {
        if (c.allowsContentModifications) {
            [editableCals addObject:c];
        }
    }
    return [NSArray arrayWithArray:editableCals];
}

+ (EKCalendar *)calendarWithIdentifier:(NSString *)identifier
{
	return [[CVEventStore sharedStore].eventStore calendarWithIdentifier:identifier];
}

+ (NSArray *)calendarSources
{
	return [CVEventStore sharedStore].eventStore.sources;
}

+ (NSError *)saveCalendar:(EKCalendar *)calendar
{
    NSError *error;
	if (!calendar.title) calendar.title = @"Untitled";
	if (!calendar.source) calendar.source = [CVEventStore defaultSource];
	[[CVEventStore sharedStore].eventStore saveCalendar:calendar commit:YES error:&error];
	return error;
}

+ (NSError *)removeCalendar:(EKCalendar *)calendar
{
    NSError *error;
	[[self sharedStore].eventStore removeCalendar:calendar commit:YES error:&error];
	return error;
}




#pragma mark - Sources

+ (EKSource *)defaultSource
{
	NSArray *array = [CVEventStore sharedStore].eventStore.sources;
	for (EKSource *source in array) {
		if (source.sourceType == EKSourceTypeLocal || source.sourceType == EKSourceTypeMobileMe) {
			return source;
		}
	}
	return [array lastObject];
}

@end
