//
//  EKEvent+RelativeToDay.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKEvent (RelativeToDay)
- (NSDate *)startDateRelativeToDate:(NSDate *)date;
- (BOOL)allDayRelativeToDate:(NSDate *)date;
- (BOOL)occursAtAllBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate;
- (BOOL)spansEntireDayOfDate:(NSDate *)date;
- (BOOL)spansEntireDayOfOnlyDate:(NSDate *)date;
- (BOOL)fitsWithinDayOfDate:(NSDate *)date;
- (BOOL)startsOnSameDayAsDate:(NSDate *)dayDate;
- (CGFloat)durationForDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
