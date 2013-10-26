//
//  CVSettings.h
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsOrderViewController.h"


@interface CVSettings : NSObject

#pragma mark - IN APP SAVED STATE


+ (NSInteger)eventRootTableMode;
+ (void)setEventRootTableMode:(NSInteger)mode;

#pragma mark - IN APP SETTINGS

+ (NSMutableArray *)selectedEventCalendars;
+ (void)setSelectedEventCalendars:(NSMutableArray *)calendars;

+ (void)addSelectedEventCalendar:(EKCalendar *)calendar;

+ (EKCalendar *)defaultEventCalendar;
+ (void)setDefaultEventCalendar:(EKCalendar *)defCal;

+ (void)setCustomColor:(UIColor *)color forCalendar:(EKCalendar *)calendar;

#pragma mark - DEFAULTS

+ (NSArray *)defaultEventAlarms;
+ (void)setDefaultEventAlarms:(NSArray *)defaultAlarms;

+ (NSArray *)defaultAllDayEventAlarms;
+ (void)setDefaultAllDayEventAlarms:(NSArray *)defaultAlarms;

+ (NSInteger)defaultDuration;


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


#pragma mark - INTERNATIONAL

+ (NSString *)defaultLanguage;
+ (void)setDefaultLanguage:(NSArray *)languagePrefs;

+ (NSInteger)weekStartsOnWeekday;
+ (void)setWeekStartsOnWeekday:(NSInteger)startsOnWeekday;

+ (BOOL)isTwentyFourHourFormat;
+ (void)setTwentyFourHourFormat:(BOOL)b;



#pragma mark - THE PAINFUL CHOICE

+ (NSInteger)badgeOrAlerts;



#pragma mark - APPEARANCE
+ (NSArray *)eventDetailsOrderingArray;
+ (void)setDetailsOrderingArray:(NSArray *)array;

+ (NSArray *)eventDetailsSubtitleTextOrderingArray;
+ (void)setEventDetailsSubtitleTextOrderingArray:(NSArray *)array;

+ (BOOL)dotsOnlyMonthView;
+ (void)dotsOnlyMonthView:(BOOL)dotsOnly;

+ (BOOL)scrollableMonthView;

+ (BOOL)showDurationOnReadOnlyEvents;


#pragma mark - CUSTOM ALERT SOUNDS

+ (NSString *)customAlertSoundFile;
+ (void)setCustomAlertSoundFile:(NSString *)soundFile;


@end
