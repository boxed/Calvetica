//
//  NSDate+Utilities.h
//  calvetica
//
//  Created by Adam Kirk on 8/17/12.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)

#pragma mark - STRINGS

- (NSString *)stringWithWeekdayMonthDayYearMonthAbbreviated:(BOOL)abbreviated;
- (NSString *)stringWithWeekdayMonthDayYearHourMinute;
- (NSString *)stringWithWeekdayMonthDayYearHourMinuteAlarmNotif:(NSDate *)fireDate;
- (NSString *)stringWithTitleOfCurrentMonthAbbreviated:(BOOL)abbreviated;
- (NSString *)stringWithTitleOfCurrentMonthAndYearAbbreviated:(BOOL)abbreviated;
- (NSString *)stringWithTitleOfCurrentWeekDayAbbreviated:(BOOL)abbreviated;
- (NSString *)stringWithTitleOfCurrentWeekDayAndMonthDayAbbreviated:(BOOL)abbreviated;
- (NSString *)stringWithHourAndMinute;
- (NSString *)stringWithAMPM;
- (NSString *)stringWithHourMinuteAndAMPM;
- (NSString *)stringWithHourMinuteAndLowercaseAMPM;
- (NSString *)stringWithWeekdayAbbreviated:(BOOL)weekDayAbbr monthDayAbbreviated:(BOOL)monthDayAbbr;
- (NSString *)stringWithMonthAndDayAbbreviated:(BOOL)abbreviated;
- (NSString *)stringWithHourAndLowercaseAMPM;
- (NSString *)stringWithGreatestComponentsForInterval:(NSTimeInterval)interval;
- (NSString *)stringWithRelativeShortStyle;
- (NSString *)stringWithWeekdayDotDay;
- (NSString *)stringWithWeekDateSpanDotWeekNumber;

@end
