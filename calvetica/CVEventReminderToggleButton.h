//
//  CVCheckmarkButton.h
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

typedef NS_ENUM(NSUInteger, CVEventReminderToggleButtonIcon) {
    CVEventReminderToggleButtonIconCheck,
    CVEventReminderToggleButtonIconCalendar
};


@interface CVEventReminderToggleButton : UIButton
@property (nonatomic, assign) CVEventReminderToggleButtonIcon icon;
@end
