//
//  EKReminder+RelativeToDay.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKReminder+RelativeToDay.h"


@implementation EKReminder (RelativeToDay)

- (NSDate *)dateRelativeToDate:(NSDate *)date
{
    if (self.dueDateComponents && [self.dueDate mt_isWithinSameDay:date]) {
        return self.dueDate;
    }

    if (self.startDateComponents && [self.startDate mt_isWithinSameDay:date]) {
        return self.startDate;
    }

    return nil;
}

- (BOOL)occursBetweenDate:(NSDate *)date1 date:(NSDate *)date2
{
    if (self.dueDateComponents) {
        return [self.dueDate mt_isBetweenDate:date1 andDate:date2];
    }
    else if (self.startDateComponents) {
        return [self.startDate mt_isBetweenDate:date1 andDate:date2];
    }
    else if (self.completionDate) {
        return [self.completionDate mt_isBetweenDate:date1 andDate:date2];
    }
    return NO;
}

@end
