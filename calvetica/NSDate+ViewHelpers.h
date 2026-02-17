//
//  NSDate+UIHelpers.h
//  calvetica
//
//  Created by Adam Kirk on 4/23/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "times.h"

NS_ASSUME_NONNULL_BEGIN


@interface NSDate (ViewHelpers)

- (NSUInteger)numberOfCalendarRowsInCurrentMonth;
+ (NSString *)stringWithWeekDayAbbreviated:(BOOL)abbr forWeekdayIndex:(NSInteger)index;
- (CGFloat)percentIntoDay;

#pragma mark - iPhone month view helpers

- (NSDate *)dateForCalendarSquare:(NSUInteger)index shiftedToBottom:(BOOL)shifted;
- (NSUInteger)calendarMonth:(NSDate *)startOfMonth squareIndexShiftedToBottom:(BOOL)shifted;
- (NSInteger)weekNumberForSquareIndex:(NSUInteger)index;
- (NSDate *)dateForFirstVisibleCalendarSquare;
- (NSDate *)dateForLastVisibleCalendarSquare;

@end

NS_ASSUME_NONNULL_END
