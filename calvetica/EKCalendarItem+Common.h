//
//  EKCalendarItem+Common.h
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKCalendarItem (Common)
- (NSDate *)mys_date;
- (NSString *)mys_title;
- (BOOL)mys_isAllDay;
@end

NS_ASSUME_NONNULL_END
