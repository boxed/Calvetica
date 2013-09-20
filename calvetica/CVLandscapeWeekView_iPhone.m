//  CVLandscapeWeekView_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVLandscapeWeekView_iPhone.h"
#import "CVWeekdayTableViewCell_iPhone.h"
#import "CVWeekdayTableHeaderView_iPhone.h"
#import "UIApplication+Utilities.h"
#import "geometry.h"
#import "EKCalendarItem+Calvetica.h"
#import "CVReminderViewController_iPhone.h"




@implementation CVLandscapeWeekView_iPhone

@synthesize weekdayCellNib = _weekdayCellNib;

- (UINib *)weekdayCellNib 
{
    if (!_weekdayCellNib) {
        _weekdayCellNib = [CVWeekdayTableViewCell_iPhone nib];
    }
    return _weekdayCellNib;
}

@synthesize weekdayHeaderNib = _weekdayHeaderNib;

- (UINib *)weekdayHeaderNib 
{
    if (!_weekdayHeaderNib) {
        _weekdayHeaderNib = [CVWeekdayTableHeaderView_iPhone nib];
    }
    return _weekdayHeaderNib;
}

@synthesize headerViews = _headerViews;

- (NSArray *)headerViews 
{
    if (!_headerViews) {
        CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90.0f));

        CVWeekdayTableHeaderView_iPhone *cell1 = [CVWeekdayTableHeaderView_iPhone viewFromNib:self.weekdayHeaderNib];
        cell1.transform = rotateTransform;

        CVWeekdayTableHeaderView_iPhone *cell2 = [CVWeekdayTableHeaderView_iPhone viewFromNib:self.weekdayHeaderNib];
        cell2.transform = rotateTransform;

        CVWeekdayTableHeaderView_iPhone *cell3 = [CVWeekdayTableHeaderView_iPhone viewFromNib:self.weekdayHeaderNib];
        cell3.transform = rotateTransform;

        _headerViews = @[cell1, cell2, cell3];
    }
    return _headerViews;
}

- (void)viewDidLoad 
{
    // rotate table
    CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90.0f));
    self.weeksTable.transform = rotateTransform;
    
    // flip the dimensions of table
    CGRect r = self.weeksTable.frame;
    CGFloat t = r.size.width;
    r.size.width = r.size.height;
    r.size.height = t;
    r.origin.x = 0;
    r.origin.y = 20;
    self.weeksTable.frame = r;
    
    self.monthAndYearLabel.text = [[NSDate date] stringWithTitleOfCurrentMonthAndYearAbbreviated:YES];
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadVisibleRows];
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}





#pragma mark - Methods

- (IBAction)monthLabelWasTapped:(id)sender 
{
    [super monthLabelWasTapped:sender];
    NSArray *array = [self.weeksTable visibleCells];    
    NSIndexPath *indexPath = [self.weeksTable indexPathForCell:[array firstObject]];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row + 1;
    NSTimeInterval interval = (row * SECONDS_IN_DAY) + (section * SECONDS_IN_WEEK);
    NSDate *date = [NSDate dateWithTimeInterval:interval sinceDate:self.startDate];
    
    [self openJumpToDateWithDate:date];
}

- (void)openQuickAddWithDate:(NSDate *)datePressed allDay:(BOOL)allDay 
{
    CVQuickAddViewController_iPhone *quickAddViewController = [[CVQuickAddViewController_iPhone alloc] initWithNibName:@"CVQuickAddViewController-Landscape_iPhone" bundle:nil];
    quickAddViewController.delegate = self;
    quickAddViewController.startDate = datePressed;
    quickAddViewController.isAllDay = allDay;
    quickAddViewController.isDurationMode = NO;
    [self presentFullScreenModalViewController:quickAddViewController animated:YES];
    
    [quickAddViewController displayDefault];
}

// calv4.3 needs to be included
- (void)openJumpToDateWithDate:(NSDate *)date 
{
    CVEventDayViewController_iPhone *eventDayViewController = [[CVEventDayViewController_iPhone alloc] init];
    eventDayViewController.initialDate = date;
    CVJumpToDateViewController_iPhone *jumpToDateController = [[CVJumpToDateViewController_iPhone alloc] initWithContentViewController:eventDayViewController];
    jumpToDateController.delegate = self;
    [self presentPageModalViewController:jumpToDateController animated:YES];
}


#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVWeekdayTableViewCell_iPhone *cell = [CVWeekdayTableViewCell_iPhone viewFromNib:self.weekdayCellNib];
    
    NSInteger daysAfter = (indexPath.section * 7) + indexPath.row;
    cell.date = [self.startDate mt_dateDaysAfter:daysAfter];
    cell.delegate = self;
    
    // rotate the cell
    CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90.0f));
    cell.transform = rotateTransform;
    
    // if a cell with a different month enters the screen, change the month
    if ([cell.date mt_monthOfYear] != currentMonthOfYear && userHasBegunInteracting) {
        currentMonthOfYear = [cell.date mt_monthOfYear];
        self.monthAndYearLabel.text = [cell.date stringWithTitleOfCurrentMonthAndYearAbbreviated:YES];
        [UIApplication showBezelWithTitle:self.monthAndYearLabel.text];
    }
    
    return cell;
}





