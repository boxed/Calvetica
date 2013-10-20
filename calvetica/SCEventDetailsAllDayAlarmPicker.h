//
//  SCEventDetailsAllDayAlarmPicker.h
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVToggleButton.h"


@interface SCEventDetailsAllDayAlarmPicker : UIViewController
@property (nonatomic, strong) EKEvent *event;
@end




@interface SCEventDetailsAllDayAlarmPicker ()
@property (nonatomic, weak) IBOutlet CVToggleButton *button_0;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_1;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_2;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_3;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_4;
@property (nonatomic, weak) IBOutlet CVToggleButton *button_5;
@property (nonatomic, strong)          NSMutableArray *alarmOptions;
@property (nonatomic, strong)          NSMutableArray *alarmButtons;

- (void)configureAlarmOptions;
- (void)configureAlarmButtons;
- (IBAction)buttonWasTapped:(id)sender;
@end
