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


@interface CVEventDayViewController_iPhone : CVViewController

@property (nonatomic, assign) id<CVEventDayViewControllerDelegate> delegate;
@property (nonatomic, copy) NSDate *initialDate;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) NSMutableArray *dayButtons;
@property (nonatomic, strong) NSMutableArray *weekButtons;

@property (nonatomic, strong) UINib *dayButtonNib;
@property (nonatomic, strong) IBOutlet UITableView *yearTableView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIView *dayButtonsContainer;
@property (nonatomic, strong) IBOutlet UIView *monthButtonsContainer;
@property (nonatomic, strong) IBOutlet UIView *weekButtonsContainer;
@property (nonatomic, strong) IBOutlet UIView *weekdayLabelContainer;

- (void)containerWasSwiped:(UISwipeGestureRecognizer *)gesture;
- (NSInteger)yearFromTableIndex:(NSInteger)index;
- (NSInteger)tableIndexFromYear:(NSInteger)year;

- (IBAction)dayButtonWasTapped:(id)sender;

@end




@protocol CVEventDayViewControllerDelegate <NSObject>
@required
- (void)eventDayViewController:(CVEventDayViewController_iPhone *)controller didUpdateDate:(NSDate *)date;
@end
