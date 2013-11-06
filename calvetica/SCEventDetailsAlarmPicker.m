//
//  SCEventDetailsAlarmPicker.m
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "SCEventDetailsAlarmPicker.h"
#import "times.h"


@implementation SCEventDetailsAlarmPicker

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self configureAlarmOptions];
}

- (void)viewDidUnload 
{
    self.button_0 = nil;
    self.button_1 = nil;
    self.button_2 = nil;
    self.button_3 = nil;
    self.button_4 = nil;
    self.button_5 = nil;
    self.button_6 = nil;
    self.button_7 = nil;
    self.button_8 = nil;
    self.button_9 = nil;
    self.button_10 = nil;
    self.button_11 = nil;
    self.button_12 = nil;
    self.button_13 = nil;
    self.button_14 = nil;
    self.button_15 = nil;
    [super viewDidUnload];
}




#pragma mark - Methods
- (void)configureAlarmOptions 
{
    self.alarmOptions = [NSMutableArray array];
    [self.alarmOptions addObject:@-0];								// 0min
    [self.alarmOptions addObject:@(-(5 * MTDateConstantSecondsInMinute))];		// 5min
    [self.alarmOptions addObject:@(-(15 * MTDateConstantSecondsInMinute))];		// 15min
    [self.alarmOptions addObject:@(-(30 * MTDateConstantSecondsInMinute))];		// 30min
    [self.alarmOptions addObject:@(-(45 * MTDateConstantSecondsInMinute))];		// 45min
    [self.alarmOptions addObject:@(-(1 * MTDateConstantSecondsInHour))];			// 1hr
    [self.alarmOptions addObject:@(-(2 * MTDateConstantSecondsInHour))];			// 2hr
    [self.alarmOptions addObject:@(-(6 * MTDateConstantSecondsInHour))];			// 6hr
    [self.alarmOptions addObject:@(-(12 * MTDateConstantSecondsInHour))];			// 12hr
    [self.alarmOptions addObject:@(-(1 * MTDateConstantSecondsInDay))];			// 1d
    [self.alarmOptions addObject:@(-(2 * MTDateConstantSecondsInDay))];			// 2d
    [self.alarmOptions addObject:@(-(3 * MTDateConstantSecondsInDay))];			// 3d
    [self.alarmOptions addObject:@(-(5 * MTDateConstantSecondsInDay))];			// 5d
    [self.alarmOptions addObject:@(-(1 * MTDateConstantSecondsInWeek))];			// 1wk
    [self.alarmOptions addObject:@(-(2 * MTDateConstantSecondsInWeek))];			// 2wk
    [self.alarmOptions addObject:@(-(1 * MTDateConstantSecondsInMonth))];			// 1mo  
    
    [self configureAlarmButtons];
}

- (void)configureAlarmButtons 
{
    self.alarmButtons = [NSMutableArray arrayWithArray:@[self.button_0,
                             self.button_1, 
                             self.button_2, 
                             self.button_3, 
                             self.button_4, 
                             self.button_5,
                             self.button_6,
                             self.button_7,
                             self.button_8,
                             self.button_9,
                             self.button_10,
                             self.button_11,
                             self.button_12,
                             self.button_13,
                             self.button_14,
                             self.button_15]];
    
    for (NSInteger i = 0; i < self.alarmOptions.count; i++) {
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:[[self.alarmOptions objectAtIndex:i] intValue]];
        CVToggleButton *button = [self.alarmButtons objectAtIndex:i];
        button.enabled = self.event.calendar.allowsContentModifications;
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
