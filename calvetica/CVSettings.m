//
//  CVSettings.h
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSString+Utilities.h"
#import "settingskeys.h"
#import "CVEventSubtitleTextPriorityViewController.h"
#import "UIColor+Calvetica.h"


@implementation CVSettings

#pragma mark - IN APP SAVED STATE

+ (NSInteger)eventRootTableMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:EVENT_ROOT_TABLE_MODE] != nil ? [[defaults valueForKey:EVENT_ROOT_TABLE_MODE] intValue] : 1;
}

+ (void)setEventRootTableMode:(NSInteger)mode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(mode) forKey:EVENT_ROOT_TABLE_MODE];
    [defaults synchronize];
}



#pragma mark - IN APP SETTINGS

+ (NSMutableArray *)selectedEventCalendars {
    NSMutableArray *selectedCalendars = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_EVENT_CALENDARS];
    
    if (!selectedCalendars) {
        return [NSMutableArray arrayWithArray:[EKEventStore eventCalendars]];
    }
    
    NSMutableArray *calendars = [NSMutableArray array];
    
    for (EKCalendar *c in [EKEventStore eventCalendars]) {
        for (NSString *cd in selectedCalendars) {
            if ([cd isEqualToString:c.calendarIdentifier]) {
                [calendars addObject:c];
                break;
            }
        }
    }
    
    return calendars;
}

+ (void)setSelectedEventCalendars:(NSMutableArray *)calendars; {	
    NSMutableArray *calendarsToSave = [NSMutableArray array];
    for (EKCalendar *c in calendars) {
        [calendarsToSave addObject:c.calendarIdentifier];
    }
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:calendarsToSave forKey:SELECTED_EVENT_CALENDARS];
	[defaults synchronize];
}

+ (void)addSelectedEventCalendar:(EKCalendar *)calendar {
    NSMutableArray *selectedCalendars = [CVSettings selectedEventCalendars];
    
    // check if already exists
    for (EKCalendar *c in selectedCalendars) {
        if ([c.calendarIdentifier isEqualToString:calendar.calendarIdentifier]) {
            return;
        }
    }
    if (!calendar) return;
    [selectedCalendars addObject:calendar];
    [CVSettings setSelectedEventCalendars:selectedCalendars];
}

+ (EKCalendar *)defaultEventCalendar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *def = (NSString *)[defaults objectForKey:DEFAULT_EVENT_CALENDAR];

    EKCalendar *defCal = [EKEventStore calendarWithIdentifier:def];
    if (defCal) {
        return defCal;
    } else {
        return [EKEventStore defaultCalendarForNewEvents];
    }
}

+ (void)setDefaultEventCalendar:(EKCalendar *)defCal {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:defCal.calendarIdentifier forKey:DEFAULT_EVENT_CALENDAR];
	[defaults synchronize];
}


+ (void)setCustomColor:(UIColor *)color forCalendar:(EKCalendar *)calendar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // create a disctionary of color components for the current calendar
    //NSDictionary *colorDictionary = [color colorComponentDictionary];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSString *calendarKey = calendar.calendarIdentifier;
    NSMutableDictionary *calendarDict;
    NSMutableDictionary *calendarsDict;
    
    // get the customCalendarsDictionary
    NSMutableDictionary *calendarsCollectionDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:CUSTOM_COLORS_FOR_CALENDARS_COLLECTION]];
    
    if (!calendarsCollectionDictionary) {
        calendarsCollectionDictionary = [NSMutableDictionary dictionary];
        calendarDict = [NSMutableDictionary dictionary];
        calendarsDict = [NSMutableDictionary dictionary];
        
        [calendarDict setObject:colorData forKey:CUSTOM_COLOR];
        [calendarsDict setObject:calendar forKey:calendarKey];
        [calendarsCollectionDictionary setObject:calendarsDict forKey:CUSTOMIZED_CALENDARS];
        [defaults setObject:calendarsCollectionDictionary forKey:CUSTOM_COLORS_FOR_CALENDARS_COLLECTION];
    }
    else {
        // pull out the calendars dictionary
        calendarsDict = [NSMutableDictionary dictionaryWithDictionary:[calendarsCollectionDictionary objectForKey:CUSTOMIZED_CALENDARS]];
        calendarDict = [NSMutableDictionary dictionaryWithDictionary:[calendarsDict objectForKey:calendarKey]];
        
        // set the color dictionary for the current calendar
        [calendarDict setObject:colorData forKey:CUSTOM_COLOR];
        
        // set the calendars dictionary with the new calendar data
        [calendarsDict setObject:calendarDict forKey:calendarKey];
        
        // set the new color dictionary in the calendars list
        [calendarsCollectionDictionary setObject:calendarsDict forKey:CUSTOMIZED_CALENDARS];
        
        // set the calendars collection in defaults
        [defaults setObject:calendarsCollectionDictionary forKey:CUSTOM_COLORS_FOR_CALENDARS_COLLECTION]; 
    }
    
    [defaults synchronize];
}




#pragma mark - DEFAULTS

+ (NSArray *)defaultEventAlarms {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DEFAULT_EVENT_ALARMS] != nil ? [defaults objectForKey:DEFAULT_EVENT_ALARMS] : @[];
}

+ (void)setDefaultEventAlarms:(NSArray *)defaultAlarms {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:defaultAlarms forKey:DEFAULT_EVENT_ALARMS];
    [defaults synchronize];
}

+ (NSArray *)defaultAllDayEventAlarms {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DEFAULT_ALL_DAY_EVENT_ALARMS] != nil ? [defaults objectForKey:DEFAULT_ALL_DAY_EVENT_ALARMS] : @[];
}

