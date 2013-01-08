//
//  CVTaskStore.h
//  calvetica
//
//  Created by Adam Kirk on 5/16/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CTTask.h"


@interface CTTaskStore : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (CTTaskStore *)sharedStore;
+ (NSArray *)tasksWithPredicate:(NSPredicate *)predicate;

#pragma mark - Context
+ (void)saveContext;
+ (BOOL)hasChanges;


#pragma mark - Core Data Stack
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
