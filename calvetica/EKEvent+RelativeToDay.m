//
//  EKEvent+RelativeToDay.m
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import "EKEvent+Utilities.h"


@implementation EKEvent (RelativeToDay)

- (NSDate *)startDateRelativeToDate:(NSDate *)date
{
    return [self.startingDate mt_isWithinSameDay:date] ? self.startingDate : nil;
}

- (BOOL)allDayRelativeToDate:(NSDate *)date
{
    return self.isAllDay || [self spansEntireDayOfDate:date];
}

- (BOOL)occursAtAllOnDate:(NSDate *)date
{
	NSDate *startDate   = [date mt_startOfCurrentDay];
    NSDate *endDate     = [date mt_endOfCurrentDay];
    return [self.endingDate mt_isOnOrAfter:startDate] && [self.startingDate mt_isOnOrBefore:endDate];
}

- (BOOL)spansEntireDayOfDate:(NSDate *)date
{
    return [self.startingDate mt_isOnOrBefore:[date mt_startOfCurrentDay]] && [self.endingDate mt_isOnOrAfter:[date mt_endOfCurrentDay]];
}

- (BOOL)spansEntireDayOfOnlyDate:(NSDate *)date
{
    return [self.startingDate isEqualToDate:[date mt_startOfCurrentDay]] && [self.endingDate isEqualToDate:[date mt_endOfCurrentDay]];
}

- (BOOL)fitsWithinDayOfDate:(NSDate *)date
{
    return [self.startingDate mt_isWithinSameDay:date] && [self.endingDate mt_isWithinSameDay:date];
}

- (BOOL)startsOnSameDayAsDate:(NSDate *)dayDate
{
    NSDate *eventStart = self.startingDate;
    if ([eventStart mt_year]        == [dayDate mt_year] &&
        [eventStart mt_monthOfYear] == [dayDate mt_monthOfYear] &&
        [eventStart mt_dayOfMonth]  == [dayDate mt_dayOfMonth]) {

        return YES;
    }
    return NO;
}

- (CGFloat)durationForDate:(NSDate *)date
{
	if ([self.startingDate mt_isWithinSameDay:date]) {
		return [self eventDuration];
	}
	else if ([self.endingDate mt_isWithinSameDay:date]) {
		return [self.endingDate timeIntervalSinceDate:[self.endingDate mt_startOfCurrentDay]];
	}
	return 0;
}


@end
