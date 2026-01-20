//
//  CVSharedSettings.h
//  calvetica
//
//  Created by Adam Kirk on 11/4/13.
//
//

#import "MYSSharedSettings.h"
#import "CVRootTableViewController.h"


typedef NS_ENUM(NSUInteger, CVLocalNotificationType) {
    CVLocalNotificationTypeNone,
    CVLocalNotificationTypeBadge,
    CVLocalNotificationTypeAlerts,
    CVLocalNotificationTypeBadgeAndAlerts
};


#define PREFS [CVSharedSettings sharedSettings]


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

// calendars
@property (nonatomic, strong) NSArray      *hiddenEventCalendarIdentifiers;
@property (nonatomic, strong) NSString     *defaultEventCalendarIdentifier;
@property (nonatomic, strong) NSDictionary *customCalendarColors;

@property (nonatomic, strong) NSArray *defaultEventAlarms;
@property (nonatomic, strong) NSArray *defaultAllDayEventAlarms;
@property (nonatomic, strong) NSArray *defaultReminderAlarms;
@property (nonatomic, strong) NSArray *defaultAllDayReminderAlarms;

// international
@property (nonatomic, strong) NSString *timeZoneName;
@property (nonatomic, assign) int      weekStartsOnWeekday;

// appearance
@property (nonatomic, assign) int     dayStartHour;
@property (nonatomic, assign) int     dayEndHour;
@property (nonatomic, strong) NSArray *eventDetailsSubtitleTextPriority;
@property (nonatomic, strong) NSArray *eventDetailsOrdering;


// misc
@property (nonatomic, assign) int                     defaultDuration;
@property (nonatomic, assign) CVLocalNotificationType badgeOrAlerts;
@property (nonatomic, strong) NSString                *customAlertSoundFileName;


// local
@property (nonatomic, assign) CVRootTableViewMode localRootTableViewMode;

@end
