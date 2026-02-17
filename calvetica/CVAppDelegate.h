//
//  calveticaAppDelegate.h
//  calvetica
//
//  Created by Adam Kirk on 3/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

@interface CVAppDelegate : NSObject <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

#pragma mark - Handle Local Notif Received
- (void)handleSnoozeActionForNotificationWhileOpen:(NSDictionary *)userInfo soundName:(NSString *)soundName;
- (void)handleSnoozeActionForNotification:(NSDictionary *)userInfo;

#pragma mark - Local Notifs
- (void)setLocalNotifs;
- (void)scheduleBadgeNotifications:(NSInteger)count;
- (void)setCalveticaAlarms:(NSInteger)count;
+ (BOOL)hasNotch;
@end
