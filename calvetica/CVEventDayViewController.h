//
//  CVDateViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"



@protocol CVEventDayViewControllerProtocol <NSObject>
@required
- (void)setDate:(NSDate *)date;
- (NSDate *)date;
@end


@protocol CVEventDayViewControllerDelegate;


@interface CVEventDayViewController : CVViewController

@property (nonatomic, weak  ) id<CVEventDayViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate                               *initialDate;
@property (nonatomic, strong) NSDate                               *date;
@property (nonatomic, strong) NSMutableArray                       *dayButtons;
@property (nonatomic, strong) NSMutableArray                       *weekButtons;

@property (nonatomic, weak  ) IBOutlet UITableView  *yearTableView;
@property (nonatomic, weak  ) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak  ) IBOutlet UIView       *containerView;
@property (nonatomic, weak  ) IBOutlet UIView       *dayButtonsContainer;
@property (nonatomic, weak  ) IBOutlet UIView       *monthButtonsContainer;
@property (nonatomic, weak  ) IBOutlet UIView       *weekButtonsContainer;
@property (nonatomic, weak  ) IBOutlet UIView       *weekdayLabelContainer;

- (void)containerWasSwiped:(UISwipeGestureRecognizer *)gesture;
- (NSInteger)yearFromTableIndex:(NSInteger)index;
- (NSInteger)tableIndexFromYear:(NSInteger)year;

- (IBAction)dayButtonWasTapped:(id)sender;

@end




@protocol CVEventDayViewControllerDelegate <NSObject>
@required
- (void)eventDayViewController:(CVEventDayViewController *)controller didUpdateDate:(NSDate *)date;
@end
