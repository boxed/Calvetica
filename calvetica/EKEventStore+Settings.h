//
//  EKEventStore+Settings.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKEventStore (Settings)

- (NSArray *)activeEventCalendars;
- (NSArray *)activeReminderCalendars;

- (EKCalendar *)defaultEventCalendar;
- (EKCalendar *)defaultReminderCalendar;

@end

NS_ASSUME_NONNULL_END
