//
//  KBStore.m
//  calvetica
//
//  Created by Adam Kirk on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//




#import "KBStore.h"
#import "NSURLConnection+Utilities.h"
#import "knowledgebaseapi.h"




@interface KBStore ()
- (NSArray *)questions;
#pragma mark - Core Data Stack
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end




@implementation KBStore




static KBStore *sharedInstance = nil;




@synthesize managedObjectContext		= __managedObjectContext;
@synthesize managedObjectModel			= __managedObjectModel;
@synthesize persistentStoreCoordinator	= __persistentStoreCoordinator;




+ (KBStore *)sharedStore {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedStore];
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}


#pragma mark - Questions

- (NSArray *)questions 
{
    
    // create the fetch request for reminders
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KBQuestion" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // fetch them sorted by due date
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updated" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    
    // do the fetch
    NSError *error = nil;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Handle the error.
    }
    
    
    return fetchResults;
}

+ (NSArray *)existingQuestionsAndPullNew {
	KBStore *instance = [KBStore sharedStore];
	
	[instance getLatestFromServer];
    
    return [instance questions];
}

+ (NSArray *)existingQuestions {
	KBStore *instance = [KBStore sharedStore];
    
    return [instance questions];
}

+ (NSArray *)searchWithText:(NSString *)text {
    // create search predicate
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"question CONTAINS[cd] %@ || answerText CONTAINS[cd] %@", text, text];
    
    // get the questions from the store
    NSMutableArray *questions = [NSMutableArray arrayWithArray:[KBStore existingQuestions]];
    
    // create an array that we will add all our found results to
	NSMutableArray *results = [NSMutableArray array];
	
		
    [questions filterUsingPredicate:searchPredicate];
    [results addObjectsFromArray:questions];
    
    return results;
}

+ (KBQuestion *)question {
	KBStore *instance = [KBStore sharedStore];
    
    // creat the new reminder
    KBQuestion *question = (KBQuestion *)[NSEntityDescription insertNewObjectForEntityForName:@"KBQuestion" inManagedObjectContext:instance.managedObjectContext];
	
    question.answerHTML = @"";
    question.answerText = @"";
    question.priority = @1;
	question.product = @"Calvetica";
	question.question = @"";
	question.views = @0;
    question.updated = [NSDate date];
	
    return question;
}

+ (KBQuestion *)questionWithID:(NSString *)ID {
	KBStore *instance = [KBStore sharedStore];
    
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %@", ID];
	
    // create the fetch request for reminders
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"KBQuestion" inManagedObjectContext:instance.managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    
    // do the fetch
    NSError *error = nil;
    NSArray *fetchResults = [instance.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResults == nil) {
        // Handle the error.
    }
    
    
    return [fetchResults lastObject];
}

+ (void)saveQuestion:(KBQuestion *)question {
	KBStore *instance = [KBStore sharedStore];
    [instance saveContext];
}

- (void)getLatestFromServer 
{
	
	dispatch_async([CVOperationQueue backgroundQueue], ^(void) {
		
		// send it to the server
		NSError *error = nil;
		CVURLConnectionResult result;
		NSString *url = [NSString stringWithFormat:@"%@?product=calvetica&device_id=%@", KNOWLEDGE_BASE_QUESTIONS_URL, [CVSettings deviceID]];
		NSArray *returnedObject = [NSURLConnection JSONFromURL:url
												 usingUsername:nil
													  password:nil
														method:@"GET"
												   sendingBody:nil
														result:&result
														 error:&error];
		
        // see what we're getting back from the server
        CVLog(@"result:%d error:%@", result, error);
		
		// if we got a reply
		if (result == CVURLConnectionResultSuccess) {
			
			// the server returns all the questions that have been updated since the last request
			for (NSDictionary *questionDictWrapper in returnedObject) {
				NSDictionary *questionDict = [questionDictWrapper objectForKey:@"question"];
				NSString *questionID = [questionDict objectForKey:@"id"];

				
				// see if the object already exists
				KBQuestion *question = [KBQuestion questionWithID:questionID];
				
				// if it doesn't already exist create the object
				if (!question) {
					[KBQuestion questionCreatedFromDictionary:questionDict];
				}
				
				// if it already exists  just update the object
				else {
					[question updateQuestionFromDictionary:questionDict];
				}
				
			}
			
			// commit the changes all at once
			[self saveContext];
			
			// post the notification that the sync was completed and changes were made to the local db
			[[NSNotificationCenter defaultCenter] postNotificationName:KBStoreFinishedUpdatingNotification object:self];
		}
	});
}




#pragma mark - Core Data stack

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KnowledgeBase" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KnowledgeBase.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end




NSString *const KBStoreFinishedUpdatingNotification	= @"KBStoreFinishedUpdatingNotification";
