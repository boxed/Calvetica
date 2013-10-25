//
//  EKEventStore.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKEventStore+Shared.h"
#import "CVCalendarItemShape.h"
#import "CVDebug.h"


@implementation EKEventStore (Shared)

static BOOL __permissionGranted     = NO;
static EKEventStore *__sharedStore  = nil;
static NSArray *__allReminders      = nil;



#pragma mark - Public

+ (EKEventStore *)sharedStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedStore = [EKEventStore new];
    });

    if (!__permissionGranted) {
        return nil;
    }

    return __sharedStore;
}


#pragma mark (Permission)

+ (void)setPermissionGranted:(BOOL)granted
{
    __permissionGranted = YES;
}

+ (BOOL)isPermissionGranted
{
    return __permissionGranted;
}

+ (EKEventStore *)permissionStore
{
    [self sharedStore];
    return __sharedStore;
}



#pragma mark (Events)

+ (NSArray *)eventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly
{
    if (!__permissionGranted) return nil;
    if (!startDate || !endDate) return @[];

    // we fetch a 24 hour buffer around the range because if "Time Zone Support" is turned on in the native calendar app
    // it affects the fetching of events and may not return all that actually do fall within the date range we ask. They
    // can't possibly shift more than 24 hours, so that's all the cushion we need.
    NSDate *bufferedStartDate = [startDate mt_dateDaysBefore:1];
    NSDate *bufferedEndDate = [endDate mt_dateDaysAfter:1];

    NSMutableArray *calendars = nil;
    if (activeCalsOnly) {
        calendars = [CVSettings selectedEventCalendars];
        
        // passing in an empty array to "calendars" is like passing nil, which will return all calendars
        if (calendars.count == 0) {
            return [NSMutableArray array];
        }
    }

    NSPredicate *predicate = [[EKEventStore sharedStore] predicateForEventsWithStartDate:bufferedStartDate endDate:bufferedEndDate calendars:calendars];
    NSMutableArray *events = [[[EKEventStore sharedStore] eventsMatchingPredicate:predicate] mutableCopy];

    // strip out any events we grabbed because of the buffer that are outside our originally requested range
	[events filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent *event, NSDictionary *bindings) {

        // it returned an EKReminder one time...whatever.
        if (![event isKindOfClass:[EKEvent class]]) {
            return NO;
        }

        NSComparisonResult startsBeforeEndResult    = [event.startDate compare:endDate];
        BOOL startsBeforeEnd                        = (startsBeforeEndResult == NSOrderedAscending ||
                                                       startsBeforeEndResult == NSOrderedSame);

        NSComparisonResult endsAfterStartResult     = [event.endDate compare:startDate];
        BOOL endsAfterStart                         = (endsAfterStartResult == NSOrderedDescending ||
                                                       endsAfterStartResult == NSOrderedSame);

        return (endsAfterStart && startsBeforeEnd);
	}]];

	return events;
}

