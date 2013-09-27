//
//  CVCheckmarkButton.h
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVLineButton.h"


typedef NS_ENUM(NSUInteger, CVEventReminderToggleButtonIcon) {
    CVEventReminderToggleButtonIconCheck,
    CVEventReminderToggleButtonIconCalendar
};


@interface CVEventReminderToggleButton : CVLineButton
@property (nonatomic, assign) CVEventReminderToggleButtonIcon icon;
@end
