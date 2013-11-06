//
//  CVLandscapeWeekView_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVLandscapeWeekView_iPad.h"
#import "CVWeekdayTableViewCell_iPad.h"
#import "CVWeekdayTableHeaderView_iPad.h"
#import "UIApplication+Utilities.h"
#import "geometry.h"



@implementation CVLandscapeWeekView_iPad

@synthesize headerViews = _headerViews;

- (NSArray *)headerViews 
{
    if (!_headerViews) {
        CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(90.0f));
        
        CVWeekdayTableHeaderView_iPad *cell1 = [CVWeekdayTableHeaderView_iPad fromNibOfSameName];
        cell1.transform = rotateTransform;
        
        CVWeekdayTableHeaderView_iPad *cell2 = [CVWeekdayTableHeaderView_iPad fromNibOfSameName];
        cell2.transform = rotateTransform;
        
        CVWeekdayTableHeaderView_iPad *cell3 = [CVWeekdayTableHeaderView_iPad fromNibOfSameName];
        cell3.transform = rotateTransform;
        
        _headerViews = @[cell1, cell2, cell3];
    }
    return _headerViews;
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    // grab original coords
    CGFloat tableX = self.weeksTable.frame.origin.x;
    CGFloat tableY = self.weeksTable.frame.origin.y;
    
    // rotate table
    CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90.0f));
    self.weeksTable.transform = rotateTransform;
    
    // flip the dimensions of table
    CGRect r = self.weeksTable.frame;
    CGFloat t = r.size.width;
    r.size.width = r.size.height;
    r.size.height = t;
    r.origin.x = tableX;
    r.origin.y = tableY;
    self.weeksTable.frame = r;

    UISwipeGestureRecognizer *slideInLandscapeWeekGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerSwipeOnWeekView:)];
    slideInLandscapeWeekGesture.numberOfTouchesRequired = 3;
    slideInLandscapeWeekGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.weeksTable addGestureRecognizer:slideInLandscapeWeekGesture];

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.monthAndYearLabel.text = [[NSDate date] stringWithTitleOfCurrentMonthAndYearAbbreviated:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return NO;
}





#pragma mark - Methods

- (void)openJumpToDateWithDate:(NSDate *)date 
{
    CVEventDayViewController *eventDayViewController = [[CVEventDayViewController alloc] init];
    eventDayViewController.initialDate = date;
    CVJumpToDateViewController *jumpToDateController = [[CVJumpToDateViewController alloc] initWithContentViewController:eventDayViewController];
    jumpToDateController.delegate = self;
    jumpToDateController.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
    [self presentPopoverModalViewController:jumpToDateController forView:self.monthAndYearLabel animated:YES];
}




#pragma mark - IBActions

- (IBAction)monthLabelWasTapped:(id)sender 
{
    [super monthLabelWasTapped:sender];
    NSArray *array = [self.weeksTable visibleCells];    
    NSIndexPath *indexPath = [self.weeksTable indexPathForCell:[array firstObject]];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row + 1;
    NSTimeInterval interval = (row * MTDateConstantSecondsInDay) + (section * MTDateConstantSecondsInWeek);
    NSDate *date = [NSDate dateWithTimeInterval:interval sinceDate:self.startDate];
    
    [self openJumpToDateWithDate:date];
}

- (IBAction)closeButtonWasTapped:(id)sender 
{
    [self.delegate landscapeWeekViewController:self didFinishWithResult:CVLandscapeWeekViewResultFinished];
}

- (IBAction)handleThreeFingerSwipeOnWeekView:(UISwipeGestureRecognizer *)gesture 
{
    [self closeButtonWasTapped:nil];
}




#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{

    CVWeekdayTableViewCell_iPad *cell = [CVWeekdayTableViewCell_iPad cellForTableView:tableView];
    
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
    CVWeekdayTableHeaderView_iPad *cell = (CVWeekdayTableHeaderView_iPad *)[self unusedHeaderView];
    
    // set date
    NSInteger daysAfter = section * 7;
    cell.date = [self.startDate mt_dateDaysAfter:daysAfter];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVWeekdayTableViewCell_iPad *c = (CVWeekdayTableViewCell_iPad *)cell;
    [c drawEventSquares];
}




#pragma mark - Cell Delegate

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder 
{
    [super weekdayCell:cell wasLongPressedAtDate:datePressed allDay:allDay withPlaceholder:placeholder];
    
    CVQuickAddViewController *quickAddViewController = [[CVQuickAddViewController alloc] init];
    quickAddViewController.delegate = self;
    quickAddViewController.startDate = datePressed;
    quickAddViewController.isAllDay = allDay;
    quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideCenter;
    
    // resize view so that it doesn't have the black space at the bottom
    CGRect f = quickAddViewController.view.frame;
    f.size.height -= IPHONE_KEYBOARD_PORTRAIT_HEIGHT;
    [quickAddViewController.view setFrame:f];
    
    [self presentPopoverModalViewController:quickAddViewController forView:placeholder animated:YES];
    
    [quickAddViewController displayDefault];
}

- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder 
{
    [super weekdayCell:cell wasPressedOnEvent:event withPlaceholder:placeholder];
    
    // put up the edit event modal
    CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:event andMode:CVEventModeDetails];
    eventViewController.delegate = self;
    eventViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideCenter;
    [self presentPopoverModalViewController:eventViewController forView:placeholder animated:YES];
}





#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController *)controller didFinishWithResult:(CVEventResult)result
{
    [super eventViewController:controller didFinishWithResult:result];
    if (result == CVEventResultDeleted || CVEventResultSaved) {
        [self.delegate landscapeWeekViewController:self didFinishWithResult:CVLandscapeWeekViewResultModified];
    }
    [self dismissPopoverModalViewControllerAnimated:NO];
}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController *)controller didCompleteWithAction:(CVQuickAddResult)result
{
    [super quickAddViewController:controller didCompleteWithAction:result];
        
    if (result == CVQuickAddResultMore) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:(EKEvent *)controller.calendarItem andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        [self dismissPopoverModalViewControllerAnimated:YES];
        [self presentPopoverModalViewController:eventViewController forView:controller.popoverTargetView animated:YES];
	}
	else {
		[self dismissPopoverModalViewControllerAnimated:YES];
        [self reloadVisibleRows];
	}
    if (result == CVQuickAddResultSaved) {
        [self.delegate landscapeWeekViewController:self didFinishWithResult:CVLandscapeWeekViewResultModified];
    }
}




#pragma mark - CVJumpToDateViewControllerDelegate Methods

- (void)jumpToDateViewController:(CVJumpToDateViewController *)controller didFinishWithResult:(CVJumpToDateResult)result
{
    [super jumpToDateViewController:controller didFinishWithResult:result];
    
    [self dismissPopoverModalViewControllerAnimated:YES];
    
    if (result == CVJumpToDateResultDateChosen) {
        [self scrollToDate:controller.chosenDate animated:YES];
    }
}


@end
