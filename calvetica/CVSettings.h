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

+ (NSTimeZone *)timezone;
+ (void)setTimeZone:(NSTimeZone *)timezone;

+ (NSInteger)dayStartHour;
+ (void)setDayStartHour:(NSInteger)i;

+ (NSInteger)dayEndHour;
+ (void)setDayEndHour:(NSInteger)i;

+ (BOOL)multipleExchangeAlarms;


#pragma mark - INTERNATIONAL

+ (NSString *)defaultLanguage;
+ (void)setDefaultLanguage:(NSArray *)languagePrefs;

+ (NSInteger)weekStartsOnWeekday;
+ (void)setWeekStartsOnWeekday:(NSInteger)startsOnWeekday;


#pragma mark - THE PAINFUL CHOICE

+ (NSInteger)badgeOrAlerts;


#pragma mark - APPEARANCE
+ (NSArray *)eventDetailsOrderingArray;
+ (void)setDetailsOrderingArray:(NSArray *)array;

+ (NSArray *)eventDetailsSubtitleTextOrderingArray;
+ (void)setEventDetailsSubtitleTextOrderingArray:(NSArray *)array;


#pragma mark - CUSTOM ALERT SOUNDS

+ (NSString *)customAlertSoundFile;
+ (void)setCustomAlertSoundFile:(NSString *)soundFile;


@end
