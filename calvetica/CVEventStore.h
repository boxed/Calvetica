//
//  CVEventStore.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@interface CVEventStore : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;

+ (CVEventStore *)sharedStore;

// asking permission
- (EKEventStore *)permissionStore;
+ (void)setPermissionGranted:(BOOL)granted;
+ (BOOL)isPermissionGranted;

#pragma mark - Events

+ (NSArray *)eventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly;
+ (NSArray *)chainedEventDataHoldersFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly includeAllDayEvents:(BOOL)includeAllDayEvents;
+ (NSArray *)eventsSearchedWithText:(NSString *)text startDate:(NSDate *)startDate endDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly;
+ (EKEvent *)event;
+ (EKEvent *)eventWithIdentifier:(NSString *)eid;
+ (NSError *)saveEvent:(EKEvent *)event forAllOccurrences:(BOOL)forAll;
+ (NSError *)removeEvent:(EKEvent *)event forAllOccurrences:(BOOL)forAll;
+ (NSArray *)eventCalendars;
+ (EKCalendar *)defaultCalendarForNewEvents;

#pragma mark - Reminders

+ (void)remindersForDate:(NSDate *)date completion:(void (^)(NSArray *reminders))completion;

#pragma mark - Calendars

+ (NSArray *)editableCalendarsForEntityType:(EKEntityType)entityType;
+ (NSArray *)calendarSources;
+ (EKCalendar *)calendarWithIdentifier:(NSString *)identifier;
+ (NSError *)saveCalendar:(EKCalendar *)calendar;
+ (NSError *)removeCalendar:(EKCalendar *)calendar;

@end
