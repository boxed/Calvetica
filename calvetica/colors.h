//
//  CVPatentedCalveticaRed.h
//  calvetica
//
//  Created by James Schultz on 12/20/10.
//  Copyright 2010 Mysterious Trousers, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIColor* patentedWhite(void);
UIColor* patentedBlack(void);

UIColor* backgroundColorVeryWhite(void);

#define patentedClear [UIColor clearColor]

#pragma mark - Greys

UIColor* patentedVeryLightGray(void);
UIColor* patentedPrettyLightGray(void);
UIColor* patentedLightGray(void);
UIColor* patentedGray(void);
UIColor* patentedDarkGray(void);
UIColor* patentedQuiteDarkGray(void);
UIColor* patentedVeryDarkGray(void);
UIColor* patentedDarkGrayWeekdayHeader(void);

#pragma mark - Colors

#define patentedRed [UIColor colorWithRed:215.0/255.0 green:0 blue:0 alpha:1]
#define patentedDarkRed [UIColor colorWithRed:0.61 green:0 blue:0 alpha:1]
#define patentedDarkerRed [UIColor colorWithRed:0.4 green:0 blue:0 alpha:1]
#define patentedSuperDarkRed [UIColor colorWithRed:0.30 green:0.04 blue: 0.04 alpha:1]

#define patentedTodayBoxRedBottomLeft [UIColor colorWithRed:0.655 green:0.133 blue: 0.129 alpha:1]
#define patentedTodayBoxRedTopRight [UIColor colorWithRed:0.776 green:0.169 blue: 0.161 alpha:1]

#define patentedDarkGreen [UIColor colorWithRed:0.133 green:0.553 blue:0.349 alpha:1.000] 

#pragma mark - Shadows

#define patentedWhiteLightShadow [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]
#define patentedWhiteDarkShadow [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9]
#define patentedBlackLightShadow [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define patentedBlackFaintShadow [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define patentedBlackDarkShadow [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]
#define patentedShadow [UIColor colorWithRed:0 green:0 blue:0 alpha:0.38]

#define patentedCellWorkHours [UIColor colorWithWhite:1.0 alpha:0.5]
#define patentedCellNonWorkHours [UIColor colorWithRed:1 green:1 blue:1 alpha:0.05]

#define OLD_EVENT_ALPHA 0.5f

#pragma mark - Semantic Colors

UIColor* alarmButtonBackgroundColor(void);
UIColor* alarmButtonTextColor(void);
UIColor* alarmPickerBackgroundColor(void);
UIColor* slideToDeleteBackgroundColor(void);

