//
//  EKEventStore+Shared.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@interface EKEventStore (Shared)

+ (EKEventStore *)sharedStore;

+ (EKEventStore *)permissionStore;
+ (void)setPermissionGranted:(BOOL)granted;
+ (BOOL)isPermissionGranted;

@end
