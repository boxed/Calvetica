//
//  CVMonthTableViewController_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthTableViewController.h"
#import "colors.h"
#import "dimensions.h"
#import "NSDate+ViewHelpers.h"
#import "UIViewController+Utilities.h"
#import "CVWeekTableViewCell.h"


@interface CVMonthTableViewController () <CVWeekTableViewCellDelegate>
@end


@implementation CVMonthTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // this turned on produces weird jumpy scrolling
    self.tableView.scrollsToTop = NO;
//    [self.tableView setContentInset:UIEdgeInsetsMake(-50, 0, 0, 0)];

    [self resetStartDate];
    [self updateRowHeight];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!_hasAppeared) {
        _hasAppeared = YES;
        self.selectedDate = [NSDate date];
    }

    // center the current day
    if (PAD) {
        [self scrollToRowForDate:_selectedDate animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        // Update selection square after layout is fully complete
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reframeRedSelectedDaySquareAnimated:NO];
        });
    }
    else {
        [self scrollToRowForDate:[self.selectedDate mt_startOfCurrentMonth] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateRowHeight];
}



#pragma mark - Public

- (void)reloadTableView
{
    // Drop cached events on the visible (reusable) cells so they refetch when
    // the table reloads — otherwise a recycled cell reused for the same week
    // would keep showing stale data after an event was added or deleted.
    for (CVWeekTableViewCell *cell in [self.tableView visibleCells]) {
        cell.drawingView.lastFetchedStartDate = nil;
    }
    [self.tableView reloadData];
}

- (void)redrawVisibleCells
{
    for (CVWeekTableViewCell *cell in [self.tableView visibleCells]) {
        [cell reloadData];
    }
}

- (void)resetStartDate
{
    self.startDate = [[[NSDate date] mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
}

- (void)reloadRowForDate:(NSDate *)date
{
    if (!date) return;

    NSInteger row = [self rowOfDate:date];
    if (![self rowIsInTable:row]) return;
    CVWeekTableViewCell *cell = (CVWeekTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell reloadData];
}

- (void)scrollToRowForDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)position
{
    if (!date) return;
    NSInteger row = [self rowOfDate:date];
    if (![self rowIsInTable:row]) {
        // The table covers a fixed window of weeks after startDate. A date
        // outside that window (jumping/paging years away) would produce an
        // invalid index path and crash, so slide the window to the date instead.
        self.startDate = [[date mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
        row = [self rowOfDate:date];
        if (![self rowIsInTable:row]) return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                          atScrollPosition:position
                                  animated:animated];
}

- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated
{
    if (![self rowIsInTable:row]) return;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:animated];
}

- (void)scrollToSelectedDay
{
    [self scrollToRowForDate:_selectedDate animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)ensureSelectedDayVisible
{
    if (!_selectedDate) return;
    NSInteger row = [self rowOfDate:_selectedDate];
    if (![self rowIsInTable:row]) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    CGRect rowRect = [self.tableView rectForRowAtIndexPath:indexPath];
    if (CGRectIntersectsRect(rowRect, self.tableView.bounds)) {
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionNone
                                      animated:NO];
    }
}

- (NSInteger)rowInMiddleOfVisibleRegion 
{
    NSArray *visibleCells = [self.tableView visibleCells];
    CVWeekTableViewCell *cell = [visibleCells objectAtIndex:round(visibleCells.count / 2.0)];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    return path.row;
}

- (void)reframeRedSelectedDaySquareAnimated:(BOOL)animated
{
    if (!_selectedDate) return;
    if (![self rowIsInTable:[self rowOfDate:_selectedDate]]) return;

    // only do this if the table view has been added to the screen
    if (self.tableView.window) {

        void (^animations)(void) = ^{
            CGRect f = [self rectOfDayButtonInTableView:self.tableView forDate:self->_selectedDate];
            f = CGRectInset(f, -TODAY_BOX_INNER_OFFSET_IPAD, -TODAY_BOX_INNER_OFFSET_IPAD);
            [self->_selectedDayView setSuperFrame:f];
        };

        void (^complete)(void) = ^{
            [self->_selectedDayView.superview bringSubviewToFront:self->_selectedDayView];
            [self->_selectedDayView setNeedsDisplay];
            self->_selectedDayView.userInteractionEnabled = NO;
        };

        if (animated) {

            [UIView mt_animateWithDuration:0.2
                            timingFunction:kMTEaseInOutExpo
                                animations:^
             {
                 animations();
             } completion:^{
                 complete();
             }];
        }
        else {
            animations();
            complete();
        }
    }
}


#pragma mark (properties)

- (void)setStartDate:(NSDate *)newStartDate
{
    _startDate = newStartDate;
    [self reloadTableView];
}






#pragma mark - DATASOURCE table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *cellIdentifier = @"CVWeekTableViewCell";
    CVWeekTableViewCell *cell = (CVWeekTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                       forIndexPath:indexPath];
    cell.weekStartDate      = [self dateOfFirstDayOnRow:indexPath.row];
    cell.selectedDate       = _selectedDate;
    cell.delegate           = self;

    return cell;
}




#pragma mark - DELEGATE scroll view

// The table is a fixed window of weeks (numberOfRowsInSection:), so on its own
// it has hard edges roughly two years back and seventeen years forward of
// startDate. To make scrolling feel infinite, slide the window back to the
// middle whenever a user-driven scroll approaches an edge: shifting startDate
// and contentOffset by the same number of rows keeps every visible date at the
// same position on screen, so the recenter is invisible.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Only for user-driven scrolling — recentering during an animated
    // scrollToRow* would change the date its target offset lands on.
    if (scrollView.isDragging || scrollView.isDecelerating) {
        [self recenterIfNeeded];
    }
}

