//
//  EKEventStore+Shared.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


typedef NS_OPTIONS(NSUInteger, MYSEKEventStoreReminderFetchOptions) {
    MYSEKEventStoreReminderFetchOptionsNone                = 0,
    MYSEKEventStoreReminderFetchOptionsExcludeFloating     = 1UL << 0,
    MYSEKEventStoreReminderFetchOptionsExcludeCompleted    = 1UL << 1
};


@interface EKEventStore (Shared)

+ (EKEventStore *)sharedStore;

// asking permission
+ (EKEventStore *)permissionStore;
+ (void)setPermissionGranted:(BOOL)granted;
+ (BOOL)isPermissionGranted;

#pragma mark - Events

+ (NSArray *)eventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly;
//+ (NSArray *)chainedEventModelsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly includeAllDayEvents:(BOOL)includeAllDayEvents;
+ (NSArray *)eventsSearchedWithText:(NSString *)text startDate:(NSDate *)startDate endDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly;
+ (EKEvent *)event;
+ (EKEvent *)eventWithIdentifier:(NSString *)eid;
+ (NSArray *)eventCalendars;
+ (EKCalendar *)defaultCalendarForNewEvents;

#pragma mark - Reminders

/**
 * returns YES if able to return immediately with cached remindres. Otherwise NO if it has to fetch.
 */
- (BOOL)remindersFromDate:(NSDate *)fromDate
                   toDate:(NSDate *)toDate
                calendars:(NSArray *)calendars
                  options:(MYSEKEventStoreReminderFetchOptions)options
               completion:(void (^)(NSArray *reminders))completion;

/**
 * Clears the reminders cache. Call this any time the reminders store may have changed.
 */
- (void)clearRemindersCache;
- (void)clearRemindersCacheAndReloadWithCompletion:(void (^)(void))completion;


#pragma mark - Calendars

+ (NSArray *)editableCalendarsForEntityType:(EKEntityType)entityType;
+ (NSArray *)calendarSources;
+ (EKCalendar *)calendarWithIdentifier:(NSString *)identifier;
+ (NSError *)saveCalendar:(EKCalendar *)calendar;
+ (NSError *)removeCalendar:(EKCalendar *)calendar;

@end
