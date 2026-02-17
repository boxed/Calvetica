//
//  CVNumericKeyPad_iPhone.h
//  calvetica
//
//  Created by Quenton Jones on 5/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CVViewButton.h"
#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVNumericKeyPadDelegate;



@interface CVNumericKeyPadViewController : CVViewController

// Inits the keypad with the view it should be located at.
- (instancetype)initWithTargetView:(UIView *)view;

@property (nonatomic, nullable, weak  )          id<CVNumericKeyPadDelegate> delegate;
@property (nonatomic, assign)          NSInteger                         maxValue;
@property (nonatomic, assign)          NSInteger                         minValue;
@property (nonatomic, strong)          UIView                      *targetView;

@property (nonatomic, nullable, weak  ) IBOutlet UILabel                     *keypadValue;
@property (nonatomic, nullable, weak  ) IBOutlet UIView                      *keypadView;

// Returns the inputted number as an integer.
- (int)numberAsInteger;

// Returns the inputted number as a string.
- (NSString *)numberAsString;

// Sets the keypad's current value.
- (void)setKeyPadValue:(int)value;

// Updates the value label and notifies the delegate.
- (void)updateKeypadValue;

#pragma mark IBActions

// Called when the anything other than the keypad is tapped.
- (IBAction)backgroundTapped;

// Called when a numeric button is pressed.
- (IBAction)buttonTapped:(id)button;

// Clears the number.
- (IBAction)clearButtonTapped;

// Closes the dialog.
- (IBAction)closeButtonTapped;

@end




@protocol CVNumericKeyPadDelegate <NSObject>

// Called when the number is modified.
- (void)keyPad:(CVNumericKeyPadViewController *)keyPad didUpdateNumber:(NSString *)number;

// Called when the keypad should be closed.
- (void)keyPadWillClose:(CVNumericKeyPadViewController *)keyPad;

@end

NS_ASSUME_NONNULL_END