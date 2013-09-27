//
//  CVMonthTableViewController_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthTableViewController.h"
#import "CVWeekTableViewCell_iPad.h"
#import "CVWeekTableViewCell_iPhone.h"
#import "colors.h"
#import "NSDate+ViewHelpers.h"
#import "UIViewController+Utilities.h"




@implementation CVMonthTableViewController


#pragma mark - Properties

- (UINib *)weekCellNib 
{
    if (_weekCellNib == nil) {
        if (PAD) {
            self.weekCellNib = [CVWeekTableViewCell_iPad nib];
        }
        else {
            self.weekCellNib = [CVWeekTableViewCell_iPhone nib];
        }
    }
    return _weekCellNib;
}

- (void)setStartDate:(NSDate *)newStartDate
{
    _startDate = newStartDate;
    
    [self.tableView reloadData];
    [self drawDotsForVisibleRows];
}

- (void)setSelectedDate:(NSDate *)newSelectedDate
{
    _selectedDate = newSelectedDate;
    
    if (!_selectedDate) return;

    [self reframeRedSelectedDaySquareAnimated:YES];
}

- (void)setMode:(NSInteger)newMode 
{
    _mode = newMode;
    if (self.tableView.window) {
        
        // update the mode on each visible cell
        NSArray *visibleCells = [self.tableView visibleCells];
        for (CVWeekTableViewCell *cell in visibleCells) {
            cell.mode = self.mode;
        }
        
        [self.tableView reloadData];
        [self drawDotsForVisibleRows];
    }
}




#pragma mark - Methods

- (void)drawDotsForVisibleRows 
{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (CVWeekTableViewCell *cell in visibleCells) {
        [cell redraw];
    }
}

- (void)reloadRowForDate:(NSDate *)date 
{
    if (!date) return;
    
    NSInteger row = [_startDate rowOfDate:date];
    CVWeekTableViewCell *cell = (CVWeekTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
	[cell setNeedsDisplay];
}

- (void)scrollToRowForDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)position 
{
    if (!date) return;
    NSInteger row = [_startDate rowOfDate:date];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:position animated:animated];
}

- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated 
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];    
}

- (void)scrollToSelectedDay 
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_startDate rowOfDate:_selectedDate] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];    
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
            CGRect f = [_startDate rectOfDayButtonInTableView:self.tableView forDate:_selectedDate];
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
                           duration:0.1
                     timingFunction:kMTEaseOutSine
                         animations:^
            {
                [_selectedDayView setSuperFrame:CGRectInset(_selectedDayView.frame, 20, 20)];
            } completion:^{
                animations();
                [_selectedDayView setSuperFrame:CGRectInset(_selectedDayView.frame, 20, 20)];
                [UIView mt_animateViews:@[_selectedDayView]
                               duration:0.2
                         timingFunction:kMTEaseOutBack
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^
                {
                    [_selectedDayView setSuperFrame:CGRectInset(_selectedDayView.frame, -20, -20)];
                } completion:^{
                    complete();
                }];
            }];
        }
        else {
            animations();
            complete();
        }
    }
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // this turned on produces weird jumpy scrolling
    self.tableView.scrollsToTop = NO;
    
    self.startDate = [[[NSDate date] mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
    
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




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // the lazy load version
    CVWeekTableViewCell *cell = [CVWeekTableViewCell cellForTableView:tableView fromNib:self.weekCellNib];
    
    cell.absoluteStartDate = self.startDate;
    cell.weekStartDate = [self.startDate dateOfFirstDayOnRow:indexPath.row];
    cell.selectedDate = _selectedDate;
    cell.delegate = (id<CVWeekTableViewCellDelegate>)self.delegate;
    cell.mode = _mode;

    return cell;
}




#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVWeekTableViewCell *c = (CVWeekTableViewCell *)cell;
    [c redraw];
    c.backgroundColor = [UIColor clearColor];
}


@end
