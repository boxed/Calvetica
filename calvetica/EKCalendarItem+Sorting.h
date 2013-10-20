//
//  EKCalendarItem+Sorting.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

@interface EKCalendarItem (Sorting)
- (NSComparisonResult)compareWithCalendarItem:(EKCalendarItem *)calendarItem;
@end
