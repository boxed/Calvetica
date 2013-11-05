//
//  CVSharedSettings.h
//  calvetica
//
//  Created by Adam Kirk on 11/4/13.
//
//

#import "MYSSharedSettings.h"


#define PREFS [CVSharedSettings sharedSettings]


@interface CVSharedSettings : MYSSharedSettings

@property (nonatomic, assign) BOOL remindersEnabled;
@property (nonatomic, assign) BOOL timezoneSupportEnabled;
@property (nonatomic, assign) BOOL alwaysAskForCalendar;
@property (nonatomic, assign) BOOL twentyFourHourFormat;
@property (nonatomic, assign) BOOL dotsOnlyMonthView;
@property (nonatomic, assign) BOOL iPhoneScrollableMonthView;
@property (nonatomic, assign) BOOL showDurationOnReadOnlyEvents;

@end
