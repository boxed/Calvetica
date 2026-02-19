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

#pragma mark - Fixed Colors (not mode aware)

#define patentedRed [UIColor colorWithRed:215.0/255.0 green:0 blue:0 alpha:1]
#define patentedDarkRed [UIColor colorWithRed:0.61 green:0 blue:0 alpha:1]
#define patentedDarkerRed [UIColor colorWithRed:0.4 green:0 blue:0 alpha:1]

#define OLD_EVENT_ALPHA 0.5f

#pragma mark - Semantic Colors

UIColor* alarmButtonBackgroundColor(void);
UIColor* alarmButtonTextColor(void);
UIColor* alarmPickerBackgroundColor(void);
UIColor* slideToDeleteBackgroundColor(void);

