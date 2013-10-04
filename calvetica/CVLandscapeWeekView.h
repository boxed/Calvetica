//
//  CVLandscapeWeekView.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"
#import "CVWeekdayTableHeaderView.h"
#import "CVWeekdayTableViewCell.h"
#import "CVViewController.h"
#import "CVEventViewController_iPhone.h"
#import "CVQuickAddViewController_iPhone.h"
#import "CVJumpToDateViewController_iPhone.h"
#import "NSArray+Utilities.h"

typedef enum {
    CVLandscapeWeekViewResultFinished,
    CVLandscapeWeekViewResultModified
} CVLandscapeWeekViewResult;


@protocol CVLandscapeWeekViewDelegate;


@interface CVLandscapeWeekView : CVViewController <UITableViewDelegate, UITableViewDataSource, CVWeekdayTableViewCellDelegate, CVEventViewControllerDelegate, CVQuickAddViewControllerDelegate, CVJumpToDateViewControllerDelegate> {
@protected
    NSInteger currentMonthOfYear;
    BOOL userHasBegunInteracting;
}


#pragma mark - Properties
@property (nonatomic, weak  )          id<CVLandscapeWeekViewDelegate> delegate;
@property (nonatomic, weak  ) IBOutlet UITableView                     *weeksTable;
@property (nonatomic, strong)          UINib                           *weekdayCellNib;
@property (nonatomic, strong)          UINib                           *weekdayHeaderNib;
@property (nonatomic, copy  )          NSArray                         *headerViews;
@property (nonatomic, strong)          NSDate                          *startDate;
@property (nonatomic, weak  ) IBOutlet UILabel                         *monthAndYearLabel;


#pragma mark - Methods
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;
- (CVWeekdayTableHeaderView *)unusedHeaderView;
- (void)reloadVisibleRows;


#pragma mark - IBActions
- (IBAction)monthLabelWasTapped:(id)sender;


@end




@protocol CVLandscapeWeekViewDelegate <NSObject>
@required
- (void)landscapeWeekViewController:(CVLandscapeWeekView *)controller didFinishWithResult:(CVLandscapeWeekViewResult)result;
@end
