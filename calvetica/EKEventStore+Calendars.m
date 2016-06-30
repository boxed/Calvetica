//
//  EKEventStore+Calendars.m
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import "EKEventStore+Calendars.h"


@implementation EKEventStore (Calendars)

- (NSArray *)mt_allCalendars
{
    if (![EKEventStore isPermissionGranted]) return nil;
	return [([self eventCalendars] ?: @[]) arrayByAddingObjectsFromArray:[self reminderCalendars]];
}

- (NSArray *)eventCalendars
{
    if (![EKEventStore isPermissionGranted]) return nil;
	return [self calendarsForEntityType:EKEntityTypeEvent];
}

- (NSArray *)reminderCalendars
{
    if (![EKEventStore isPermissionGranted]) return nil;
	return [self calendarsForEntityType:EKEntityTypeReminder];
}

- (NSArray *)editableCalendarsForEntityType:(EKEntityType)entityType
{
    if (![EKEventStore isPermissionGranted]) return nil;
    NSMutableArray *editableCals = [NSMutableArray array];
    for (EKCalendar *c in [[EKEventStore sharedStore] calendarsForEntityType:entityType]) {
        if (c.allowsContentModifications) {
            [editableCals addObject:c];
        }
    }
    return [NSArray arrayWithArray:editableCals];
}

@end
