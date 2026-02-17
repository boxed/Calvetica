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
#import "CVEventViewController.h"
#import "CVQuickAddViewController.h"
#import "CVJumpToDateViewController.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVLandscapeWeekViewResult) {
    CVLandscapeWeekViewResultFinished,
    CVLandscapeWeekViewResultModified
};


@protocol CVLandscapeWeekViewDelegate;


@interface CVLandscapeWeekView : CVViewController <UITableViewDelegate, UITableViewDataSource, CVWeekdayTableViewCellDelegate, CVEventViewControllerDelegate, CVQuickAddViewControllerDelegate, CVJumpToDateViewControllerDelegate> {
@protected
    NSInteger currentMonthOfYear;
    BOOL userHasBegunInteracting;
    BOOL hasScrolledInitially;
}


#pragma mark - Properties
@property (nonatomic, nullable, weak  )          id<CVLandscapeWeekViewDelegate> delegate;
@property (nonatomic, nullable, weak  ) IBOutlet UITableView                     *weeksTable;
@property (nonatomic, copy  )          NSArray<CVWeekdayTableHeaderView *>                         *headerViews;
@property (nonatomic, strong)          NSDate                          *startDate;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                         *monthAndYearLabel;


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

NS_ASSUME_NONNULL_END
