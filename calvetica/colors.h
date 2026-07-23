//
//  CVPatentedCalveticaRed.h
//  calvetica
//
//  Created by James Schultz on 12/20/10.
//  Copyright 2010 Mysterious Trousers, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Adaptive Colors (light/dark mode aware)

UIColor* calBackgroundColor(void);
UIColor* calTextColor(void);
UIColor* calSecondaryBackground(void);
UIColor* calBorderColorLight(void);
UIColor* calSeparatorColor(void);
UIColor* calGridLineColor(void);
UIColor* calSecondaryText(void);
UIColor* calTertiaryText(void);
UIColor* calQuaternaryText(void);
UIColor* calDimmedText(void);
UIColor* calWeekdayHeaderText(void);

#define patentedClear [UIColor clearColor]

#pragma mark - Theme Color (user configurable)

/// The user's chosen theme color. Defaults to the patented Calvetica red.
UIColor* calThemeColor(void);
/// A darker shade of the theme color (same hue), for pressed/selected states.
UIColor* calThemeColorDark(void);
/// An even darker shade of the theme color (same hue).
UIColor* calThemeColorDarker(void);

/// The factory default theme color (the patented Calvetica red).
#define patentedDefaultRed [UIColor colorWithRed:215.0/255.0 green:0 blue:0 alpha:1]

// Compatibility aliases: all existing call sites read the configurable theme color.
#define patentedRed calThemeColor()
#define patentedDarkRed calThemeColorDark()
#define patentedDarkerRed calThemeColorDarker()

#define OLD_EVENT_ALPHA 0.5f

#pragma mark - Semantic Colors

UIColor* alarmButtonBackgroundColor(void);
UIColor* alarmButtonTextColor(void);
UIColor* alarmPickerBackgroundColor(void);
UIColor* slideToDeleteBackgroundColor(void);

