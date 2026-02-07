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

    if (PAD) {
        // Use view bounds to reliably detect orientation on initial launch
        CGSize size = self.view.bounds.size;
        if (size.width > size.height) {
            self.tableView.rowHeight = IPAD_MONTH_VIEW_ROW_HEIGHT_LANDSCAPE;
        }
        else {
            self.tableView.rowHeight = IPAD_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
        }
    }
    else {
        self.tableView.rowHeight = IPHONE_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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

	self.selectedDate = [NSDate date];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (PAD) {
        // Ensure row height is correct after layout is complete
        CGSize size = self.view.bounds.size;
        CGFloat expectedRowHeight = (size.width > size.height)
            ? IPAD_MONTH_VIEW_ROW_HEIGHT_LANDSCAPE
            : IPAD_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
        if (self.tableView.rowHeight != expectedRowHeight) {
            self.tableView.rowHeight = expectedRowHeight;
        }
    }
}



#pragma mark - Public

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)redrawVisibleCells
{
    for (CVWeekTableViewCell *cell in [self.tableView visibleCells]) {
        [cell redraw];
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
    CVWeekTableViewCell *cell = (CVWeekTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell redraw];
}

- (void)scrollToRowForDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)position 
{
    if (!date) return;
    NSInteger row = [self rowOfDate:date];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                          atScrollPosition:position
                                  animated:animated];
}

- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated 
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:animated];
}

- (void)scrollToSelectedDay 
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self rowOfDate:_selectedDate] inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];
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

- (NSDate *)dateOfFirstDayOnRow:(NSUInteger)row
{
    return [[self.startDate mt_dateWeeksAfter:row] mt_startOfCurrentWeek];
}

- (NSInteger)rowOfDate:(NSDate *)date
{
    return [date mt_weeksSinceDate:self.startDate];
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
