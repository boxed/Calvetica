//
//  CVMonthTableViewController_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthTableViewController.h"
#import "colors.h"
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

    [self resetStartDate];

    if (PAD) {
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
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

- (void)viewDidUnload
{
    [self setSelectedDayView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // center the current day
    if (PAD) {
        [self scrollToRowForDate:_selectedDate animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    else {
        [self scrollToRowForDate:[self.selectedDate mt_startOfCurrentMonth] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }

	self.selectedDate = [NSDate date];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}




#pragma mark - Public


- (void)reloadTableView
{
    [self.tableView reloadData];
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
            CGRect f = [self rectOfDayButtonInTableView:self.tableView forDate:_selectedDate];
            f = CGRectInset(f, -TODAY_BOX_INNER_OFFSET_IPAD, -TODAY_BOX_INNER_OFFSET_IPAD);
            [_selectedDayView setSuperFrame:f];
        };

        void (^complete)(void) = ^{
            [_selectedDayView.superview bringSubviewToFront:_selectedDayView];
            [_selectedDayView setNeedsDisplay];
            _selectedDayView.userInteractionEnabled = NO;
        };

        if (animated) {

            [UIView mt_animateViews:@[_selectedDayView]
                           duration:0.2
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
    c.backgroundColor = [UIColor clearColor];
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
    CGRect rect = CGRectZero;

    NSInteger row = [self rowOfDate:date];
    CGFloat boxHeight = tableView.rowHeight;

    CGFloat boxWidth = tableView.frame.size.width / 7.0;

    rect.origin.x       = floorf([self columnOfDate:date] * boxWidth);
    rect.origin.y       = floorf(row * boxHeight);
    rect.size.width     = floorf(boxWidth);
    rect.size.height    = floorf(boxHeight);

    return rect;
}


@end
