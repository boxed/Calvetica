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
static NSMutableDictionary *__stores = nil;
//static EKEventStore *__sharedStore  = nil;


#pragma mark - Public

+ (EKEventStore *)sharedStore
{
    NSString *name = [NSString stringWithUTF8String:dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)];

    // The lookup table is reached from the main queue and from background queues
    // (the inbox badge), and NSMutableDictionary tolerates neither concurrent
    // mutation nor being read while another thread mutates it.
    @synchronized (self) {
        if (!__stores) {
            __stores = [NSMutableDictionary new];
        }
        EKEventStore *store = __stores[name];
        if (!store) {
            store = [EKEventStore new];
            __stores[name] = store;
        }
        return store;
    }
}

+ (void)refreshSourcesForCurrentQueue
{
    if (![self isPermissionGranted]) return;
    [[self sharedStore] refreshSourcesIfNecessary];
}


#pragma mark (Permission)

+ (void)setPermissionGranted:(BOOL)granted
{
    __permissionGranted = granted;
}

+ (BOOL)isPermissionGranted
{
    if (!__permissionGranted) {
        __permissionGranted = [self isCalendarPermissionGranted];
    }
    return __permissionGranted;
}

+ (BOOL)isCalendarPermissionGranted
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    return status == EKAuthorizationStatusFullAccess || status == EKAuthorizationStatusAuthorized;
}

+ (BOOL)isReminderPermissionGranted
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    return status == EKAuthorizationStatusFullAccess || status == EKAuthorizationStatusAuthorized;
}

+ (EKEventStore *)permissionStore
{
    return [EKEventStore sharedStore];
}

@end
