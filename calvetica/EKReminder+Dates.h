//
//  EKReminder+Dates.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKReminder (Dates)
@property (nonatomic, strong                   ) NSDate *startDate;
@property (nonatomic, strong                   ) NSDate *dueDate;
@property (nonatomic, assign, getter=isAllDay  ) BOOL   allDay;
@property (nonatomic, assign, getter=isFloating) BOOL   floating;
- (NSDate *)firstAvailableDate;
@end

NS_ASSUME_NONNULL_END
