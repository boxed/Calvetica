//
//  EKEvent+Sorting.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKEvent+Sorting.h"

@implementation EKEvent (Sorting)

- (NSComparisonResult)compareWithEvent:(EKEvent *)event
{
    NSComparisonResult result = [self compareStartDateWithEvent:event];

    if (result != NSOrderedSame) {
        return result;
    }

    if (self.isAllDay != event.isAllDay) {
        return self.isAllDay ? NSOrderedAscending : NSOrderedDescending;
    }

    else if (self.isAllDay && event.isAllDay) {
        return [self.title localizedCaseInsensitiveCompare:event.title];
    }

    return NSOrderedSame;
}

@end
