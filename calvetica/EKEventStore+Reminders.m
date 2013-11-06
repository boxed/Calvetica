//
//  EKEventStore+Reminders.m
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import "EKEventStore+Reminders.h"


static NSArray *__allReminders = nil;


@implementation EKEventStore (Reminders)

- (BOOL)remindersFromDate:(NSDate *)fromDate
                   toDate:(NSDate *)toDate
                calendars:(NSArray *)calendars
                  options:(MYSEKEventStoreReminderFetchOptions)options
               completion:(void (^)(NSArray *reminders))completion
{
    if (![EKEventStore isPermissionGranted]) return YES;
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
        if (completion) completion(allReminders ?: @[]);
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
