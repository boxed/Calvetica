//
//  EKCalendarItem+Sorting.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKCalendarItem+Sorting.h"


@implementation EKCalendarItem (Sorting)

- (NSComparisonResult)compareWithCalendarItem:(EKCalendarItem *)calendarItem
{
    if (self.isEvent && calendarItem.isEvent) {
        EKEvent *e1 = (EKEvent *)self;
        EKEvent *e2 = (EKEvent *)calendarItem;
        return [e1 compareWithEvent:e2];
    }

    else if (self.isReminder && calendarItem.isReminder) {
        EKReminder *r1 = (EKReminder *)self;
        EKReminder *r2 = (EKReminder *)calendarItem;
        return [r1 compareWithReminder:r2];
    }

    else {
        return [self.mys_date compare:calendarItem.mys_date];
    }
}

@end
