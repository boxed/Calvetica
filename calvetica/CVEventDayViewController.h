//
//  CVDateViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CVJumpToDayButton;




@protocol CVEventDayViewControllerProtocol <NSObject>
@required
- (void)setDate:(NSDate *)date;
- (NSDate *)date;
@end


@protocol CVEventDayViewControllerDelegate;


@interface CVEventDayViewController : CVViewController

@property (nonatomic, nullable, weak  ) id<CVEventDayViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate                               *initialDate;
@property (nonatomic, strong) NSDate                               *date;
@property (nonatomic, strong) NSMutableArray<CVJumpToDayButton *>                       *dayButtons;
@property (nonatomic, strong) NSMutableArray<CVJumpToDayButton *>                       *weekButtons;

@property (nonatomic, nullable, weak  ) IBOutlet UITableView  *yearTableView;
@property (nonatomic, nullable, weak  ) IBOutlet UIScrollView *scrollView;
@property (nonatomic, nullable, weak  ) IBOutlet UIView       *containerView;
@property (nonatomic, nullable, weak  ) IBOutlet UIView       *dayButtonsContainer;
@property (nonatomic, nullable, weak  ) IBOutlet UIView       *monthButtonsContainer;
@property (nonatomic, nullable, weak  ) IBOutlet UIView       *weekButtonsContainer;
@property (nonatomic, nullable, weak  ) IBOutlet UIView       *weekdayLabelContainer;

- (void)containerWasSwiped:(UISwipeGestureRecognizer *)gesture;
- (NSInteger)yearFromTableIndex:(NSInteger)index;
- (NSInteger)tableIndexFromYear:(NSInteger)year;

- (IBAction)dayButtonWasTapped:(id)sender;

@end




@protocol CVEventDayViewControllerDelegate <NSObject>
@required
- (void)eventDayViewController:(CVEventDayViewController *)controller didUpdateDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
