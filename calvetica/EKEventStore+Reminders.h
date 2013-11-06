//
//  EKEventStore+Reminders.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>


typedef NS_OPTIONS(NSUInteger, MYSEKEventStoreReminderFetchOptions) {
    MYSEKEventStoreReminderFetchOptionsNone                = 0,
    MYSEKEventStoreReminderFetchOptionsExcludeFloating     = 1UL << 0,
    MYSEKEventStoreReminderFetchOptionsExcludeCompleted    = 1UL << 1
};


@interface EKEventStore (Reminders)

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

@end
