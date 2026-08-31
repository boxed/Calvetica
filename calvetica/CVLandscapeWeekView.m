//
//  CVLandscapeWeekView.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVLandscapeWeekView.h"




@implementation CVLandscapeWeekView

- (void)setStartDate:(NSDate *)newStartDate 
{
    _startDate = [[newStartDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    userHasBegunInteracting = NO;
    
//    UISwipeGestureRecognizer *slideInLandscapeWeekGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerSwipeOnWeekView:)];
//    slideInLandscapeWeekGesture.numberOfTouchesRequired = 3;
//    slideInLandscapeWeekGesture.direction = UISwipeGestureRecognizerDirectionDown;
//    [_weeksTable addGestureRecognizer:slideInLandscapeWeekGesture];

    self.weeksTable.scrollsToTop = NO;
    currentMonthOfYear = 0;

    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Initial scroll to today (once) so we don't start in 2024
    if (!hasScrolledInitially) {
        hasScrolledInitially = YES;
        [self scrollToDate:[NSDate date] animated:NO];
    }
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




#pragma mark - Methods

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) return;

    NSInteger daysSinceStart = [date mt_daysSinceDate:self.startDate];
    NSInteger totalDays = [self numberOfSectionsInTableView:self.weeksTable]
                        * [self tableView:self.weeksTable numberOfRowsInSection:0];

    // The table covers a fixed window of days after startDate. A date outside
    // that window (jumping years away) would produce an invalid index path and
    // crash, so slide the window to the date instead.
    if (daysSinceStart < 0 || daysSinceStart >= totalDays) {
        self.startDate = date; // the setter re-anchors 100 weeks earlier
        [self.weeksTable reloadData];
        daysSinceStart = [date mt_daysSinceDate:self.startDate];
        if (daysSinceStart < 0 || daysSinceStart >= totalDays) return;
    }

    NSInteger row = daysSinceStart % 7;
    NSInteger section = daysSinceStart / 7;
    [self.weeksTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:animated];
}

- (CVWeekdayTableHeaderView *)unusedHeaderView 
{
    for (CVWeekdayTableHeaderView *headerView in self.headerViews) {
        if (!headerView.window) {
            return headerView;
        }
    }
    return nil;
}

- (void)reloadVisibleRows 
{
    NSArray *visibleCells = [self.weeksTable visibleCells];
    for (CVWeekdayTableViewCell *cell in visibleCells) {
        [cell drawEventSquares];
    }
}




#pragma mark - IBActions

- (IBAction)monthLabelWasTapped:(id)sender 
{
}




#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 300;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return nil;
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userHasBegunInteracting = YES;
}

// The table is a fixed window of weeks (one section per week), so on its own it
// has hard edges a couple of years either side of startDate. To make scrolling
// feel infinite, slide the window back to the middle whenever a user-driven
// scroll approaches an edge: shifting startDate and contentOffset by the same
// number of sections keeps every visible date at the same position on screen.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Only for user-driven scrolling — recentering during an animated
    // scrollToDate: would change the date its target offset lands on.
    if (scrollView == self.weeksTable && (scrollView.isDragging || scrollView.isDecelerating)) {
        [self recenterWeeksTableIfNeeded];
    }
}

- (void)recenterWeeksTableIfNeeded
{
    UITableView *tableView = self.weeksTable;
    if (!self.startDate) return;
    CGFloat sectionHeight = [tableView rectForSection:0].size.height;
    if (sectionHeight <= 0) return;

    NSInteger totalSections = [self numberOfSectionsInTableView:tableView];
    NSInteger visibleSections = ceil(tableView.bounds.size.height / sectionHeight);
    NSInteger topSection = floor(tableView.contentOffset.y / sectionHeight);
    NSInteger margin = 20;
    if (topSection >= margin && topSection + visibleSections + margin <= totalSections) return;

    NSInteger centeredTopSection = (totalSections - visibleSections) / 2;
    NSInteger shiftWeeks = topSection - centeredTopSection;
    if (shiftWeeks == 0) return;

    // Set the ivar directly — the setter re-anchors 100 weeks earlier. The
    // contentOffset change below makes the table rebind the visible rows
    // through cellForRowAtIndexPath: on its own.
    _startDate = [[_startDate mt_dateWeeksAfter:shiftWeeks] mt_startOfCurrentWeek];
    CGPoint offset = tableView.contentOffset;
    offset.y -= shiftWeeks * sectionHeight;
    tableView.contentOffset = offset;
}




#pragma mark - Cell Delegate

- (void)weekdayCellHeaderWasTapped:(CVWeekdayTableViewCell *)cell
{
    // Removed scroll-to-today for debugging
}

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder 
{
}

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder 
{
}





#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController *)controller didFinishWithResult:(CVEventResult)result
{
    if (result == CVEventResultSaved) {

    }
    else if (result == CVEventResultDeleted) {
        
    }
    [self reloadVisibleRows];
}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController *)controller didCompleteWithAction:(CVQuickAddResult)result
{
}




#pragma mark - CVJumpToDateViewControllerDelegate Methods

- (void)jumpToDateViewController:(CVJumpToDateViewController *)controller didFinishWithResult:(CVJumpToDateResult)result
{
}


@end
