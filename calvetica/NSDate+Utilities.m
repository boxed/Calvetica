//
//  NSDate+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 8/17/12.
//
//

#import "NSDate+MTDates.h"
#import "geometry.h"
#import "times.h"


@implementation NSDate (Utilities)

#pragma mark - STRINGS

// Sunday, Sep 16, 2012
// Sunday, September 16, 2012
- (NSString *)stringWithWeekdayMonthDayYearMonthAbbreviated:(BOOL)abbreviated
{
	NSString *weekday = [self stringWithTitleOfCurrentWeekDayAbbreviated:abbreviated];
	NSString *month = [self stringWithTitleOfCurrentMonthAbbreviated:abbreviated];
	NSInteger day = [self dayOfMonth];
	NSInteger year = [self year];

	return [NSString stringWithFormat:@"%@, %@ %d, %d", weekday, month, day, year];
}

// Sep 16, 2012, 1:00 AM
- (NSString *)stringWithWeekdayMonthDayYearHourMinute
{
	if ([CVSettings isTwentyFourHourFormat])
		return [self stringFromDateWithFormat:@"EE d, yyyy, h:mm a"];
	else
		return [self stringFromDateWithFormat:@"EE d, yyyy, H:mm"];
}

// Since the alarm notification string is set only when the app is not active
// the notif strings are set according the event date and alarm fireDate.
- (NSString *)stringWithWeekdayMonthDayYearHourMinuteAlarmNotif:(NSDate *)fireDate 
{
    if ([self isWithinSameDay:fireDate]) {
        NSString *time = [self stringWithHourMinuteAndAMPM];
        // in rare cases stringWithHourMinuteAndAMPM already contains "Today" so just return it
        if ([time rangeOfString:@"Today"].location != NSNotFound) {
            return time;
        }
        else {
            return [NSString stringWithFormat:@"Today %@",[self stringWithHourMinuteAndAMPM]];
        }
    }
    // if the alarm goes off the day before the event set the notif to say tomorrow
    else if ([[self startOfNextDay] isEqualToDate:[fireDate startOfCurrentDay]]) {
        NSString *time = [self stringWithHourMinuteAndAMPM];
        // in rare cases stringWithHourMinuteAndAMPM already contains "Tomorrow" so just return it
        if ([time rangeOfString:@"Tomorrow"].location != NSNotFound) {
            return time;
        }
        else {
            return [NSString stringWithFormat:@"Tomorrow %@",[self stringWithHourMinuteAndAMPM]];
        }
    }
    else {
        return [self stringWithWeekdayMonthDayYearHourMinute];
    }
}

// Sep
// September
- (NSString *)stringWithTitleOfCurrentMonthAbbreviated:(BOOL)abbreviated 
{
	return [self stringFromDateWithFormat:(abbreviated ? @"MMM" : @"MMMM")];
}

// Sep 2012
// September 2012
- (NSString *)stringWithTitleOfCurrentMonthAndYearAbbreviated:(BOOL)abbreviated 
{
	return [self stringFromDateWithFormat:(abbreviated ? @"MMM yyyy" : @"MMMM yyyy")];
}

// Sun
// Sunday
- (NSString *)stringWithTitleOfCurrentWeekDayAbbreviated:(BOOL)abbreviated 
{
	return [self stringFromDateWithFormat:(abbreviated ? @"EE" : @"EEEE")];
}

// Sun 16
// Sunday 16
- (NSString *)stringWithTitleOfCurrentWeekDayAndMonthDayAbbreviated:(BOOL)abbreviated 
{
    NSString *weekday = [NSString stringWithFormat:@"%@ %d", [self stringWithTitleOfCurrentWeekDayAbbreviated:abbreviated], [self dayOfMonth]];
    return weekday;
}

