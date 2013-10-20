//
//  EKReminder+Store.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

@interface EKReminder (Store)
- (BOOL)saveWithError:(NSError **)error;
- (BOOL)deleteWithError:(NSError **)error;
@end
