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
//    NSString *name = [NSOperationQueue mainQueue].name;
    
    if (!__stores[name]) {
        __stores[name] = [EKEventStore new];
    }
    
    return __stores[name];
}


#pragma mark (Permission)

+ (void)setPermissionGranted:(BOOL)granted
{
    __permissionGranted = granted;
}

+ (BOOL)isPermissionGranted
{
    return __permissionGranted;
}

+ (EKEventStore *)permissionStore
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __stores = [NSMutableDictionary new]; //[EKEventStore new];
    });
    
    return [EKEventStore sharedStore];
}

@end
