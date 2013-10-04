//
//  CVRootViewController_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//




#import "CVRootViewController_iPad.h"
#import "CVPopoverModalViewController_iPad.h"
#import "EKCalendarItem+Calvetica.h"


@interface CVRootViewController_iPad ()
@property (nonatomic, weak) IBOutlet UILabel *redBarMonthLabel;
@property (nonatomic, weak) IBOutlet UILabel *redBarYearLabel;
@property (nonatomic, weak) IBOutlet UILabel *grayBarWeekdayLabel;
@property (nonatomic, weak) IBOutlet UILabel *grayBarDateLabel;
@end


@implementation CVRootViewController_iPad

- (void)setSelectedDate:(NSDate *)sd 
{
    // cannot set selected date to nil
    if (!sd) return;
    
    // still need to figure out how to scroll to current hour on first launch
    if (!self.selectedDate) {
        self.rootTableViewController.shouldScrollToCurrentHour = YES;
    }
    // check that the new value is a different value than the current value
    // if it is check that it is today, if it is scroll to current hour
    else if (![self.selectedDate isEqualToDate:sd]) {
        if ([sd mt_isWithinSameDay:[NSDate date]]) {
            // scroll to current hour
            self.rootTableViewController.shouldScrollToCurrentHour = YES;
        }
    }
    self.rootTableViewController.shouldScrollToDate = YES;
    
    // update the ivar
    super.selectedDate = sd;
	
	// update the month table view controller
	self.monthTableViewController.selectedDate = sd;

    // reload table view
    [self loadTableView];
    
    // update all the labels at the top of the screen
    [self setMonthAndDayLabels];
}

- (void)showQuickAddWithDefault:(BOOL)def durationMode:(BOOL)dur date:(NSDate *)date view:(UIView *)view
{
    CVQuickAddViewController_iPhone *quickAddViewController = [[CVQuickAddViewController_iPhone alloc] init];
    quickAddViewController.delegate = self;
    quickAddViewController.startDate = date;
    quickAddViewController.isDurationMode = dur;

	
	// if showing up by the plus button
	if (view == self.redBarPlusButton) {
		quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
		quickAddViewController.popoverArrowDirection = CVPopoverArrowDirectionTopMiddle;
	}
	
	// if pointing to a row in the root table
	else if (def) {
		quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
		quickAddViewController.popoverArrowDirection = CVPopoverArrowDirectionRightTop | CVPopoverArrowDirectionRightMiddle | CVPopoverArrowDirectionRightBottom;
	}
	
	// if pointing at the middle of a day button (because the user long pressed on a day button)
	else {
		quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideCenter;
		quickAddViewController.popoverArrowDirection = CVPopoverArrowDirectionLeftMiddle | CVPopoverArrowDirectionTopMiddle;		
	}

    // resize view so that it doesn't have the black space at the bottom
    CGRect f = quickAddViewController.view.frame;
    f.size.height -= IPHONE_KEYBOARD_PORTRAIT_HEIGHT;
    [quickAddViewController.view setFrame:f];
    
    [self presentPopoverModalViewController:quickAddViewController forView:view animated:YES];
    
    if (def) {
        [quickAddViewController displayDefault];
    }
}

- (void)showSnoozeDialogForEvent:(EKEvent *)snoozeEvent 
{
	[super showSnoozeDialogForEvent:snoozeEvent];
}

- (void)showWeekView 
{
    [self performSegueWithIdentifier:@"WeekViewSegue" sender:self];
}




#pragma mark - Method Helpers

