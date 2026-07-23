//
//  CVSharedSettings.m
//  calvetica
//
//  Created by Adam Kirk on 11/4/13.
//
//

#import "CVSharedSettings.h"
#import "CVEventSubtitleTextPriorityViewController.h"
#import "CVEventDetailsOrderViewController.h"


CGFloat CVFontScale(void)
{
    if (IS_MAC) {
        return PREFS.fontScale;
    }
    UITraitCollection *baseTraits = [UITraitCollection traitCollectionWithPreferredContentSizeCategory:UIContentSizeCategoryLarge];
    CGFloat baseSize    = [UIFont preferredFontForTextStyle:UIFontTextStyleBody compatibleWithTraitCollection:baseTraits].pointSize;
    CGFloat currentSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
    if (baseSize <= 0) return 1.0f;
    return currentSize / baseSize;
}

CGFloat CVGridFontScale(void)
{
    CGFloat scale = CVFontScale();
    // Mac keeps its manual (uncapped) scale; cap only the iOS Dynamic Type scale
    // so the dense month/week grid stays within its fixed cells.
    return IS_MAC ? scale : MIN(scale, 2.0f);
}

CGFloat CVScaledFontSize(UIFontTextStyle textStyle)
{
    UITraitCollection *baseTraits = [UITraitCollection traitCollectionWithPreferredContentSizeCategory:UIContentSizeCategoryLarge];
    CGFloat baseSize = [UIFont preferredFontForTextStyle:textStyle compatibleWithTraitCollection:baseTraits].pointSize;
    return baseSize * CVFontScale();
}


@implementation CVSharedSettings

@dynamic remindersEnabled;
@dynamic timezoneSupportEnabled;
@dynamic alwaysAskForCalendar;
@dynamic twentyFourHourFormat;
@dynamic dotsOnlyMonthView;
@dynamic iPhoneScrollableMonthView;
@dynamic showDurationOnReadOnlyEvents;
@dynamic showWeekNumbers;
@dynamic showInboxBadge;
@dynamic localRootTableViewMode;
@dynamic fontScale;
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
@dynamic themeStyle;
@dynamic themeColorString;
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
             @"showWeekNumbers"                     : @NO,
             @"showInboxBadge"                      : @YES,
             @"localRootTableViewMode"              : @(CVRootTableViewModeAgenda),
             @"fontScale"                           : @(1.0f),
             @"hiddenEventCalendarIdentifiers"      : @[],
             @"customCalendarColors"                : @{},
             @"defaultEventAlarms"                  : @[@(MTDateConstantSecondsInMinute * 15)],
             @"defaultAllDayEventAlarms"            : @[@(MTDateConstantSecondsInHour * 6)],
             @"defaultEventReminder"                : @[@(MTDateConstantSecondsInMinute * 15)],
             @"defaultAllDayReminderAlarms"         : @[@(MTDateConstantSecondsInHour * 6)],
             @"defaultDuration"                     : @(MTDateConstantSecondsInHour),
             @"weekStartsOnWeekday"                 : @(1),
             @"badgeOrAlerts"                       : @(CVLocalNotificationTypeBadgeAndAlerts),
             @"themeStyle"                          : @(CVThemeStyleAuto),
             @"themeColorString"                    : @"0.843137,0.000000,0.000000,1.000000",
             @"dayStartHour"                        : @(9),
             @"dayEndHour"                          : @(5),
             @"eventDetailsSubtitleTextPriority"    : [CVEventSubtitleTextPriorityViewController standardSubtitleTextPriorityArray],
             @"eventDetailsOrdering"                : [CVEventDetailsOrderViewController standardDetailsOrderingArray]
             };
}

@end
