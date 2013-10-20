//
//  EKEvent+RelativeToDay.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

@interface EKEvent (RelativeToDay)
- (NSDate *)startDateRelativeToDate:(NSDate *)date;
- (BOOL)allDayRelativeToDate:(NSDate *)date;
- (BOOL)occursAtAllOnDate:(NSDate *)date;
- (BOOL)spansEntireDayOfDate:(NSDate *)date;
- (BOOL)spansEntireDayOfOnlyDate:(NSDate *)date;
- (BOOL)fitsWithinDayOfDate:(NSDate *)date;
- (BOOL)startsOnSameDayAsDate:(NSDate *)dayDate;
- (CGFloat)durationForDate:(NSDate *)date;
@end
