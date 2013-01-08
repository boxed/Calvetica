//
//  CTTask.h
//  calvetica
//
//  Created by Adam Kirk on 5/20/11.
//  Copyright (c) 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CTTask : NSManagedObject
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSNumber  *priority;
@property (nonatomic, strong) NSDate    *due;
@property (nonatomic, strong) NSDate    *completed;
@property (nonatomic, strong) NSString  *notes;
@property (nonatomic, strong) NSDate    *created;
@property (nonatomic, strong) NSDate    *lastSynced;
@property (nonatomic, strong) NSNumber  *syncingOperationNeeded;
@property (nonatomic, strong) NSDate    *modified;
@property (nonatomic, strong) NSString  *location;
@property (nonatomic, strong) NSString  *UUID;
@property (nonatomic, strong) NSString  *group_UUID;

@end
