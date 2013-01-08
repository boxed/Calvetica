//
//  KBStore.h
//  calvetica
//
//  Created by Adam Kirk on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBQuestion.h"
#import "CVDebug.h"

@interface KBStore : NSObject {
@private
    
}


@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (KBStore *)sharedStore;


#pragma mark - Questions
- (void)getLatestFromServer;
+ (NSArray *)existingQuestionsAndPullNew;
+ (NSArray *)existingQuestions;
+ (NSArray *)searchWithText:(NSString *)text;
+ (KBQuestion *)question;
+ (KBQuestion *)questionWithID:(NSString *)ID;
+ (void)saveQuestion:(KBQuestion *)question;


@end


extern NSString *const KBStoreFinishedUpdatingNotification;