//
//  NSDate+UIHelpers.m
//  calvetica
//
//  Created by Adam Kirk on 4/23/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSDate+ViewHelpers.h"

#define DAY_DURATION 86400


@implementation NSDate (ViewHelpers)


- (NSUInteger)numberOfCalendarRowsInCurrentMonth 
{
    NSInteger weekDayStart = [self weekdayStartOfCurrentMonth];
    return ceil((weekDayStart - 1 + [self daysInCurrentMonth]) / 7.0f);
}

+ (NSString *)stringWithWeekDayAbbreviated:(BOOL)abbr forWeekdayIndex:(NSInteger)index {
    NSAssert(index >= 1 && index <= 7, @"index must be between 1 and 7 inclusive");
    
    NSDate *date = [[[NSDate date] startOfCurrentWeek] dateDaysAfter:(index - 1)];
    
    // use date formatter to generate the name of the weekday at that index
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:(abbr ? @"EE" : @"EEEE")];
    return [formatter stringFromDate:date];
}

- (CGFloat)percentIntoDay 
{
    return [self secondsIntoDay] / SECONDS_IN_DAY;
}



#pragma mark - iPhone month view helpers

- (NSDate *)dateForCalendarSquare:(NSUInteger)index shiftedToBottom:(BOOL)shifted 
{
    
    if (index > 41) return [NSDate date];
    
    NSUInteger numberOfRows = [self numberOfCalendarRowsInCurrentMonth];
    
    NSInteger startOfMonthIndexOffset;
    NSInteger weekDayStart = [self weekdayStartOfCurrentMonth];
    if (shifted) {
        // add the weekday to the (number of rows left over times 7)
        // this is because we want the calendar to fill the bottom rows first (since the top is what gets slided out of view on short months)
        startOfMonthIndexOffset = weekDayStart + (7 * (6 - numberOfRows));        
    } else {
        startOfMonthIndexOffset = weekDayStart;        
    }
    
    // adjust the index to be relative to the start of the month
    NSInteger day = index - startOfMonthIndexOffset + 2;
    
    return [NSDate dateFromYear:[self year] month:[self monthOfYear] day:day];
}

- (NSUInteger)calendarMonth:(NSDate *)startOfMonth squareIndexShiftedToBottom:(BOOL)shifted 
{
    
    NSUInteger numberOfRows = [startOfMonth numberOfCalendarRowsInCurrentMonth];
    
    NSInteger startOfMonthIndexOffset;
    NSInteger weekDayStart = [startOfMonth weekdayStartOfCurrentMonth];
    if (shifted) {
        startOfMonthIndexOffset = weekDayStart + (7 * (6 - numberOfRows));
    } else {
        startOfMonthIndexOffset = weekDayStart;
    }
    
    return startOfMonthIndexOffset + [self daysSinceDate:startOfMonth] - 1;
}

- (NSInteger)weekNumberForSquareIndex:(NSUInteger)index 
{
//    NSInteger weekdayIndex = [self weekdayStartOfCurrentMonth];
//    NSInteger newWeekdayIndex = [NSDate convertWeekdayIndex:weekdayIndex];
//    index -= (newWeekdayIndex > weekdayIndex) ? 1 : 0;
    NSDate *weekDate = [[self startOfCurrentMonth] dateWeeksAfter:index];
    return [weekDate weekOfYear];
}

- (NSDate *)dateForFirstVisibleCalendarSquare 
{
    NSInteger weekDayStart = [self weekdayStartOfCurrentMonth];
    return [[[self startOfCurrentMonth] startOfNextDay] dateDaysBefore:weekDayStart];
}

- (NSDate *)dateForLastVisibleCalendarSquare 
{
    NSInteger nextMonthStartWeekday = [[self startOfNextMonth] weekdayStartOfCurrentMonth];
    return [[self endOfCurrentMonth] dateDaysAfter:(nextMonthStartWeekday == 1 ? 0 : 8 - nextMonthStartWeekday)];
}



#pragma mark - iPad month view table helpers

// assumes self is the start date
- (NSDate *)dateOfFirstDayOnRow:(NSInteger)row 
{
    return [[self dateWeeksAfter:row] startOfCurrentWeek];
}

- (NSInteger)rowOfDate:(NSDate *)date 
{
    return [date weeksSinceDate:self];
}

- (NSInteger)columnOfDate:(NSDate *)date 
{
    NSInteger row = [self rowOfDate:date];
    NSDate *firstDate = [self dateOfFirstDayOnRow:row];
    return [date daysSinceDate:firstDate];
}

- (CGRect)rectOfDayButtonInTableView:(UITableView *)tableView forDate:(NSDate *)date 
{
    CGRect rect = CGRectZero;

    NSInteger row = [self rowOfDate:date];
    CGFloat boxHeight = tableView.rowHeight;
    
    CGFloat boxWidth = tableView.frame.size.width / 7.0;
    
    rect.origin.x = [self columnOfDate:date] * boxWidth;
    rect.origin.y = row * boxHeight;
    rect.size.width = boxWidth;
    rect.size.height = boxHeight;
    
    return rect;
}


@end
