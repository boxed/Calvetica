//
//  KBQuestion.m
//  calvetica
//
//  Created by Adam Kirk on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KBQuestion.h"
#import "KBStore.h"
#import "NSDictionary+Utilities.h"


@implementation KBQuestion



@dynamic ID;
@dynamic answerHTML;
@dynamic answerText;
@dynamic priority;
@dynamic product;
@dynamic question;
@dynamic views;
@dynamic updated;




+ (KBQuestion *)questionWithID:(NSString *)ID {
	return [KBStore questionWithID:ID];
}

+ (KBQuestion *)questionCreatedFromDictionary:(NSDictionary *)questionDict {
    KBQuestion *newQuestion = [KBStore question];
	
    if ([questionDict objectForKey:@"id"] != [NSNull null]) {
        newQuestion.ID = @([[questionDict objectForKey:@"id"] integerValue]);
    }
    
	newQuestion.answerHTML = [questionDict stringForKey:@"answer"];
    newQuestion.answerText = [questionDict stringForKey:@"plain_text_answer"];
    
    if ([questionDict objectForKey:@"priority"] != [NSNull null]) {
        newQuestion.priority = @([[questionDict objectForKey:@"priority"] integerValue]);
    }
    
	newQuestion.product	= [questionDict stringForKey:@"product"];
	newQuestion.question = [questionDict stringForKey:@"question"];
    
    if ([questionDict objectForKey:@"views"] != [NSNull null]) {
        newQuestion.views = @([[questionDict objectForKey:@"views"] integerValue]);
    }
    
	newQuestion.updated = [NSDate dateFromISOString:[questionDict objectForKey:@"updated_at"]];
	
	return newQuestion;
}

- (void)updateQuestionFromDictionary:(NSDictionary *)questionDict 
{
    if ([questionDict objectForKey:@"id"] != [NSNull null]) {
        self.ID = @([[questionDict objectForKey:@"id"] integerValue]);
    }
	self.answerHTML = [questionDict stringForKey:@"answer"];
    self.answerText = [questionDict stringForKey:@"plain_text_answer"];
    
    if ([questionDict objectForKey:@"priority"] != [NSNull null]) {
        self.priority = @([[questionDict objectForKey:@"priority"] integerValue]);
    }

	self.product = [questionDict stringForKey:@"product"];
	self.question = [questionDict stringForKey:@"question"];
    
    if ([questionDict objectForKey:@"views"] != [NSNull null]) {
        self.views = @([[questionDict objectForKey:@"views"] integerValue]);
    }
	
	self.updated = [NSDate dateFromISOString:[questionDict objectForKey:@"updated_at"]];
}

- (void)save 
{
	[KBStore saveQuestion:self];
}




@end
