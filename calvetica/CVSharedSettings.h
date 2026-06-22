//
//  CVSharedSettings.h
//  calvetica
//
//  Created by Adam Kirk on 11/4/13.
//
//

#import "MYSSharedSettings.h"
#import "CVRootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVLocalNotificationType) {
    CVLocalNotificationTypeNone,
    CVLocalNotificationTypeBadge,
    CVLocalNotificationTypeAlerts,
    CVLocalNotificationTypeBadgeAndAlerts
};

// Raw values match UIUserInterfaceStyle (Unspecified/Light/Dark) so the setting
// can be applied directly to a window's overrideUserInterfaceStyle.
typedef NS_ENUM(NSUInteger, CVThemeStyle) {
    CVThemeStyleAuto  = 0,
    CVThemeStyleLight = 1,
    CVThemeStyleDark  = 2
};


#define PREFS [CVSharedSettings sharedSettings]


/// Font scale factor to apply across the UI. On Mac Catalyst this is the user's
/// manual ⌘+/⌘− scale; on iOS it is derived from the system Dynamic Type
/// (accessibility text size) setting, with 1.0 at the default text size.
CGFloat CVFontScale(void);

/// Like CVFontScale() but capped so the dense month/week grid stays legible and
/// within its fixed cells at the largest accessibility sizes.
CGFloat CVGridFontScale(void);

/// Point size for a text style at the default text size, multiplied by
/// CVFontScale(). Gives a stable base that scales uniformly with our single
/// scale source (instead of double-scaling against the OS-scaled preferred font).
CGFloat CVScaledFontSize(UIFontTextStyle textStyle);


@interface CVSharedSettings : MYSSharedSettings

// toggles
@property (nonatomic, assign) BOOL remindersEnabled;
@property (nonatomic, assign) BOOL timezoneSupportEnabled;
@property (nonatomic, assign) BOOL alwaysAskForCalendar;
@property (nonatomic, assign) BOOL twentyFourHourFormat;
@property (nonatomic, assign) BOOL dotsOnlyMonthView;
@property (nonatomic, assign) BOOL iPhoneScrollableMonthView;
@property (nonatomic, assign) BOOL showDurationOnReadOnlyEvents;
@property (nonatomic, assign) BOOL showWeekNumbers;
@property (nonatomic, assign) BOOL showInboxBadge;

// calendars
@property (nonatomic, strong) NSArray<NSString *>      *hiddenEventCalendarIdentifiers;
@property (nonatomic, strong) NSString     *defaultEventCalendarIdentifier;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *customCalendarColors;

@property (nonatomic, strong) NSArray<NSNumber *> *defaultEventAlarms;
@property (nonatomic, strong) NSArray<NSNumber *> *defaultAllDayEventAlarms;
@property (nonatomic, strong) NSArray<NSNumber *> *defaultReminderAlarms;
@property (nonatomic, strong) NSArray<NSNumber *> *defaultAllDayReminderAlarms;

// international
@property (nonatomic, strong) NSString *timeZoneName;
@property (nonatomic, assign) int      weekStartsOnWeekday;

// appearance
@property (nonatomic, assign) CVThemeStyle themeStyle;
@property (nonatomic, assign) int     dayStartHour;
@property (nonatomic, assign) int     dayEndHour;
@property (nonatomic, strong) NSArray<NSDictionary *> *eventDetailsSubtitleTextPriority;
@property (nonatomic, strong) NSArray<NSDictionary *> *eventDetailsOrdering;


// misc
@property (nonatomic, assign) int                     defaultDuration;
@property (nonatomic, assign) CVLocalNotificationType badgeOrAlerts;
@property (nonatomic, strong) NSString                *customAlertSoundFileName;


// local
@property (nonatomic, assign) CVRootTableViewMode localRootTableViewMode;
@property (nonatomic, assign) float fontScale;

@end

NS_ASSUME_NONNULL_END
