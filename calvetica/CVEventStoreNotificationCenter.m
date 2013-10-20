//
//  CVEventStoreNotificationCenter.m
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import "CVEventStoreNotificationCenter.h"
#import "CVEventStoreNotification.h"
#import "MYSStack.h"


@interface CVEventStoreNotificationCenter ()
@property (nonatomic, strong) MYSStack *stack;
@end


@implementation CVEventStoreNotificationCenter

+ (instancetype)sharedCenter
{
    static CVEventStoreNotificationCenter *eventNotificationCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventNotificationCenter = [CVEventStoreNotificationCenter new];
    });
    return eventNotificationCenter;
}

- (id)init
{
    self = [super init];
    if (self) {
        _stack = [MYSStack new];
    }
    return self;
}

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventStoreDidChange:)
                                                 name:EKEventStoreChangedNotification
                                               object:nil];
}




#pragma mark - Public

- (void)listenForNotificationAboutCalendarItem:(EKCalendarItem *)calendarItem
                                    changeType:(CVNotificationChangeType)type
{
    CVEventStoreNotification *notif = [CVEventStoreNotification new];
    notif.calendarObject            = calendarItem;
    notif.changeType                = type;
    notif.source                    = CVNotificationSourceInternal;
    [self.stack push:notif];
}




#pragma mark - Notifications

+ (void)eventStoreDidChange:(NSNotification *)notification
{
    @synchronized (self) {
        NSArray *objectIDs              = notification.userInfo[@"EKEventStoreChangedObjectIDsUserInfoKey"];
        CVEventStoreNotification *notif = [[CVEventStoreNotificationCenter sharedCenter].stack firstObject];

        if (!notif) {
            [[CVEventStoreNotificationCenter sharedCenter] postNotification:nil];
            return;
        }
        else if ([objectIDs count] > 1) {
            [[CVEventStoreNotificationCenter sharedCenter] postNotification:nil];
            return;
        }
        else {
            NSString *identifierString = [NSString stringWithFormat:@"%@", [objectIDs lastObject]];
            if ([identifierString rangeOfString:@"Task"].location != NSNotFound) {
                if (notif.calendarObject.isEvent) {
                    [[CVEventStoreNotificationCenter sharedCenter] postNotification:nil];
                    return;
                }
            }
        }

        // if it passed all those tests, it must have been an internal change that triggered the notif.
        notif = [[CVEventStoreNotificationCenter sharedCenter].stack shift];
        [[CVEventStoreNotificationCenter sharedCenter] postNotification:notif];
    }
}


#pragma mark - Private

- (void)postNotification:(CVEventStoreNotification *)notif
{
    // if no notif, it must be external
    if (!notif) {
        notif               = [CVEventStoreNotification new];
        notif.source        = CVNotificationSourceExternal;
        notif.changeType    = CVNotificationChangeTypeUnknown;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:CVEventStoreChangedNotification
                                                        object:notif
                                                      userInfo:nil];
}

@end




NSString *const CVEventStoreChangedNotification = @"CVEventStoreChangedNotification";