//+ (NSArray *)chainedEventModelsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly includeAllDayEvents:(BOOL)includeAllDayEvents
//{
//    if (!__permissionGranted) return nil;
//	startDate = [startDate dateByAddingTimeInterval:-1];
//
//    // grab all the events we need
//    NSMutableArray *weekEvents = [NSMutableArray arrayWithArray:[EKEventStore eventsFromDate:startDate
//                                                                                      toDate:endDate
//                                                                          forActiveCalendars:activeCalsOnly]];
//    
//    // sort the events in chrono order
//    [weekEvents sortUsingComparator:(NSComparator)^(id obj1, id obj2){
//        EKEvent *e1 = obj1;
//        EKEvent *e2 = obj2;
//        return [e1 compareStartDateWithEvent:e2];
//    }];
//	
//	NSMutableArray *chainedEvents = [NSMutableArray array]; // a collection of events that are chained together by any occurence of simultaneous overlap
//	NSMutableArray *concurrentEvents = [NSMutableArray array]; // a collection of events that occur simultaneously
//	NSMutableArray *eventsToRemoveFromConcurrent = [NSMutableArray array];
//	NSMutableArray *eventSquareModels = [NSMutableArray array];
//	for (EKEvent *event in weekEvents) {
//		
//		CVEventSquareModel *eventSquareModel = [CVEventSquareModel new];
//		eventSquareModel.event = event;
//        eventSquareModel.startSeconds = [event.startingDate timeIntervalSinceDate:startDate];
//        eventSquareModel.endSeconds = [event.endingDate timeIntervalSinceDate:startDate];
//		
//		if (![event spansEntireDayOfDate:startDate] || includeAllDayEvents) {
//            
//            // if any concurrent events end before this one starts, it is no longer concurrent
//			for (CVEventSquareModel *e in concurrentEvents) {
//				if (e.endSeconds <= eventSquareModel.startSeconds) {
//					[eventsToRemoveFromConcurrent addObject:e];
//				}
//			}
//			
//			for (CVEventSquareModel *e in eventsToRemoveFromConcurrent) {
//				[concurrentEvents removeObject:e];
//			}
//			[eventsToRemoveFromConcurrent removeAllObjects];
//			
//			
//			// chained events array is only emptied if there are no concurrent events
//			if (concurrentEvents.count == 0) {
//				[chainedEvents removeAllObjects];
//			}
//			
//            // loop n^2 to make sure that any offset checked before an increment was not missed
//			eventSquareModel.offset = 0;
//			for (NSInteger i=0; i < concurrentEvents.count; i++) {
//				for (CVEventSquareModel *ie in concurrentEvents) {
//					if ( ie.offset == eventSquareModel.offset ) {
//						eventSquareModel.offset++;
//					}
//				}
//			}
//			
//            // add the event to both sets because it's either a continuation or a start of a chain
//			[chainedEvents addObject:eventSquareModel];
//			[concurrentEvents addObject:eventSquareModel];
//			
//            // change the overlap count of all chained events to the max overlap count (so they are all the same width)
//			NSInteger maxOverlaps = 0;
//			for (CVEventSquareModel *e in chainedEvents) {
//				if (e.overlaps < concurrentEvents.count) {
//					e.overlaps = concurrentEvents.count;
//				}
//				
//				if (e.overlaps > maxOverlaps) {
//					maxOverlaps = e.overlaps;
//				}
//			}
//			
//			if (maxOverlaps > eventSquareModel.overlaps) {
//				eventSquareModel.overlaps = maxOverlaps;
//			}
//		}
//		
//		[eventSquareModels addObject:eventSquareModel];
//	}
//    
//    return  eventSquareModels;
//}

+ (NSArray *)eventsSearchedWithText:(NSString *)text startDate:(NSDate *)startDate endDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly
{
    if (!__permissionGranted) return nil;
    
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
	
	for (NSInteger i = 0; i < [endDate mt_monthsSinceDate:startDate]; i+=6) {
		NSPredicate *predicate = [[EKEventStore sharedStore] predicateForEventsWithStartDate:[startDate mt_dateMonthsAfter:i] endDate:[startDate mt_dateMonthsAfter:i+6] calendars:calendars];
		NSMutableArray *events = [NSMutableArray arrayWithArray:[[EKEventStore sharedStore] eventsMatchingPredicate:predicate]];
		
		[events filterUsingPredicate:searchPredicate];

		[foundEvents addObjectsFromArray:events];
	}
    
    return foundEvents;
}

+ (EKEvent *)event
{
    if (!__permissionGranted) return nil;
    return [EKEvent eventWithEventStore:[EKEventStore sharedStore]];
}

+ (EKEvent *)eventWithIdentifier:(NSString *)identifier
{
    if (!__permissionGranted) return nil;
	return (EKEvent *)[EKCalendarItem calendarItemWithIdentifier:identifier];
}

+ (NSArray *)eventCalendars
{
    if (!__permissionGranted) return nil;
	NSArray *array = [[EKEventStore sharedStore] calendarsForEntityType:EKEntityTypeEvent];
	if (array.count == 0) {
		EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:[EKEventStore sharedStore]];
		[calendar save];
		array = @[calendar];
	}
	return array;
}

+ (EKCalendar *)defaultCalendarForNewEvents
{
    if (!__permissionGranted) return nil;
    return [EKEventStore sharedStore].defaultCalendarForNewEvents;
}




#pragma mark (Reminders)

