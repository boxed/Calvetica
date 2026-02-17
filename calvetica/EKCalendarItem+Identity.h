//
//  EKCalendarItem+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 9/15/12.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKCalendarItem (Identity)
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) BOOL isEvent;
@property (nonatomic, assign, readonly) BOOL isReminder;
+ (EKCalendarItem *)calendarItemWithIdentifier:(NSString *)identifier;
- (BOOL)isEqualToCalendarItem:(EKCalendarItem *)calendarItem;
- (BOOL)hasIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
