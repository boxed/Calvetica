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
static EKEventStore *__sharedStore  = nil;


#pragma mark - Public

+ (EKEventStore *)sharedStore
{
    return __sharedStore;
}


#pragma mark (Permission)

+ (void)setPermissionGranted:(BOOL)granted
{
    __permissionGranted = YES;
}

+ (BOOL)isPermissionGranted
{
    return __permissionGranted;
}

+ (EKEventStore *)permissionStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedStore = [EKEventStore new];
    });
    return __sharedStore;
}

@end
