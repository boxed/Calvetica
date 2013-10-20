//
//  EKCalendarItem+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 9/15/12.
//
//

#import <EventKit/EventKit.h>

@interface EKCalendarItem (Identity)
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) BOOL isEvent;
@property (nonatomic, assign, readonly) BOOL isReminder;
+ (EKCalendarItem *)calendarItemWithIdentifier:(NSString *)identifier;
- (BOOL)isEqualToCalendarItem:(EKCalendarItem *)calendarItem;
- (BOOL)hasIdentifier:(NSString *)identifier;
@end
