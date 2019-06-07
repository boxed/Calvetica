//
//  calveticaAppDelegate.h
//  calvetica
//
//  Created by Adam Kirk on 3/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@interface CVAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

#pragma mark - Handle Local Notif Received
- (void)handleSnoozeActionBecauseOfNotificationWhileOpen:(UILocalNotification *)notif;
- (void)handleSnoozeActionBecauseOfNotification:(UILocalNotification *)notif;

#pragma mark - Local Notifs
- (void)setLocalNotifs;
- (void)scheduleBadgeNotifications:(NSInteger)count;
- (void)setCalveticaAlarms:(NSInteger)count;
+ (BOOL)hasNotch;
@end
