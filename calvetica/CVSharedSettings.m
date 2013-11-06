//
//  CVSharedSettings.m
//  calvetica
//
//  Created by Adam Kirk on 11/4/13.
//
//

#import "CVSharedSettings.h"
#import "times.h"
#import "CVEventSubtitleTextPriorityViewController.h"
#import "CVEventDetailsOrderViewController.h"


@implementation CVSharedSettings

@dynamic remindersEnabled;
@dynamic timezoneSupportEnabled;
@dynamic alwaysAskForCalendar;
@dynamic twentyFourHourFormat;
@dynamic dotsOnlyMonthView;
@dynamic iPhoneScrollableMonthView;
@dynamic showDurationOnReadOnlyEvents;
@dynamic localRootTableViewMode;
@dynamic hiddenEventCalendarIdentifiers;
@dynamic defaultEventCalendarIdentifier;
@dynamic customCalendarColors;
@dynamic defaultEventAlarms;
@dynamic defaultAllDayEventAlarms;
@dynamic defaultReminderAlarms;
@dynamic defaultAllDayReminderAlarms;
@dynamic defaultDuration;
@dynamic timeZoneName;
@dynamic weekStartsOnWeekday;
@dynamic badgeOrAlerts;
@dynamic dayStartHour;
@dynamic dayEndHour;
@dynamic customAlertSoundFileName;
@dynamic eventDetailsSubtitleTextPriority;
@dynamic eventDetailsOrdering;

- (NSDictionary *)defaults
{
    return @{
             @"remindersEnabled"                    : @YES,
             @"timezoneSupportEnabled"              : @NO,
             @"alwaysAskForCalendar"                : @NO,
             @"twentyFourHourFormat"                : @NO,
             @"dotsOnlyMonthView"                   : @NO,
             @"iPhoneScrollableMonthView"           : @YES,
             @"showDurationOnReadOnlyEvents"        : @NO,
             @"localRootTableViewMode"              : @(CVRootTableViewModeAgenda),
             @"hiddenEventCalendarIdentifiers"      : @[],
             @"customCalendarColors"                : @{},
             @"defaultEventAlarms"                  : @[@(MTDateConstantSecondsInMinute * 15)],
             @"defaultAllDayEventAlarms"            : @[@(MTDateConstantSecondsInHour * 6)],
             @"defaultEventReminder"                : @[@(MTDateConstantSecondsInMinute * 15)],
             @"defaultAllDayReminderAlarms"         : @[@(MTDateConstantSecondsInHour * 6)],
             @"defaultDuration"                     : @(MTDateConstantSecondsInHour),
             @"weekStartsOnWeekday"                 : @(1),
             @"badgeOrAlerts"                       : @(CVLocalNotificationTypeBadgeAndAlerts),
             @"dayStartHour"                        : @(9),
             @"dayEndHour"                          : @(5),
             @"eventDetailsSubtitleTextPriority"    : [CVEventSubtitleTextPriorityViewController standardSubtitleTextPriorityArray],
             @"eventDetailsOrdering"                : [CVEventDetailsOrderViewController standardDetailsOrderingArray]
             };
}

@end
