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
	NSInteger day = [self mt_dayOfMonth];
	NSInteger year = [self mt_year];

	return [NSString stringWithFormat:@"%@, %@ %ld, %ld", weekday, month, (long)day, (long)year];
}

// Sep 16, 2012, 1:00 AM
- (NSString *)stringWithWeekdayMonthDayYearHourMinute
{
	if (![CVSettings isTwentyFourHourFormat])
		return [self mt_stringFromDateWithFormat:@"EE MMM d, yyyy, h:mm a" localized:YES];
	else
		return [self mt_stringFromDateWithFormat:@"EE MMM d, yyyy, H:mm" localized:YES];
}

// Since the alarm notification string is set only when the app is not active
// the notif strings are set according the event date and alarm fireDate.
- (NSString *)stringWithWeekdayMonthDayYearHourMinuteAlarmNotif:(NSDate *)fireDate 
{
    if ([self mt_isWithinSameDay:fireDate]) {
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
    else if ([[self mt_startOfNextDay] isEqualToDate:[fireDate mt_startOfCurrentDay]]) {
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
	return [self mt_stringFromDateWithFormat:(abbreviated ? @"MMM" : @"MMMM") localized:YES];
}

// Sep 2012
// September 2012
- (NSString *)stringWithTitleOfCurrentMonthAndYearAbbreviated:(BOOL)abbreviated 
{
	return [self mt_stringFromDateWithFormat:(abbreviated ? @"MMM yyyy" : @"MMMM yyyy") localized:YES];
}

// Sun
// Sunday
- (NSString *)stringWithTitleOfCurrentWeekDayAbbreviated:(BOOL)abbreviated 
{
	return [self mt_stringFromDateWithFormat:(abbreviated ? @"EE" : @"EEEE") localized:YES];
}

// Sun 16
// Sunday 16
- (NSString *)stringWithTitleOfCurrentWeekDayAndMonthDayAbbreviated:(BOOL)abbreviated 
{
    NSString *weekday = [NSString stringWithFormat:@"%@ %lu", [self stringWithTitleOfCurrentWeekDayAbbreviated:abbreviated], (unsigned long)[self mt_dayOfMonth]];
    return weekday;
}

// 1:00
- (NSString *)stringWithHourAndMinute 
{
	return [self mt_stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H:mm" : @"h:mm") localized:NO];
}

// AM
- (NSString *)stringWithAMPM 
{
    if ([CVSettings isTwentyFourHourFormat]) {
        return @"";
    }

	return [self mt_stringFromDateWithFormat:@"a" localized:NO];
}

// 1:00AM
- (NSString *)stringWithHourMinuteAndAMPM 
{
	return [self mt_stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H:mm" : @"h:mma") localized:NO];
}

// 1:00am
- (NSString *)stringWithHourMinuteAndLowercaseAMPM 
{
	return [[self mt_stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H:mm" : @"h:mma") localized:NO] lowercaseStringWithLocale:[NSLocale currentLocale]];
}

// Sun Sep 16
// Sunday September 16
- (NSString *)stringWithWeekdayAbbreviated:(BOOL)weekDayAbbr monthDayAbbreviated:(BOOL)monthDayAbbr 
{
    if (weekDayAbbr && monthDayAbbr) {
		return [self mt_stringFromDateWithFormat:@"EE MMM d" localized:YES];
    }
    else if (!weekDayAbbr && !monthDayAbbr) {
		return [self mt_stringFromDateWithFormat:@"EEE MMME d" localized:YES];
    }
    else if (weekDayAbbr && !monthDayAbbr) {
		return [self mt_stringFromDateWithFormat:@"EE MMMM d" localized:YES];
    }
    else if (!weekDayAbbr && monthDayAbbr) {
		return [self mt_stringFromDateWithFormat:@"EEE MMM d" localized:YES];
    }

    return @"";
}

// Sep 16
// September 16
- (NSString *)stringWithMonthAndDayAbbreviated:(BOOL)abbreviated 
{
	return [self mt_stringFromDateWithFormat:(abbreviated ? @"MMM d" : @"MMMM d") localized:YES];
}

// 1am
- (NSString *)stringWithHourAndLowercaseAMPM 
{
	return [[self mt_stringFromDateWithFormat:([CVSettings isTwentyFourHourFormat] ? @"H" : @"ha") localized:NO] lowercaseStringWithLocale:[NSLocale currentLocale]];
}

// 8 hours, 20 minutes after
- (NSString *)stringWithGreatestComponentsForInterval:(NSTimeInterval)interval 
{

	NSMutableString *s = [NSMutableString string];

	NSTimeInterval absInterval = CVABS(interval);

	NSInteger months = floor(absInterval / (float)SECONDS_IN_MONTH);

	if (months > 0) {
		[s appendFormat:@"%ld months, ", (long)months];
		absInterval -= months * SECONDS_IN_MONTH;
	}

	NSInteger days = floor(absInterval / (float)SECONDS_IN_DAY);

	if (days > 0) {
		[s appendFormat:@"%ld days, ", (long)days];
		absInterval -= days * SECONDS_IN_DAY;
	}

	NSInteger hours = floor(absInterval / (float)SECONDS_IN_HOUR);

	if (hours > 0) {
		[s appendFormat:@"%ld hours, ", (long)hours];
		absInterval -= hours * SECONDS_IN_HOUR;
	}

	NSInteger minutes = floor(absInterval / (float)SECONDS_IN_MINUTE);

	if (minutes > 0) {
		[s appendFormat:@"%ld minutes, ", (long)minutes];
		absInterval -= minutes * SECONDS_IN_MINUTE;
	}

	NSInteger seconds = absInterval;

	if (seconds > 0) {
		[s appendFormat:@"%ld seconds, ", (long)seconds];
	}

	NSString *preString = [s stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];

	return interval < 0 ? [NSString stringWithFormat:@"%@ before", preString] : [NSString stringWithFormat:@"%@ after", preString];
}

// 9/16/12, 1:00 AM
- (NSString *)stringWithRelativeShortStyle 
{
	return [self mt_stringFromDateWithFormat:@"M/d/yy, h:mm a" localized:YES];
}

// Sun · 16 
- (NSString *)stringWithWeekdayDotDay 
{
	return [self mt_stringFromDateWithFormat:@"EE · dd" localized:YES];
}

// Sep 16, 2012 - Sep 23, 2012 · Week 38
- (NSString *)stringWithWeekDateSpanDotWeekNumber 
{
    NSString *firstDay = [[self mt_startOfCurrentWeek] mt_stringFromDateWithFormat:@"MMM dd, yyyy" localized:YES];
    NSString *lastDay = [[self mt_endOfCurrentWeek] mt_stringFromDateWithFormat:@"MMM dd, yyyy" localized:YES];
    return [NSString stringWithFormat:@"%@ - %@ · Week %ld", firstDay, lastDay, (long)[self mt_weekOfYear]];
}

@end
