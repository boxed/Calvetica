
#import "NSString+Utilities.h"


@implementation CVSettings



#pragma mark - IN APP SAVED STATE

+ (BOOL)welcomeScreenHasBeenShown {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults objectForKey:WELCOME_SCREEN_SAVED_VERSION];
    
    // if the welcome screen is new, set the hasBeenShown to NO, then save the
    // current version
    if (![version isEqualToString:WELCOME_SCREEN_CURRENT_VERSION]) {
        [CVSettings setWelcomeScreenHasBeenShown:NO];
        [defaults setObject:WELCOME_SCREEN_CURRENT_VERSION forKey:WELCOME_SCREEN_SAVED_VERSION];
        [defaults synchronize];
    }
    
    // return the saved state
    return [defaults objectForKey:WELCOME_SCREEN_SHOWN] != nil ? [defaults boolForKey:WELCOME_SCREEN_SHOWN] : NO;

}

+ (void)setWelcomeScreenHasBeenShown:(BOOL)b {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:b forKey:WELCOME_SCREEN_SHOWN];
	[defaults synchronize];
}

+ (BOOL)isAgendaView {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:AGENDA_VIEW] != nil ? [defaults boolForKey:AGENDA_VIEW] : NO;
}

+ (void)setAgendaView:(BOOL)b {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:b forKey:AGENDA_VIEW];
	[defaults synchronize];
}


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
        return [NSMutableArray arrayWithArray:[CVEventStore eventCalendars]];
    }
    
    NSMutableArray *calendars = [NSMutableArray array];
    
    for (EKCalendar *c in [CVEventStore eventCalendars]) {
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

+ (void)removeSelectedEventCalendar:(EKCalendar *)calendar {
    NSMutableArray *selectedCalendars = [CVSettings selectedEventCalendars];
    NSMutableArray *newSelectedCalendars = [NSMutableArray array];
    for (EKCalendar *c in selectedCalendars) {
        if (![c.calendarIdentifier isEqualToString:calendar.calendarIdentifier]) {
            [newSelectedCalendars addObject:c];
        }
    }
    [CVSettings setSelectedEventCalendars:newSelectedCalendars];
}

+ (BOOL)isSelectedCalendar:(EKCalendar *)calendar {

    NSMutableArray *selectedCalendars = [CVSettings selectedEventCalendars];
	
	// check if calendar exists in the array of selected calendars
    for (EKCalendar *c in selectedCalendars) {
        if ([c.calendarIdentifier isEqualToString:calendar.calendarIdentifier]) {
            return YES;
        }
    }
	
	return NO;
}

+ (EKCalendar *)defaultEventCalendar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *def = (NSString *)[defaults objectForKey:DEFAULT_EVENT_CALENDAR];

    EKCalendar *defCal = [CVEventStore calendarWithIdentifier:def];
    if (defCal) {
        return defCal;
    } else {
        return [CVEventStore defaultCalendarForNewEvents];
    }
}

+ (void)setDefaultEventCalendar:(EKCalendar *)defCal {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:defCal.calendarIdentifier forKey:DEFAULT_EVENT_CALENDAR];
	[defaults synchronize];
}

+ (UIColor *)customColorForCalendar:(EKCalendar *)calendar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *calendarsCollectionDictionary = [defaults objectForKey:CUSTOM_COLORS_FOR_CALENDARS_COLLECTION];
    NSDictionary *calendars = [calendarsCollectionDictionary objectForKey:CUSTOMIZED_CALENDARS];
    NSDictionary *calendarDict = [calendars objectForKey:calendar.calendarIdentifier];
    
    if (!calendarDict) {
        return nil;
    }
    
    NSData *colorData = [calendarDict objectForKey:CUSTOM_COLOR];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    return color;
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
	int defaultduration = [defaults integerForKey:DEFAULT_DURATION];
	if (defaultduration != 0) {
		return defaultduration;
	}
	else {
		return 60 * 60;
	}
}

