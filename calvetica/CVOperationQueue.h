//
//  CVOperationQueue.h
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@interface CVOperationQueue : NSObject

@property dispatch_queue_t backgroundQueue;
@property dispatch_queue_t localNotifQueue;

+ (dispatch_queue_t)backgroundQueue;
+ (dispatch_queue_t)localNotifQueue;

@end
