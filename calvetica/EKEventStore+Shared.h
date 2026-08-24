//
//  EKEventStore+Shared.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface EKEventStore (Shared)

+ (EKEventStore *)sharedStore;

// Refreshes the store belonging to the calling queue. Each queue gets its own
// store (see sharedStore), and refreshing one does nothing for any of the
// others, so every queue that reads calendars has to ask for itself.
+ (void)refreshSourcesForCurrentQueue;

+ (EKEventStore *)permissionStore;
+ (void)setPermissionGranted:(BOOL)granted;
+ (BOOL)isPermissionGranted;
+ (BOOL)isCalendarPermissionGranted;
+ (BOOL)isReminderPermissionGranted;

@end

NS_ASSUME_NONNULL_END