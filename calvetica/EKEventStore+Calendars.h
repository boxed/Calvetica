//
//  EKEventStore+Calendars.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>

@interface EKEventStore (Calendars)

- (NSArray *)mt_allCalendars;
- (NSArray *)eventCalendars;
- (NSArray *)reminderCalendars;

- (NSArray *)editableCalendarsForEntityType:(EKEntityType)entityType;

@end
