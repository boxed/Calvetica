//
//  EKCalendarItem+Sorting.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKCalendarItem (Sorting)
- (NSComparisonResult)compareWithCalendarItem:(EKCalendarItem *)calendarItem;
@end

NS_ASSUME_NONNULL_END