+ (void)setDefaultDuration:(NSInteger)dd {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:dd forKey:DEFAULT_DURATION];
	[defaults synchronize];
}




#pragma mark - CALENDAR

+ (BOOL)timeZoneSupport {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TIMEZONE_SUPPORT] != nil ? [defaults boolForKey:TIMEZONE_SUPPORT] : YES;
}

+ (void)setTimeZoneSupport:(BOOL)support {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:support forKey:TIMEZONE_SUPPORT];
	[defaults synchronize];
}

+ (NSTimeZone *)timezone {
    NSString *timeZoneName = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_TIMEZONE];
    if (timeZoneName && [CVSettings timeZoneSupport])
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
	int daystarthour = [defaults integerForKey:DAY_START_HOUR];    
    return daystarthour != 0 ? (daystarthour == -1 ? 0 : daystarthour) : 8;
}

+ (void)setDayStartHour:(NSInteger)i {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    
	[defaults setInteger:i forKey:DAY_START_HOUR];
	[defaults synchronize];
}


+ (NSInteger)dayEndHour {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int dayendhour = [defaults integerForKey:DAY_END_HOUR];    
	return dayendhour != 0 ? (dayendhour == -1 ? 0 : dayendhour) : 17;
}

+ (void)setDayEndHour:(NSInteger)i {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:i forKey:DAY_END_HOUR];
	[defaults synchronize];
}

+ (BOOL)alwaysAskForCalendar {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:ALWAYS_ASK_FOR_CALENDAR] != nil ? [defaults boolForKey:ALWAYS_ASK_FOR_CALENDAR] : NO;
}

+ (void)setAlwaysAskForCalendar:(BOOL)ask {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:ask forKey:ALWAYS_ASK_FOR_CALENDAR];
    [defaults synchronize];
}

+ (BOOL)multipleExchangeAlarms {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:MULTIPLE_EXCHANGE_ALARMS];
}

+ (void)setMultipleExchangeAlarms:(BOOL)multiple {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:multiple forKey:MULTIPLE_EXCHANGE_ALARMS];
    [defaults synchronize];
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


+ (BOOL)isTwentyFourHourFormat {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:TWENTY_FOUR_HOUR_FORMAT] != nil ? [defaults boolForKey:TWENTY_FOUR_HOUR_FORMAT] : NO;
}

+ (void)setTwentyFourHourFormat:(BOOL)b {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:b forKey:TWENTY_FOUR_HOUR_FORMAT];
	[defaults synchronize];
}




#pragma mark - THE PAINFUL CHOICEx

+ (NSInteger)badgeOrAlerts {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:BADGE_OR_ALERTS] != nil ? [defaults integerForKey:BADGE_OR_ALERTS] : 0;
}

+ (void)setBadgeOrAlerts:(NSInteger)i {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:i forKey:BADGE_OR_ALERTS];
	[defaults synchronize];
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


+ (BOOL)dotsOnlyMonthView {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:DOTS_ONLY_MONTH_VIEW] != nil ? [defaults boolForKey:DOTS_ONLY_MONTH_VIEW] : NO;
}

+ (void)dotsOnlyMonthView:(BOOL)dotsOnly {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:dotsOnly forKey:DOTS_ONLY_MONTH_VIEW];
	[defaults synchronize];
}

+ (BOOL)scrollableMonthView {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:SCROLLABLE_MONTH_VIEW] != nil ? [defaults boolForKey:SCROLLABLE_MONTH_VIEW] : NO;    
}

+ (BOOL)showDurationOnReadOnlyEvents {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:SHOW_DURATION_ON_READ_ONLY_EVENTS] != nil ? [defaults boolForKey:SHOW_DURATION_ON_READ_ONLY_EVENTS] : NO;
}

+ (void)setShowDurationOnReadOnlyEvents:(BOOL)showDuration {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:showDuration forKey:SHOW_DURATION_ON_READ_ONLY_EVENTS];
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
