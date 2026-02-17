//
//  calveticaAppDelegate.h
//  calvetica
//
//  Created by Adam Kirk on 3/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN


@interface CVAppDelegate : NSObject <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSTimer *refreshTimer;

#pragma mark - Handle Local Notif Received
- (void)handleSnoozeActionForNotificationWhileOpen:(NSDictionary *)userInfo soundName:(nullable NSString *)soundName;
- (void)handleSnoozeActionForNotification:(NSDictionary *)userInfo;

#pragma mark - Local Notifs
- (void)setLocalNotifs;
- (void)scheduleBadgeNotifications:(NSInteger)count;
- (void)setCalveticaAlarms:(NSInteger)count;

#pragma mark - Refresh
- (void)refreshSources;
- (void)scheduleRefreshTimer;

+ (nullable UIWindow *)mainWindow;
+ (BOOL)hasNotch;
@end

NS_ASSUME_NONNULL_END