- (BOOL)remindersFromDate:(NSDate *)fromDate
                   toDate:(NSDate *)toDate
                calendars:(NSArray *)calendars
                  options:(MYSEKEventStoreReminderFetchOptions)options
               completion:(void (^)(NSArray *reminders))completion
{
    if (!__permissionGranted) return YES;
    return [self fetchAllRemindersInCalendars:calendars completion:^(NSArray *allReminders) {
        allReminders = [allReminders filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKReminder *reminder,
                                                                                                       NSDictionary *bindings) {
            if ((options & MYSEKEventStoreReminderFetchOptionsExcludeCompleted) && reminder.completed) {
                return NO;
            }
            if (reminder.isFloating) {
                return !(options & MYSEKEventStoreReminderFetchOptionsExcludeFloating);
            }
            return [reminder occursBetweenDate:fromDate date:toDate];
        }]];
        if (completion) completion(allReminders);
    }];
}

- (void)clearRemindersCache
{
    [self clearRemindersCacheAndReloadWithCompletion:nil];
}

- (void)clearRemindersCacheAndReloadWithCompletion:(void (^)(void))completion
{
    [[EKEventStore sharedRemindersFetchingLock] lock];
    __allReminders = nil;
    [[EKEventStore sharedRemindersFetchingLock] unlock];
    if (completion) {
        [MTq def:^{
            [self fetchAllRemindersInCalendars:nil completion:^(NSArray *allReminders) {
                completion();
            }];
        }];
    }
}



#pragma mark - Calendars

+ (NSArray *)editableCalendarsForEntityType:(EKEntityType)entityType
{
    if (!__permissionGranted) return nil;
    NSMutableArray *editableCals = [NSMutableArray array];
    for (EKCalendar *c in [[EKEventStore sharedStore] calendarsForEntityType:entityType]) {
        if (c.allowsContentModifications) {
            [editableCals addObject:c];
        }
    }
    return [NSArray arrayWithArray:editableCals];
}

+ (EKCalendar *)calendarWithIdentifier:(NSString *)identifier
{
    if (!__permissionGranted) return nil;
	return [[EKEventStore sharedStore] calendarWithIdentifier:identifier];
}

+ (NSArray *)calendarSources
{
    if (!__permissionGranted) return nil;
	return [EKEventStore sharedStore].sources;
}

+ (NSError *)saveCalendar:(EKCalendar *)calendar
{
    if (!__permissionGranted) return nil;
    NSError *error;
	if (!calendar.title) calendar.title = @"Untitled";
	if (!calendar.source) calendar.source = [EKEventStore defaultSource];
	[[EKEventStore sharedStore] saveCalendar:calendar commit:YES error:&error];
	return error;
}

+ (NSError *)removeCalendar:(EKCalendar *)calendar
{
    if (!__permissionGranted) return nil;
    NSError *error;
	[[self sharedStore] removeCalendar:calendar commit:YES error:&error];
	return error;
}




#pragma mark - Sources

+ (EKSource *)defaultSource
{
    if (!__permissionGranted) return nil;
	NSArray *array = [EKEventStore sharedStore].sources;
	for (EKSource *source in array) {
		if (source.sourceType == EKSourceTypeLocal || source.sourceType == EKSourceTypeMobileMe) {
			return source;
		}
	}
	return [array lastObject];
}




#pragma mark - Private

/**
 * Returns YES if it is able to return immediate with cached reminders. Otherwise NO.
 */
- (BOOL)fetchAllRemindersInCalendars:(NSArray *)calendars completion:(void (^)(NSArray *allReminders))completion
{
    [[EKEventStore sharedRemindersFetchingLock] lock];
    BOOL cached = NO;
    NSArray *remindersCache = [__allReminders copy];
    if (remindersCache) {
        if (completion) completion(remindersCache);
        cached = YES;
    }
    else {
        __allReminders = @[];
        NSLog(@"Had to fetch all reminders");
        NSPredicate *predicate = [[EKEventStore sharedStore] predicateForRemindersInCalendars:calendars];
        [self fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
            __allReminders = [reminders copy];
            if (completion) completion(reminders);
        }];
    }
    [[EKEventStore sharedRemindersFetchingLock] unlock];
    return cached;
}

+ (NSLock *)sharedRemindersFetchingLock
{
    static NSLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSLock new];
    });
    return lock;
}


@end
