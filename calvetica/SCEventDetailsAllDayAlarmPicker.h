//
//  SCEventDetailsAllDayAlarmPicker.h
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKEvent+Utilities.h"
#import "CVToggleButton.h"


@interface SCEventDetailsAllDayAlarmPicker : UIViewController {
}


#pragma mark - Properties
@property (nonatomic, strong) EKEvent *event;

#pragma mark - Methods


#pragma mark - IBActions


#pragma mark - Notifications


@end




#pragma mark - Protected
@interface SCEventDetailsAllDayAlarmPicker ()
@property (nonatomic, strong) IBOutlet CVToggleButton *button_0;
@property (nonatomic, strong) IBOutlet CVToggleButton *button_1;
@property (nonatomic, strong) IBOutlet CVToggleButton *button_2;
@property (nonatomic, strong) IBOutlet CVToggleButton *button_3;
@property (nonatomic, strong) IBOutlet CVToggleButton *button_4;
@property (nonatomic, strong) IBOutlet CVToggleButton *button_5;
@property (nonatomic, strong) NSMutableArray *alarmOptions;
@property (nonatomic, strong) NSMutableArray *alarmButtons;

- (void)configureAlarmOptions;
- (void)configureAlarmButtons;
- (IBAction)buttonWasTapped:(id)sender;
@end
