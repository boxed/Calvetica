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

NS_ASSUME_NONNULL_BEGIN



@protocol CVMonthlyRecurrenceSelectionDelegate;


@interface CVMonthlyRecurrenceSelectionViewController : CVViewController

@property (nonatomic, nullable, weak  )          id<CVMonthlyRecurrenceSelectionDelegate> delegate;
@property (nonatomic, nullable, weak  ) IBOutlet UIView                                   *keys;
@property (nonatomic, nullable, weak  ) IBOutlet UIView                                   *mainView;
@property (nonatomic, strong  )          NSMutableArray<NSNumber *>                           *selectedDays;
@property (nonatomic, nullable, weak  ) IBOutlet CVAutoResizableLabel                     *selectedDaysLabel;
@property (nonatomic, strong)          UIView                                   *targetView;

+ (NSString *)daysOfTheMonthString:(NSArray *)daysOfTheMonth;
- (instancetype)initWithTargetView:(UIView *)view selectedDays:(NSArray *)days;

@end




@protocol CVMonthlyRecurrenceSelectionDelegate <NSObject>
@required
- (void)monthlyRecurrenceSelection:(CVMonthlyRecurrenceSelectionViewController *)selection didUpdateSelectedDays:(NSArray *)selectedDays;
- (void)monthlyRecurrenceSelectionWillClose:(CVMonthlyRecurrenceSelectionViewController *)selection;
@end

NS_ASSUME_NONNULL_END