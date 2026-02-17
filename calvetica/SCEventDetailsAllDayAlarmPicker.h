//
//  SCEventDetailsAllDayAlarmPicker.h
//  Event Calendar
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVToggleButton.h"

NS_ASSUME_NONNULL_BEGIN



@interface SCEventDetailsAllDayAlarmPicker : UIViewController
@property (nonatomic, strong) EKEvent *event;
@end




@interface SCEventDetailsAllDayAlarmPicker ()
@property (nonatomic, nullable, weak) IBOutlet CVToggleButton *button_0;
@property (nonatomic, nullable, weak) IBOutlet CVToggleButton *button_1;
@property (nonatomic, nullable, weak) IBOutlet CVToggleButton *button_2;
@property (nonatomic, nullable, weak) IBOutlet CVToggleButton *button_3;
@property (nonatomic, nullable, weak) IBOutlet CVToggleButton *button_4;
@property (nonatomic, nullable, weak) IBOutlet CVToggleButton *button_5;
@property (nonatomic, strong)          NSMutableArray<NSNumber *> *alarmOptions;
@property (nonatomic, strong)          NSMutableArray<CVToggleButton *> *alarmButtons;

- (void)configureAlarmOptions;
- (void)configureAlarmButtons;
- (IBAction)buttonWasTapped:(id)sender;
@end

NS_ASSUME_NONNULL_END
