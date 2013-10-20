//
//  EKReminder+Sorting.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKReminder+Sorting.h"

@implementation EKReminder (Sorting)

- (NSComparisonResult)compareWithReminder:(EKReminder *)reminder
{
    NSComparisonResult result = [self.dueDate compare:reminder.dueDate];

    if (result != NSOrderedSame) {
        return result;
    }

    if (self.isAllDay != reminder.isAllDay) {
        return self.isAllDay ? NSOrderedAscending : NSOrderedDescending;
    }

    else if (self.isAllDay && reminder.isAllDay) {
        return [self.mys_title localizedCaseInsensitiveCompare:reminder.mys_title];
    }

    return NSOrderedSame;
}

@end
