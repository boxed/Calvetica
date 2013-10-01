

#import "EKCalendar+Utilities.h"
#import "CVEventStore.h"
#import "CVEventDetailsOrderViewController.h"
#import "CVEventSubtitleTextPriorityViewController.h"
#import "CVReminderDetailsOrderViewController.h"
#import "CVEventStore.h"
#import "CVDevice.h"
#import "settingskeys.h"
#import "UIColor+Utilities.h"
#import "CVCustomColorDataHolder.h"
#import "CVDebug.h"

@interface CVSettings : NSObject {
}


#pragma mark - IN APP SAVED STATE

+ (BOOL)welcomeScreenHasBeenShown;
+ (void)setWelcomeScreenHasBeenShown:(BOOL)b;

+ (BOOL)isAgendaView;
+ (void)setAgendaView:(BOOL)b;

+ (NSInteger)eventRootTableMode;
+ (void)setEventRootTableMode:(NSInteger)mode;

+ (NSInteger)reminderRootTableMode;
+ (void)setReminderRootTableMode:(NSInteger)mode;

+ (BOOL)isReminderView;
+ (void)setReminderView:(BOOL)b;

#pragma mark - IN APP SETTINGS

+ (NSMutableArray *)selectedEventCalendars;
+ (void)setSelectedEventCalendars:(NSMutableArray *)calendars;

+ (void)addSelectedEventCalendar:(EKCalendar *)calendar;
+ (void)removeSelectedEventCalendar:(EKCalendar *)calendar;

+ (BOOL)isSelectedCalendar:(EKCalendar *)calendar;

+ (NSMutableArray *)selectedReminderCalendars;
+ (void)setSelectedReminderCalendars:(NSMutableArray *)calendars;

+ (void)addSelectedReminderCalendar:(EKCalendar *)calendar;
+ (void)removeSelectedReminderCalendar:(EKCalendar *)calendar;

+ (EKCalendar *)defaultEventCalendar;
+ (void)setDefaultEventCalendar:(EKCalendar *)defCal;

+ (EKCalendar *)defaultReminderCalendar;
+ (void)setDefaultReminderCalendar:(EKCalendar *)defGrp;

+ (UIColor *)customColorForCalendar:(EKCalendar *)calendar;
+ (void)setCustomColor:(UIColor *)color forCalendar:(EKCalendar *)calendar;

#pragma mark - DEFAULTS

+ (NSArray *)defaultEventAlarms;
+ (void)setDefaultEventAlarms:(NSArray *)defaultAlarms;

+ (NSArray *)defaultAllDayEventAlarms;
+ (void)setDefaultAllDayEventAlarms:(NSArray *)defaultAlarms;

+ (NSInteger)defaultDuration;
+ (void)setDefaultDuration:(NSInteger)dd;


#pragma mark - CALENDAR

+ (BOOL)timeZoneSupport;
+ (void)setTimeZoneSupport:(BOOL)support;

+ (NSTimeZone *)timezone;
+ (void)setTimeZone:(NSTimeZone *)timezone;

+ (NSInteger)dayStartHour;
+ (void)setDayStartHour:(NSInteger)i;

+ (NSInteger)dayEndHour;
+ (void)setDayEndHour:(NSInteger)i;

+ (BOOL)alwaysAskForCalendar;
+ (void)setAlwaysAskForCalendar:(BOOL)ask;

+ (BOOL)multipleExchangeAlarms;
+ (void)setMultipleExchangeAlarms:(BOOL)multiple;


#pragma mark - INTERNATIONAL

+ (NSString *)defaultLanguage;
+ (void)setDefaultLanguage:(NSArray *)languagePrefs;

+ (NSInteger)weekStartsOnWeekday;
+ (void)setWeekStartsOnWeekday:(NSInteger)startsOnWeekday;

+ (BOOL)isTwentyFourHourFormat;
+ (void)setTwentyFourHourFormat:(BOOL)b;



#pragma mark - THE PAINFUL CHOICE

+ (NSInteger)badgeOrAlerts;
+ (void)setBadgeOrAlerts:(NSInteger)i;



#pragma mark - APPEARANCE
+ (BOOL)isAEventDetailBlock:(NSDictionary *)detail;
+ (BOOL)eventDetailBlockIsSaved:(NSDictionary *)detail;
+ (NSArray *)eventDetailsOrderingArray;
+ (void)setDetailsOrderingArray:(NSArray *)array;

+ (BOOL)isAReminderDetailBlock:(NSDictionary *)detail; 
+ (BOOL)reminderDetailBlockIsSaved:(NSDictionary *)detail;
+ (NSArray *)reminderDetailsOrderingArray;
+ (void)setReminderDetailsOrderingArray:(NSArray *)array;

+ (NSArray *)eventDetailsSubtitleTextOrderingArray;
+ (void)setEventDetailsSubtitleTextOrderingArray:(NSArray *)array;

+ (BOOL)dotsOnlyMonthView;
+ (void)dotsOnlyMonthView:(BOOL)dotsOnly;

+ (BOOL)scrollableMonthView;

+ (BOOL)showDurationOnReadOnlyEvents;
+ (void)setShowDurationOnReadOnlyEvents:(BOOL)showDuration;


#pragma mark - CUSTOM ALERT SOUNDS

+ (NSString *)customAlertSoundFile;
+ (void)setCustomAlertSoundFile:(NSString *)soundFile;


@end
