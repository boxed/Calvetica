//
//  EKReminder+RelativeToDay.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

@interface EKReminder (RelativeToDay)
- (NSDate *)dateRelativeToDate:(NSDate *)date;
- (BOOL)occursBetweenDate:(NSDate *)date1 date:(NSDate *)date2;
@end
