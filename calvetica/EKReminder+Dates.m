//
//  EKReminder+Dates.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKReminder+Dates.h"
#import <NSDateComponents+MTDates.h>

@implementation EKReminder (Dates)

- (NSDate *)startDate
{
    return [NSDate mt_dateFromComponents:self.startDateComponents];
}

- (void)setStartDate:(NSDate *)startDate
{
    NSDateComponents *components = [startDate mt_components];
    if (self.isAllDay) {
        components.hour     = NSDateComponentUndefined;
        components.minute   = NSDateComponentUndefined;
        components.second   = NSDateComponentUndefined;
    }
    self.startDateComponents = components;
}

- (NSDate *)dueDate
{
    return [NSDate mt_dateFromComponents:self.dueDateComponents];
}

- (void)setDueDate:(NSDate *)dueDate
{
    NSDateComponents *components = [dueDate mt_components];
    if (self.isAllDay) {
        components.hour     = NSDateComponentUndefined;
        components.minute   = NSDateComponentUndefined;
        components.second   = NSDateComponentUndefined;
    }
    self.startDateComponents = components;
}

- (BOOL)isAllDay
{
    NSDateComponents *dateComponents = self.dueDateComponents ?: self.startDateComponents;
    return dateComponents.hour == NSDateComponentUndefined;
}

- (void)setAllDay:(BOOL)allDay
{
    NSDate *startDate = self.startDate;
    if (startDate) {
        NSDateComponents *dateComponents = [[startDate mt_startOfCurrentDay] mt_components] ;
        if (allDay) {
            dateComponents.hour     = NSDateComponentUndefined;
            dateComponents.minute   = NSDateComponentUndefined;
            dateComponents.second   = NSDateComponentUndefined;
        }
        self.startDateComponents = dateComponents;
    }

    NSDate *dueDate = self.dueDate;
    if (dueDate) {
        NSDateComponents *dateComponents = [[dueDate mt_startOfCurrentDay] mt_components] ;
        if (allDay) {
            dateComponents.hour     = NSDateComponentUndefined;
            dateComponents.minute   = NSDateComponentUndefined;
            dateComponents.second   = NSDateComponentUndefined;
        }
        self.dueDateComponents = dateComponents;
    }
}

- (BOOL)isFloating
{
    return (self.startDateComponents == nil) && (self.dueDateComponents == nil) && (self.completionDate == nil);
}

- (void)setFloating:(BOOL)floating
{
    self.startDateComponents    = nil;
    self.dueDateComponents      = nil;
    self.completionDate         = nil;
}

- (NSDate *)firstAvailableDate
{
    if (self.dueDateComponents) {
        return self.dueDate;
    }
    else if (self.startDateComponents) {
        return self.startDate;
    }
    else if (self.completionDate) {
        return self.completionDate;
    }
    return nil;
}

@end