+ (void)setDefaultAllDayEventAlarms:(NSArray *)defaultAlarms {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:defaultAlarms forKey:DEFAULT_ALL_DAY_EVENT_ALARMS];
    [defaults synchronize];
}

+ (NSInteger)defaultDuration {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger defaultduration = [defaults integerForKey:DEFAULT_DURATION];
	if (defaultduration != 0) {
		return defaultduration;
	}
	else {
		return 60 * 60;
	}
}




#pragma mark - CALENDAR

+ (NSTimeZone *)timezone {
    NSString *timeZoneName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_TIMEZONE];
    if (timeZoneName && PREFS.timezoneSupportEnabled)
		return [NSTimeZone timeZoneWithName:timeZoneName];

    return [NSTimeZone systemTimeZone];
}

+ (void)setTimeZone:(NSTimeZone *)timezone {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[timezone name] forKey:DEFAULT_TIMEZONE];
	[defaults synchronize];
}

+ (NSInteger)dayStartHour{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger daystarthour = [defaults integerForKey:DAY_START_HOUR];
    return daystarthour != 0 ? (daystarthour == -1 ? 0 : daystarthour) : 8;
}

+ (void)setDayStartHour:(NSInteger)i {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    
	[defaults setInteger:i forKey:DAY_START_HOUR];
	[defaults synchronize];
}


+ (NSInteger)dayEndHour {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger dayendhour = [defaults integerForKey:DAY_END_HOUR];
	return dayendhour != 0 ? (dayendhour == -1 ? 0 : dayendhour) : 17;
}

+ (void)setDayEndHour:(NSInteger)i {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:i forKey:DAY_END_HOUR];
	[defaults synchronize];
}

+ (BOOL)multipleExchangeAlarms {
    return YES;
}



#pragma mark - INTERNATIONAL

+ (NSString *)defaultLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DEFAULT_LANGUAGE] != nil ? [defaults objectForKey:DEFAULT_LANGUAGE] : @"en";
}

+ (void)setDefaultLanguage:(NSArray *)languagePrefs {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[languagePrefs objectAtIndex:0] forKey:DEFAULT_LANGUAGE];
    [defaults setObject:languagePrefs forKey:@"AppleLanguages"];
    [defaults synchronize];
}


+ (NSInteger)weekStartsOnWeekday {    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [defaults integerForKey:START_WEEK_ON_WEEKDAY];
    return index == 0 ? 1 : index;
}

+ (void)setWeekStartsOnWeekday:(NSInteger)startsOnWeekday {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:startsOnWeekday forKey:START_WEEK_ON_WEEKDAY];
	[defaults synchronize];
}




#pragma mark - THE PAINFUL CHOICEx

+ (NSInteger)badgeOrAlerts {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:BADGE_OR_ALERTS] != nil ? [defaults integerForKey:BADGE_OR_ALERTS] : 0;
}



#pragma mark - APPEARANCE

// event detail blocks
+ (BOOL)isAEventDetailBlock:(NSDictionary *)detail {
    NSArray *standardArray = [CVEventDetailsOrderViewController standardDetailsOrderingArray];
    for (NSDictionary *dict in standardArray) {
        if ([[detail objectForKey:@"TitleKey"] isEqualToString:[dict objectForKey:@"TitleKey"]]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)eventDetailBlockIsSaved:(NSDictionary *)detail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedArray = [defaults objectForKey:EVENT_DETAILS_ORDERING];
    for (NSDictionary *dict in savedArray) {
        if ([[detail objectForKey:@"TitleKey"] isEqualToString:[dict objectForKey:@"TitleKey"]]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)eventDetailsOrderingArray {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *savedArray = [defaults objectForKey:EVENT_DETAILS_ORDERING];
    NSArray *standardArray = [CVEventDetailsOrderViewController standardDetailsOrderingArray];
    
    // check for a valid details ordering array
    if (savedArray) {
        // check that each item in the standard array is in the saved array
        // if not add it to the saved array
        for (NSDictionary *dict in standardArray) {
            if (![CVSettings eventDetailBlockIsSaved:dict]) {
                [savedArray addObject:dict];
            }
        }
        
        // check that each item in the saved array is in the standard array
        // if not remove it from the saved array
        for (NSDictionary *dict in savedArray) {
            if (![CVSettings isAEventDetailBlock:dict]) {
                [savedArray removeObject:dict];
            }
        }
        
        [CVSettings setDetailsOrderingArray:[NSArray arrayWithArray:savedArray]];
    }
    // if no valid details ordering array, save the standard ordering array
    else {
        [CVSettings setDetailsOrderingArray:standardArray];
    }
    
    return [defaults objectForKey:EVENT_DETAILS_ORDERING];
}

+ (void)setDetailsOrderingArray:(NSArray *)array {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:EVENT_DETAILS_ORDERING];
    [defaults synchronize];
}

+ (NSArray *)eventDetailsSubtitleTextOrderingArray {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:EVENT_DETAILS_SUBTITLE_ORDERING] != nil ? [defaults objectForKey:EVENT_DETAILS_SUBTITLE_ORDERING] : [CVEventSubtitleTextPriorityViewController standardSubtitleTextPriorityArray];
}

+ (void)setEventDetailsSubtitleTextOrderingArray:(NSArray *)array {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:EVENT_DETAILS_SUBTITLE_ORDERING];
    [defaults synchronize];
}




#pragma mark - CUSTOM ALERT SOUNDS

+ (NSString *)customAlertSoundFile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:CUSTOM_ALERT_SOUND_FILE];
}

+ (void)setCustomAlertSoundFile:(NSString *)soundFile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:soundFile forKey:CUSTOM_ALERT_SOUND_FILE];
    [defaults synchronize];
}




@end
