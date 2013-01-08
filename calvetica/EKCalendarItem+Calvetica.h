//
//  EKCalendarItem+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 9/15/12.
//
//

#import <EventKit/EventKit.h>

@interface EKCalendarItem (Calvetica)
+ (EKCalendarItem *)calendarItemWithIdentifier:(NSString *)identifier;
- (BOOL)isEvent;
- (NSString *)identifier;
- (BOOL)isEqualToCalendarItem:(EKCalendarItem *)calendarItem;
- (BOOL)hasIdentifier:(NSString *)identifier;
@end