- (void)setMonthAndDayLabels 
{
    _redBarMonthLabel.text = [[self.selectedDate stringWithTitleOfCurrentMonthAbbreviated:NO] lowercaseString];
    _redBarYearLabel.text = [NSString stringWithFormat:@"%d", [self.selectedDate mt_year]];
    _grayBarWeekdayLabel.text = [[self.selectedDate stringWithTitleOfCurrentWeekDayAbbreviated:NO] lowercaseString];
    _grayBarDateLabel.text = [[self.selectedDate stringWithMonthAndDayAbbreviated:YES] uppercaseString];
    
    // shift year label in red bar horizontally
    CGRect f = _redBarYearLabel.frame;
    f.origin.x = _redBarMonthLabel.frame.origin.x + [_redBarMonthLabel sizeOfTextInLabel].width + MONTH_YEAR_TEXT_SPACING;
    [_redBarYearLabel setFrame:f];
    
    // shift date label in gray bar horizontally
    f = _grayBarDateLabel.frame;
    f.origin.x = _grayBarWeekdayLabel.frame.origin.x + [_grayBarWeekdayLabel sizeOfTextInLabel].width + MONTH_YEAR_TEXT_SPACING;
    [_grayBarDateLabel setFrame:f];
}




#pragma mark - View Controller Delegates

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	self.monthTableViewController.selectedDayView.hidden = YES;
	for (CVPopoverModalViewController_iPad *controller in self.popoverModalViewControllers) {
		controller.view.hidden = YES;
	}
}

- (void)orientationDidChange:(NSNotification *)notification
{
	if (self.view.window) return;
	[self layoutMonthTableView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self layoutMonthTableView];
}

- (void)layoutMonthTableView
{
	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

    if (deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.monthTableViewController.tableView.rowHeight = IPAD_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
    }
    else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft || deviceOrientation == UIInterfaceOrientationLandscapeRight) {
		self.monthTableViewController.tableView.rowHeight = IPAD_MONTH_VIEW_ROW_HEIGHT_LANDSCAPE;
    }

	NSInteger midRow = [self.monthTableViewController rowInMiddleOfVisibleRegion];
    [self.monthTableViewController.tableView reloadData];
    [self.monthTableViewController scrollToRow:midRow animated:NO];
    self.monthTableViewController.selectedDate = self.selectedDate;
    [self.monthTableViewController drawDotsForVisibleRows];

    [self setWeekDayTitles];

	for (CVPopoverModalViewController_iPad *popoverController in self.popoverModalViewControllers) {
		popoverController.view.hidden = NO;
		[popoverController layout];
	}
	self.monthTableViewController.selectedDayView.hidden = NO;
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    UISwipeGestureRecognizer *slideInLandscapeWeekGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerSwipeOnMonthView:)];
    slideInLandscapeWeekGesture.numberOfTouchesRequired = 3;
    slideInLandscapeWeekGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.monthTableViewController.tableView addGestureRecognizer:slideInLandscapeWeekGesture];

	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:)	name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated 
{
    [self.monthTableViewController viewDidAppear:animated];
    [super viewDidAppear:animated];
    
    [self setWeekDayTitles];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WeekViewSegue"]) {
        CVLandscapeWeekView_iPad *landscapeWeekView = [segue destinationViewController];
        landscapeWeekView.delegate                  = self;
        landscapeWeekView.startDate                 = [NSDate date];
    }
    [super prepareForSegue:segue sender:sender];
}




#pragma mark - Actions

- (IBAction)handleLongPressOnPlusButtonGesture:(UILongPressGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
    [super handleLongPressOnPlusButtonGesture:gesture];
    
    CVGenericReminderViewController_iPhone *genericReminderViewController = [[CVGenericReminderViewController_iPhone alloc] init];
    genericReminderViewController.delegate = self;
    
    // resize view so that it doesn't have the black space at the bottom
    CGRect f = genericReminderViewController.view.frame;
    f.size.height -= IPHONE_KEYBOARD_PORTRAIT_HEIGHT;
    [genericReminderViewController.view setFrame:f];
    
    [self presentPopoverModalViewController:genericReminderViewController forView:self.redBarPlusButton animated:YES];
}

