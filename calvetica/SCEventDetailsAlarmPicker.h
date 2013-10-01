//
//  SCEventDetailsAlarmPicker.h
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKEvent+Utilities.h"
#import "CVToggleButton.h"


@interface SCEventDetailsAlarmPicker : UIViewController

@property (nonatomic, strong) EKEvent *event;

@end





@interface SCEventDetailsAlarmPicker ()

@property (nonatomic, weak) IBOutlet CVToggleButton *button_0;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_1;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_2;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_3;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_4;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_5;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_6;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_7;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_8;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_9;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_10;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_11;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_12;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_13;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_14;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_15;
@property (nonatomic, strong) NSMutableArray *alarmOptions;
@property (nonatomic, strong) NSMutableArray *alarmButtons;

- (void)configureAlarmOptions;
- (void)configureAlarmButtons;
- (IBAction)buttonWasTapped:(id)sender;

@end