#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    CVWeekdayTableHeaderView_iPhone *cell = (CVWeekdayTableHeaderView_iPhone *)[self unusedHeaderView];
    
    // set date
    NSInteger daysAfter = section * 7;
    cell.date = [self.startDate mt_dateDaysAfter:daysAfter];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVWeekdayTableViewCell_iPhone *c = (CVWeekdayTableViewCell_iPhone *)cell;
    [c drawEventSquares];
}




#pragma mark - Cell Delegate

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder 
{
    [super weekdayCell:cell wasLongPressedAtDate:datePressed allDay:allDay withPlaceholder:placeholder];
    
    CVActionBlockButton *time1 = nil;
    CVActionBlockButton *time2 = nil;
    CVActionBlockButton *time3 = nil;
    
    if (allDay) datePressed = [datePressed mt_startOfCurrentDay];
    
    NSDate *timeChoice1 = [datePressed mt_startOfPreviousHour];
    NSDate *timeChoice2 = [datePressed mt_startOfCurrentHour];
    NSDate *timeChoice3 = [datePressed mt_startOfNextHour];
    
    if (![timeChoice1 mt_isWithinSameDay:datePressed]) {
        time1 = [CVActionBlockButton buttonWithTitle:@"ALL DAY" andActionBlock:^(void) {
            NSDate *dateToReturn = timeChoice1;
            [self openQuickAddWithDate:dateToReturn allDay:YES];
        }];        
    }
    else {
        time1 = [CVActionBlockButton buttonWithTitle:[NSString stringWithFormat:@"%@", [timeChoice1 stringWithHourAndLowercaseAMPM]] andActionBlock:^(void) {
            NSDate *dateToReturn = timeChoice1;
            [self openQuickAddWithDate:dateToReturn allDay:NO];
        }];
    }
    
    time2 = [CVActionBlockButton buttonWithTitle:[NSString stringWithFormat:@"%@", [timeChoice2 stringWithHourAndLowercaseAMPM]] andActionBlock:^(void) {
        NSDate *dateToReturn = timeChoice2;
        [self openQuickAddWithDate:dateToReturn allDay:NO];
    }];
    
    time3 = [CVActionBlockButton buttonWithTitle:[NSString stringWithFormat:@"%@", [timeChoice3 stringWithHourAndLowercaseAMPM]] andActionBlock:^(void) {
        NSDate *dateToReturn = timeChoice3;
        [self openQuickAddWithDate:dateToReturn allDay:NO];
    }];
    
    [UIApplication showAlertWithTitle:[NSLocalizedString(@"Just making sure", @"The title of the prompt when a user long presses on week view to add a new event") uppercaseString] message:NSLocalizedString(@"Just wanted to make sure you select the right time:", @"This asks the user to select from a list of times to add an event to.") buttons:@[time1, time2, time3]];

    [self reloadVisibleRows];
}

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder 
{
    [super weekdayCell:cell wasPressedOnEvent:event withPlaceholder:placeholder];
    
    // put up the edit event modal
    CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:event andMode:CVEventModeDetails];
    eventViewController.delegate = self;
    [self presentPageModalViewController:eventViewController animated:YES];
}





#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController_iPhone *)controller didFinishWithResult:(CVEventResult)result
{
    [super eventViewController:controller didFinishWithResult:result];
    if (result) {
        [self.delegate landscapeWeekViewController:self didFinishWithResult:CVLandscapeWeekViewResultModified];
    }
    [self dismissPageModalViewControllerAnimated:NO];

}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)result
{
    [super quickAddViewController:controller didCompleteWithAction:result];
	
	[self dismissFullScreenModalViewControllerAnimated:YES];
	
    if (result == CVQuickAddResultMore) {
		if (controller.calendarItem.isEvent) {
			CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:(EKEvent *)controller.calendarItem andMode:CVEventModeDetails];
			eventViewController.delegate = self;
			[self presentPageModalViewController:eventViewController animated:YES];		}
		else {
			CVReminderViewController_iPhone *reminderViewController = [[CVReminderViewController_iPhone alloc] initWithReminder:(EKReminder *)controller.calendarItem andMode:CVEventModeDetails];
			reminderViewController.delegate = self;
			[self presentPageModalViewController:reminderViewController animated:YES];
		}
    }
    else {
        [self reloadVisibleRows];
    }
    
    if (result == CVQuickAddResultSaved) {
        [self.delegate landscapeWeekViewController:self didFinishWithResult:CVLandscapeWeekViewResultModified];
    }

}

#pragma mark - CVJumpToDateViewControllerDelegate Methods

- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller didFinishWithResult:(CVJumpToDateResult)result
{
    [super jumpToDateViewController:controller didFinishWithResult:result];
    
    [self dismissPageModalViewControllerAnimated:YES];
    
    if (result == CVJumpToDateResultDateChosen) {
        [self scrollToDate:controller.chosenDate animated:YES];
    }
}


@end