- (IBAction)handleLongPressOnMonthTitleGesture:(UILongPressGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
    
	NSDate *chosenDate = [[NSDate date] mt_startOfCurrentDay];
	self.monthTableViewController.startDate = [[chosenDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
    
	[super handleLongPressOnMonthTitleGesture:gesture];

	[self.monthTableViewController scrollToRowForDate:chosenDate animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)handleThreeFingerSwipeOnMonthView:(UISwipeGestureRecognizer *)gesture 
{
    [self showWeekView];
}

- (IBAction)showViewOptionsButtonWasTapped:(id)sender 
{
	[super showViewOptionsButtonWasTapped:sender];
	CVViewOptionsPopoverViewController *viewOptionsPopover = [[CVViewOptionsPopoverViewController alloc] init];
    viewOptionsPopover.delegate = self;
    viewOptionsPopover.currentViewMode = (CVViewOptionsPopoverOption)self.tableMode;
    viewOptionsPopover.popoverBackdropColor = patentedDarkGray;
    viewOptionsPopover.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
    [self presentPopoverModalViewController:viewOptionsPopover forView:sender animated:YES];
}

- (IBAction)redBarPlusButtonWasTapped:(UITapGestureRecognizer *)gesture 
{
    [super redBarPlusButtonWasTapped:gesture];
	[self showQuickAddWithDefault:NO
					 durationMode:NO
							 date:self.selectedDate
							 view:gesture.view];
}

- (IBAction)monthLabelWasTapped:(UITapGestureRecognizer *)gesture 
{
    CVEventDayViewController_iPhone *eventDayViewController = [[CVEventDayViewController_iPhone alloc] init];
    eventDayViewController.initialDate = self.selectedDate;
    CVJumpToDateViewController_iPhone *jumpToDateController = [[CVJumpToDateViewController_iPhone alloc] initWithContentViewController:eventDayViewController];
    jumpToDateController.delegate = self;
    jumpToDateController.popoverArrowDirection = CVPopoverArrowDirectionTopLeft;
	jumpToDateController.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
    [self presentPopoverModalViewController:jumpToDateController forView:gesture.view animated:YES];
    
}

- (IBAction)handleSwipeOnTableView:(UISwipeGestureRecognizer *)gesture 
{
    if (self.tableMode == CVRootTableViewModeWeek) {
        [super handleSwipeOnTableView:gesture];
    }
}

- (IBAction)dayButtonWasSwiped:(UISwipeGestureRecognizer *)gesture 
{
}

- (IBAction)dayViewHeaderTapped:(id)sender 
{
	[self.monthTableViewController scrollToSelectedDay];
}

- (IBAction)weekViewButtonWasTapped:(id)sender 
{
    [self showWeekView];
}





#pragma mark - Table view cell delegate

- (void)cellHourTimeWasTapped:(CVEventCell *)cell 
{
    if (cell.event) {
        CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:cell.event andMode:CVEventModeHour];
        eventViewController.delegate = self;
        eventViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        eventViewController.popoverArrowDirection = CVPopoverArrowDirectionRightTop | CVPopoverArrowDirectionRightMiddle | CVPopoverArrowDirectionRightBottom;
        [self presentPopoverModalViewController:eventViewController forView:cell animated:YES];
    }
    else {
        [super cellHourTimeWasTapped:cell];
    }
}

- (void)cellWasTapped:(id)tappedCell 
{
    CVEventCell *cell = (CVEventCell *)tappedCell;
    if (cell.event) {
        CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:cell.event andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        eventViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        eventViewController.popoverArrowDirection = CVPopoverArrowDirectionRightTop | CVPopoverArrowDirectionRightMiddle | CVPopoverArrowDirectionRightBottom;
        [self presentPopoverModalViewController:eventViewController forView:cell animated:YES];
    } else {
        [self showQuickAddWithDefault:YES
                         durationMode:YES
                                 date:cell.date
                                 view:cell];
    }
    [super cellWasTapped:tappedCell];
}

- (void)searchController:(CVSearchViewController_iPhone *)controller cellWasTapped:(CVEventCell *)tappedCell
{
    CVEventCell *cell = (CVEventCell *)tappedCell;
    CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:cell.event andMode:CVEventModeDetails];
    eventViewController.delegate = self;
    [self presentPopoverModalViewController:eventViewController forView:controller.popoverTargetView animated:YES];

    [super cellWasTapped:tappedCell];
}

- (void)cell:(CVEventCell *)cell wasSwipedInDirection:(CVEventCellSwipedDirection)direction 
{
	[super cell:cell wasSwipedInDirection:direction];
}

- (void)cell:(CVCell *)cell alarmButtonWasTappedForCalendarItem:(EKCalendarItem *)calendarItem
{
	[super cell:cell alarmButtonWasTappedForCalendarItem:calendarItem];
}

- (void)cellEventWasDeleted:(CVEventCell *)cell 
{
    [super cellEventWasDeleted:cell];
	
	// find the cell of the event that was deleted.  If it was not on an even hour its agenda mode, delete the cell.
    NSIndexPath *indexPath = [self.rootTableView indexPathForRowContainingView:cell];
    CVEventCellDataHolder *holder = (CVEventCellDataHolder *)[self.rootTableViewController cellDataHolderAtIndexPath:indexPath];
    
	if (holder) {
		
		EKEvent *eventToDelete = holder.event;
		
		[holder.event removeThenDoActionBlock:^(void) {
			holder.event = nil;
			holder.isAllDay = NO;
			
			if (![holder.date mt_isStartOfAnHour] || self.tableMode != CVRootTableViewModeFull) {
				[self.rootTableViewController removeObjectAtIndexPath:indexPath];
                [self.rootTableView beginUpdates];
				[self.rootTableView deleteRowsAtIndexPaths:@[[self.rootTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
                [self.rootTableView endUpdates];
			}
			else {
				[self.rootTableView reloadRowsAtIndexPaths:@[[self.rootTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
			}

			// if it repeats we need to reload all the rows in ase dots for this week appear on other weeks
			if (eventToDelete.hasRecurrenceRules || ![eventToDelete fitsWithinWeekOfDate:self.selectedDate]) {
				[self.monthTableViewController drawDotsForVisibleRows];
			} else {
				[self.monthTableViewController reloadRowForDate:self.selectedDate];
			}
		} cancelBlock:^(void) {}];
    }
}










#pragma mark - CVWeekTableViewCellDelegate

- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasPressedOnDate:(NSDate *)date 
{
    [super weekTableViewCell:cell wasPressedOnDate:date];
}

- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasLongPressedOnDate:(NSDate *)date withPlaceholder:(UIView *)placeholder 
{
	[super weekTableViewCell:cell wasLongPressedOnDate:date withPlaceholder:placeholder];
	
	// in order to make this smooth, it needs to run at the end of the calvetica queue
	dispatch_async([CVOperationQueue backgroundQueue], ^(void) {
		dispatch_async(dispatch_get_main_queue(), ^(void) {

			[self showQuickAddWithDefault:NO
							 durationMode:NO
									 date:date
									 view:placeholder];

            [placeholder removeFromSuperview];
        });
	});  
}




#pragma mark - Manage calendars view controller delegate

- (void)manageCalendarsViewController:(CVManageCalendarsViewController_iPhone *)controller didFinishWithResult:(CVManageCalendarsResult)result
{
    [super manageCalendarsViewController:controller didFinishWithResult:result];
    if (result == CVManageCalendarsResultModified) {
        [self.monthTableViewController drawDotsForVisibleRows];
        [self.rootTableViewController loadTableView];
    }
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)result
{
    [super quickAddViewController:controller didCompleteWithAction:result];
	

    if (result == CVQuickAddResultSaved) {
        [self redrawRowsForEvent:(EKEvent *)controller.calendarItem];
		[self dismissPopoverModalViewControllerAnimated:YES];
    }
	else if (result == CVQuickAddResultMore) {
        CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:(EKEvent *)controller.calendarItem andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        [self dismissPopoverModalViewControllerAnimated:YES];
        [self presentPopoverModalViewController:eventViewController forView:controller.popoverTargetView animated:YES];
	}
	else if (result == CVQuickAddResultCancelled) {
		[self dismissPopoverModalViewControllerAnimated:YES];
	}
}




#pragma mark - Jump to date view controller delegate

- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller didFinishWithResult:(CVJumpToDateResult)result
{    
	[super jumpToDateViewController:controller didFinishWithResult:result];
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController_iPhone *)controller didFinishWithResult:(CVEventResult)result
{
    [super eventViewController:controller didFinishWithResult:result];
    if (result == CVEventResultSaved) {
		// if they moved it to a different day, that could be any day.
		[self.monthTableViewController drawDotsForVisibleRows];
    }
    else if (result == CVEventResultDeleted) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
    [self dismissPopoverModalViewControllerAnimated:YES];
}





#pragma mark - Alarm Picker Delegates

- (void)alarmPicker:(CVAlarmPickerViewController *)picker didFinishWithResult:(CVAlarmPickerResult)result 
{
    [super alarmPicker:picker didFinishWithResult:result];
}




#pragma mark - Event Snooze View Controller Delegate

- (void)eventSnoozeViewController:(CVEventSnoozeViewController_iPhone *)controller didFinishWithResult:(CVEventSnoozeResult)result
{
    [super eventSnoozeViewController:controller didFinishWithResult:result];
    
    [self dismissFullScreenModalViewControllerAnimated:YES];

	if (result == CVEventSnoozeResultShowDetails) {
        CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:controller.event andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        [self presentPopoverModalViewController:eventViewController forView:self.redBarPlusButton animated:YES];
        [self.monthTableViewController scrollToRowForDate:controller.event.startingDate animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}




#pragma mark - Sub Hour Picker Delegate

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didPickDate:(NSDate *)date 
{
    [super subHourPicker:subHourPicker didPickDate:date];
    [self showQuickAddWithDefault:YES
					 durationMode:YES
							 date:date
							 view:self.redBarPlusButton];
}

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didFinishWithResult:(CVSubHourPickerViewControllerResult)result 
{
    [super subHourPicker:subHourPicker didFinishWithResult:result];
}




#pragma mark - CVSearchViewControllerDelegate

- (void)searchViewController:(CVSearchViewController_iPhone *)searchViewController didFinishWithResult:(CVSearchViewControllerResult)result
{
    [super searchViewController:searchViewController didFinishWithResult:result];
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - CVGenericReminderViewControllerDelegate

- (void)genericReminderViewController:(CVGenericReminderViewController_iPhone *)controller didFinishWithResult:(CVGenericReminderViewControllerResult)result
{
    [super genericReminderViewController:controller didFinishWithResult:result];
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - RootTableViewControllerProtocol Methods

- (void)tableViewDidScrollToDay:(NSDate *)day 
{
	[super tableViewDidScrollToDay:day];
	super.selectedDate = day;
    
    // reframe red square
    self.monthTableViewController.selectedDate = day;
}




#pragma mark - CVWelcomeViewControllerDelegate

- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result 
{
	[super welcomeController:controller didFinishWithResult:result];

	if (result == CVWelcomeViewControllerResultFAQ || result == CVWelcomeViewControllerResultDontShowMe || result == CVWelcomeViewControllerResultCancel) {
		[self dismissPageModalViewControllerAnimated:YES completion:nil];
	}
}




#pragma mark - CVFAQViewControllerDelegate

- (void)faqControllerDidFinish:(CVFAQViewController *)controller 
{
	[self dismissPopoverModalViewControllerAnimated:YES];	
}




#pragma mark - CVGestureHowToViewControllerDelegate

- (void)gestureControllerDidFinish:(CVGestureHowToViewController *)controller 
{
	[self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - CVLandscapeWeekViewDelegate

- (void)landscapeWeekViewController:(CVLandscapeWeekView *)controller didFinishWithResult:(CVLandscapeWeekViewResult)result 
{
    [super landscapeWeekViewController:controller didFinishWithResult:result];
	[self.monthTableViewController drawDotsForVisibleRows];
    if (result != CVLandscapeWeekViewResultModified) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}




@end
