//
//  CVOperationQueue.m
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

@implementation CVOperationQueue

static CVOperationQueue *__sharedInstance = nil;

+ (CVOperationQueue *)sharedInstance {
    if (__sharedInstance == nil) {
        __sharedInstance = [[super allocWithZone:NULL] init];
        __sharedInstance.backgroundQueue = dispatch_queue_create("com.mysterioustrousers.backgroundQueue", NULL);
		__sharedInstance.localNotifQueue = dispatch_queue_create("com.mysterioustrousers.localNotifQueue", NULL);
    }
    return __sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

+ (dispatch_queue_t)backgroundQueue {
    CVOperationQueue *instance = [CVOperationQueue sharedInstance];
    return instance.backgroundQueue;
}

+ (dispatch_queue_t)localNotifQueue {
    CVOperationQueue *instance = [CVOperationQueue sharedInstance];
    return instance.localNotifQueue;
}




@end
