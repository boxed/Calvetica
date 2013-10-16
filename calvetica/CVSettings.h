//
//  CVSettings.h
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKCalendar+Utilities.h"
#import "EKEventStore+Shared.h"
#import "CVEventDetailsOrderViewController.h"
#import "UIColor+Utilities.h"


@interface CVSettings : NSObject

#pragma mark - IN APP SAVED STATE

+ (BOOL)isAgendaView;
+ (void)setAgendaView:(BOOL)b;

+ (NSInteger)eventRootTableMode;
+ (void)setEventRootTableMode:(NSInteger)mode;

#pragma mark - IN APP SETTINGS

+ (NSMutableArray *)selectedEventCalendars;
+ (void)setSelectedEventCalendars:(NSMutableArray *)calendars;

+ (void)addSelectedEventCalendar:(EKCalendar *)calendar;
+ (void)removeSelectedEventCalendar:(EKCalendar *)calendar;

+ (BOOL)isSelectedCalendar:(EKCalendar *)calendar;

+ (EKCalendar *)defaultEventCalendar;
+ (void)setDefaultEventCalendar:(EKCalendar *)defCal;

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
