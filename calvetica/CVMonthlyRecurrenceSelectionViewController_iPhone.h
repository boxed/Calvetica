//
//  CVMonthlyRecurrenceSelectionViewController_iPad.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CVAutoResizableLabel.h"
#import "CVToggleButton.h"
#import "CVViewController.h"


@protocol CVMonthlyRecurrenceSelectionDelegate;


@interface CVMonthlyRecurrenceSelectionViewController_iPhone : CVViewController

#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVMonthlyRecurrenceSelectionDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIView *keys;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) NSMutableArray *selectedDays;
@property (nonatomic, strong) IBOutlet CVAutoResizableLabel *selectedDaysLabel;
@property (nonatomic, strong) UIView *targetView;

#pragma mark - Methods
+ (NSString *)daysOfTheMonthString:(NSArray *)daysOfTheMonth;
- (id)initWithTargetView:(UIView *)view selectedDays:(NSArray *)days;

#pragma mark - IBActions
- (IBAction)backgroundTapped;
- (IBAction)buttonTapped:(CVToggleButton *)button;

@end




@protocol CVMonthlyRecurrenceSelectionDelegate <NSObject>
@required
- (void)monthlyRecurrenceSelection:(CVMonthlyRecurrenceSelectionViewController_iPhone *)selection didUpdateSelectedDays:(NSArray *)selectedDays;
- (void)monthlyRecurrenceSelectionWillClose:(CVMonthlyRecurrenceSelectionViewController_iPhone *)selection;
@end