// 1:00
- (NSString *)stringWithHourAndMinute 
{
	return [self stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H:mm" : @"h:mm")];
}

// AM
- (NSString *)stringWithAMPM 
{
    if ([CVSettings isTwentyFourHourFormat]) {
        return @"";
    }

	return [self stringFromDateWithFormat:@"a"];
}

// 1:00AM
- (NSString *)stringWithHourMinuteAndAMPM 
{
	return [self stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H:mm" : @"h:mma")];
}

// 1:00am
- (NSString *)stringWithHourMinuteAndLowercaseAMPM 
{
	return [[self stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H:mm" : @"h:mma")] lowercaseString];
}

// Sun Sep 16
// Sunday September 16
- (NSString *)stringWithWeekdayAbbreviated:(BOOL)weekDayAbbr monthDayAbbreviated:(BOOL)monthDayAbbr 
{
    if (weekDayAbbr && monthDayAbbr) {
		return [self stringFromDateWithFormat:@"EE MMM d"];
    }
    else if (!weekDayAbbr && !monthDayAbbr) {
		return [self stringFromDateWithFormat:@"EEE MMME d"];
    }
    else if (weekDayAbbr && !monthDayAbbr) {
		return [self stringFromDateWithFormat:@"EE MMMM d"];
    }
    else if (!weekDayAbbr && monthDayAbbr) {
		return [self stringFromDateWithFormat:@"EEE MMM d"];
    }

    return @"";
}

// Sep 16
// September 16
- (NSString *)stringWithMonthAndDayAbbreviated:(BOOL)abbreviated 
{
	return [self stringFromDateWithFormat:(abbreviated ? @"MMM d" : @"MMMM d")];
}

// 1am
- (NSString *)stringWithHourAndLowercaseAMPM 
{
	return [[self stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H" : @"ha")] lowercaseString];
}

// 8 hours, 20 minutes after
- (NSString *)stringWithGreatestComponentsForInterval:(NSTimeInterval)interval 
{

	NSMutableString *s = [NSMutableString string];

	NSTimeInterval absInterval = CVABS(interval);

	NSInteger months = floor(absInterval / (float)SECONDS_IN_MONTH);

	if (months > 0) {
		[s appendFormat:@"%d months, ", months];
		absInterval -= months * SECONDS_IN_MONTH;
	}

	NSInteger days = floor(absInterval / (float)SECONDS_IN_DAY);

	if (days > 0) {
		[s appendFormat:@"%d days, ", days];
		absInterval -= days * SECONDS_IN_DAY;
	}

	NSInteger hours = floor(absInterval / (float)SECONDS_IN_HOUR);

	if (hours > 0) {
		[s appendFormat:@"%d hours, ", hours];
		absInterval -= hours * SECONDS_IN_HOUR;
	}

	NSInteger minutes = floor(absInterval / (float)SECONDS_IN_MINUTE);

	if (minutes > 0) {
		[s appendFormat:@"%d minutes, ", minutes];
		absInterval -= minutes * SECONDS_IN_MINUTE;
	}

	NSInteger seconds = absInterval;

	if (seconds > 0) {
		[s appendFormat:@"%d seconds, ", seconds];
	}

	NSString *preString = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];

	return interval < 0 ? [NSString stringWithFormat:@"%@ before", preString] : [NSString stringWithFormat:@"%@ after", preString];
}

// 9/16/12, 1:00 AM
- (NSString *)stringWithRelativeShortStyle 
{
	return [self stringFromDateWithFormat:@"M/d/yy, h:mm a"];
}

// Sun · 16 
- (NSString *)stringWithWeekdayDotDay 
{
	return [self stringFromDateWithFormat:@"EE · dd"];
}

// Sep 16, 2012 - Sep 23, 2012 · Week 38
- (NSString *)stringWithWeekDateSpanDotWeekNumber 
{
    NSString *firstDay = [[self startOfCurrentWeek] stringFromDateWithFormat:@"MMM dd, yyyy"];
    NSString *lastDay = [[self endOfCurrentWeek] stringFromDateWithFormat:@"MMM dd, yyyy"];
    return [NSString stringWithFormat:@"%@ - %@ · Week %d", firstDay, lastDay, [self weekOfYear]];
}

@end
