//
//  EKReminder+RelativeToDay.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKReminder (RelativeToDay)
- (NSDate *)dateRelativeToDate:(NSDate *)date;
- (BOOL)occursBetweenDate:(NSDate *)date1 date:(NSDate *)date2;
@end

NS_ASSUME_NONNULL_END
