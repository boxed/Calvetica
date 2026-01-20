//
//  SCEventDetailsAllDayAlarmPicker.m
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "SCEventDetailsAllDayAlarmPicker.h"
#import "times.h"
#import "colors.h"


@implementation SCEventDetailsAllDayAlarmPicker

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = alarmPickerBackgroundColor();
    [self configureAlarmOptions];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - Methods

- (void)configureAlarmOptions 
{
    self.alarmOptions = [NSMutableArray array];
    [self.alarmOptions addObject:@(-(6 * MTDateConstantSecondsInHour))];	// 6pm the day before
    [self.alarmOptions addObject:@(-(2 * MTDateConstantSecondsInHour))];	// 10pm the day before
    [self.alarmOptions addObject:@(6 * MTDateConstantSecondsInHour)];		// 6am the day of
    [self.alarmOptions addObject:@(7 * MTDateConstantSecondsInHour)];		// 7am the day of
    [self.alarmOptions addObject:@(8 * MTDateConstantSecondsInHour)];		// 8am the day of
    [self.alarmOptions addObject:@(9 * MTDateConstantSecondsInHour)];		// 9am the day of  
    
    [self configureAlarmButtons];
}

- (void)configureAlarmButtons 
{
    self.alarmButtons = [NSMutableArray arrayWithArray:@[self.button_0,
                             self.button_1, 
                             self.button_2, 
                             self.button_3, 
                             self.button_4, 
                             self.button_5]];
    
    for (NSInteger i = 0; i < self.alarmOptions.count; i++) {
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:[[self.alarmOptions objectAtIndex:i] intValue]];
        CVToggleButton *button = [self.alarmButtons objectAtIndex:i];
        button.enabled = self.event.calendar.allowsContentModifications;
        button.backgroundColorNormal = alarmButtonBackgroundColor();
        button.textColorNormal = alarmButtonTextColor();
        [button setTitleColor:alarmButtonTextColor() forState:UIControlStateNormal];
        if ([self.event isACurrentAlarm:alarm]) {
            button.selected = YES;
        }
        else {
            button.selected = NO;
        }
    }
}




#pragma mark - IBActions

- (IBAction)buttonWasTapped:(id)sender
{
    CVToggleButton *button = (CVToggleButton *)sender;
    
    button.selected = !button.selected;

    NSMutableArray *alarms = [NSMutableArray array];
    
    for (CVToggleButton *button in self.alarmButtons) {
        if (button.selected) {
            NSInteger offset = [[self.alarmOptions objectAtIndex:button.tag] integerValue];
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:offset];
            [alarms addObject:alarm];
        }
    }
    self.event.alarms = alarms;
}



@end
