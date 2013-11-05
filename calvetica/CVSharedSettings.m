//
//  CVSharedSettings.m
//  calvetica
//
//  Created by Adam Kirk on 11/4/13.
//
//

#import "CVSharedSettings.h"

@implementation CVSharedSettings

@dynamic remindersEnabled;
@dynamic timezoneSupportEnabled;
@dynamic alwaysAskForCalendar;
@dynamic twentyFourHourFormat;
@dynamic dotsOnlyMonthView;
@dynamic iPhoneScrollableMonthView;
@dynamic showDurationOnReadOnlyEvents;

- (NSDictionary *)defaults
{
    return @{
             @"remindersEnabled"                : @YES,
             @"timezoneSupportEnabled"          : @NO,
             @"alwaysAskForCalendar"            : @NO,
             @"twentyFourHourFormat"            : @NO,
             @"dotsOnlyMonthView"               : @NO,
             @"iPhoneScrollableMonthView"       : @YES,
             @"showDurationOnReadOnlyEvents"    : @NO
             };
}

@end
