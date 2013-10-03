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

@property (nonatomic, weak  )          id<CVMonthlyRecurrenceSelectionDelegate> delegate;
@property (nonatomic, weak  ) IBOutlet UIView                                   *keys;
@property (nonatomic, weak  ) IBOutlet UIView                                   *mainView;
@property (nonatomic, strong  )          NSMutableArray                           *selectedDays;
@property (nonatomic, weak  ) IBOutlet CVAutoResizableLabel                     *selectedDaysLabel;
@property (nonatomic, strong)          UIView                                   *targetView;

+ (NSString *)daysOfTheMonthString:(NSArray *)daysOfTheMonth;
- (id)initWithTargetView:(UIView *)view selectedDays:(NSArray *)days;

@end




@protocol CVMonthlyRecurrenceSelectionDelegate <NSObject>
@required
- (void)monthlyRecurrenceSelection:(CVMonthlyRecurrenceSelectionViewController_iPhone *)selection didUpdateSelectedDays:(NSArray *)selectedDays;
- (void)monthlyRecurrenceSelectionWillClose:(CVMonthlyRecurrenceSelectionViewController_iPhone *)selection;
@end