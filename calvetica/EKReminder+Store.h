//
//  EKReminder+Store.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKReminder (Store)
- (BOOL)saveWithError:(NSError **)error;
- (BOOL)deleteWithError:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