- (void)recenterIfNeeded
{
    UITableView *tableView = self.tableView;
    CGFloat rowHeight = tableView.rowHeight;
    if (rowHeight <= 0 || !self.startDate) return;

    NSInteger totalRows = [self tableView:tableView numberOfRowsInSection:0];
    NSInteger visibleRows = ceil(tableView.bounds.size.height / rowHeight);
    NSInteger topRow = floor(tableView.contentOffset.y / rowHeight);
    NSInteger margin = 50;
    if (topRow >= margin && topRow + visibleRows + margin <= totalRows) return;

    NSInteger centeredTopRow = (totalRows - visibleRows) / 2;
    NSInteger shiftWeeks = topRow - centeredTopRow;
    if (shiftWeeks == 0) return;

    // Set the ivar directly: the setter reloads the whole table, which would
    // drop every cell's cached events. The contentOffset change below makes the
    // table rebind the visible rows through cellForRowAtIndexPath: on its own.
    _startDate = [[_startDate mt_dateWeeksAfter:shiftWeeks] mt_startOfCurrentWeek];
    CGPoint offset = tableView.contentOffset;
    offset.y -= shiftWeeks * rowHeight;
    tableView.contentOffset = offset;
    [self reframeRedSelectedDaySquareAnimated:NO];
}




#pragma mark - DELEGATE table view

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVWeekTableViewCell *c = (CVWeekTableViewCell *)cell;
    [c redraw];
    c.backgroundColor = patentedClear;
}




#pragma mark - DELEGATE week cell

- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasPressedOnDate:(NSDate *)date
{
    [self.delegate monthTableViewController:self tappedCell:cell onDate:date];
}

- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasLongPressedOnDate:(NSDate *)date withPlaceholder:(UIView *)placeholder
{
    [self.delegate monthTableViewController:self longPressedOnCell:cell onDate:date placeholderView:placeholder];
}



#pragma mark - Private

- (void)updateRowHeight
{
    CGFloat newHeight;
    if (IS_MAC) {
        // On Mac, dynamically fill the visible area with 6 weeks
        newHeight = floor(self.tableView.bounds.size.height / 6.0);
        if (newHeight < MAC_MONTH_VIEW_ROW_HEIGHT_PORTRAIT) {
            newHeight = MAC_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
        }
    }
    else if (PAD) {
        CGSize size = self.view.bounds.size;
        newHeight = (size.width > size.height)
            ? IPAD_MONTH_VIEW_ROW_HEIGHT_LANDSCAPE
            : IPAD_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
    }
    else {
        newHeight = IPHONE_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
    }
    if (self.tableView.rowHeight != newHeight) {
        self.tableView.rowHeight = newHeight;
        [self ensureSelectedDayVisible];
        [self reframeRedSelectedDaySquareAnimated:NO];
    }
}

- (NSDate *)dateOfFirstDayOnRow:(NSInteger)row
{
    return [[self.startDate mt_dateWeeksAfter:row] mt_startOfCurrentWeek];
}

- (NSInteger)rowOfDate:(NSDate *)date
{
    return [date mt_weeksSinceDate:self.startDate];
}

- (BOOL)rowIsInTable:(NSInteger)row
{
    return row >= 0 && row < [self tableView:self.tableView numberOfRowsInSection:0];
}

- (NSInteger)columnOfDate:(NSDate *)date
{
    NSInteger row = [self rowOfDate:date];
    NSDate *firstDate = [self dateOfFirstDayOnRow:row];
    return [date mt_daysSinceDate:firstDate];
}

- (CGRect)rectOfDayButtonInTableView:(UITableView *)tableView forDate:(NSDate *)date
{
    NSInteger row = [self rowOfDate:date];
    if (![self rowIsInTable:row]) return CGRectZero;
    NSInteger column = [self columnOfDate:date];

    // Get the actual rect for this row from the table view
    CGRect rowRect = [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

    CGFloat boxWidth = tableView.frame.size.width / 7.0;
    CGFloat boxHeight = rowRect.size.height;

    CGRect rect;
    rect.origin.x = floorf(column * boxWidth);
    rect.origin.y = rowRect.origin.y;
    rect.size.width = floorf(boxWidth);
    rect.size.height = floorf(boxHeight);

    return rect;
}


@end
