//
//  EKEventStore+Settings.m
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import "EKEventStore+Settings.h"


@implementation EKEventStore (Settings)

- (NSArray *)activeEventCalendars
{
    if (![EKEventStore isPermissionGranted]) return nil;
    NSArray *array = [self calendarsForEntityType:EKEntityTypeEvent];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKCalendar *calendar,
                                                                                     NSDictionary *bindings)
    {
        for (NSString *identifier in PREFS.hiddenEventCalendarIdentifiers) {
            if ([calendar.calendarExternalIdentifier isEqualToString:identifier]) {
                return NO;
            }
        }
        return YES;
    }]];
    return array;
}

- (NSArray *)activeReminderCalendars
{
    return nil;
}


- (EKCalendar *)defaultEventCalendar
{
    if (![EKEventStore isPermissionGranted]) return nil;
    for (EKCalendar *calendar in [self activeEventCalendars]) {
        if ([calendar.calendarExternalIdentifier isEqualToString:PREFS.defaultEventCalendarIdentifier]) {
            return calendar;
        }
    }
    return [self defaultCalendarForNewEvents];
}

- (EKCalendar *)defaultReminderCalendar
{
    return nil;
}


@end
