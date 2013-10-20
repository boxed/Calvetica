//
//  EKCalendarItem+Common.h
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import <EventKit/EventKit.h>

@interface EKCalendarItem (Common)
- (NSDate *)mys_date;
- (NSString *)mys_title;
- (BOOL)mys_isAllDay;
@end
