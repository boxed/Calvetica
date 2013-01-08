//
//  SCEventDetailsAllDayAlarmPicker.m
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "SCEventDetailsAllDayAlarmPicker.h"




#pragma mark - Private
@interface SCEventDetailsAllDayAlarmPicker ()
@end




@implementation SCEventDetailsAllDayAlarmPicker


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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods

- (void)configureAlarmOptions 
{
    self.alarmOptions = [NSMutableArray array];
    [self.alarmOptions addObject:@(-(6 * SECONDS_IN_HOUR))];	// 6pm the day before
    [self.alarmOptions addObject:@(-(2 * SECONDS_IN_HOUR))];	// 10pm the day before
    [self.alarmOptions addObject:@(6 * SECONDS_IN_HOUR)];		// 6am the day of
    [self.alarmOptions addObject:@(7 * SECONDS_IN_HOUR)];		// 7am the day of
    [self.alarmOptions addObject:@(8 * SECONDS_IN_HOUR)];		// 8am the day of
    [self.alarmOptions addObject:@(9 * SECONDS_IN_HOUR)];		// 9am the day of  
    
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
    
    if (self.event.calendar.source.sourceType == EKSourceTypeExchange && ![CVSettings multipleExchangeAlarms]) {
        // only allow one at a time
        for (CVToggleButton *alarmButton in self.alarmButtons) {
            if ([alarmButton isEqual:button]) {
                if (alarmButton.selected == YES) {
                    alarmButton.selected = NO;
                }
                else {
                    alarmButton.selected = YES;
                }
            }
            else {
                alarmButton.selected = NO;
            }
        }
    }
    else {
        button.selected = !button.selected;
    }
    
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
