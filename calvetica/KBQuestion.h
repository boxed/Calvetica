//
//  KBQuestion.h
//  calvetica
//
//  Created by Adam Kirk on 7/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@interface KBQuestion : NSManagedObject {
@private
}


@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, strong) NSString * answerHTML;
@property (nonatomic, strong) NSString * answerText;
@property (nonatomic, strong) NSNumber * priority;
@property (nonatomic, strong) NSString * product;
@property (nonatomic, strong) NSString * question;
@property (nonatomic, strong) NSNumber * views;
@property (nonatomic, strong) NSDate * updated;


#pragma mark - Methods
+ (KBQuestion *)questionWithID:(NSString *)ID;
+ (KBQuestion *)questionCreatedFromDictionary:(NSDictionary *)questionDict;
- (void)updateQuestionFromDictionary:(NSDictionary *)questionDict;
- (void)save;


@end
