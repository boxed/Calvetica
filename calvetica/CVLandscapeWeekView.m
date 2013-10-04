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
    
    UISwipeGestureRecognizer *slideInLandscapeWeekGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerSwipeOnWeekView:)];
    slideInLandscapeWeekGesture.numberOfTouchesRequired = 3;
    slideInLandscapeWeekGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [_weeksTable addGestureRecognizer:slideInLandscapeWeekGesture];
    
    currentMonthOfYear = 0;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated 
{
    NSDate *dateToScrollTo = [NSDate date];
    [self scrollToDate:dateToScrollTo animated:NO];
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




#pragma mark - Methods

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated 
{
    NSDate *newDate = self.startDate;
    NSInteger daysSinceStart = [date mt_daysSinceDate:newDate];
    
    NSInteger row = daysSinceStart % 7;
    NSInteger section = floor(daysSinceStart / 7);
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




#pragma mark - Cell Delegate

- (void)weekdayCellHeaderWasTapped:(CVWeekdayTableViewCell *)cell 
{
    [self scrollToDate:[NSDate date] animated:YES];
}

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder 
{
}

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder 
{
}





#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController_iPhone *)controller didFinishWithResult:(CVEventResult)result
{
    if (result == CVEventResultSaved) {

    }
    else if (result == CVEventResultDeleted) {
        
    }
    [self reloadVisibleRows];
}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)result
{
}

#pragma mark - CVJumpToDateViewControllerDelegate Methods

- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller didFinishWithResult:(CVJumpToDateResult)result
{
}


@end
