//
//  CVRootViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootViewController_iPhone.h"
#import "EKCalendar+Utilities.h"
#import "CVLandscapeWeekView_iPhone.h"
#import "geometry.h"
#import "EKCalendarItem+Calvetica.h"




@interface CVRootViewController_iPhone ()
@property (nonatomic, strong) IBOutlet UIView *redBar;
@property (nonatomic, strong) IBOutlet UIView *rootViewWrapper;
@property (nonatomic, assign) NSInteger monthOnMainThread;
@property (nonatomic, assign) CVRootMonthViewAnimateDirection monthViewPushedUpDirection;
@end




@implementation CVRootViewController_iPhone

- (void)setSelectedDate:(NSDate *)sd 
{
    // cannot set selected date to nil
    if (!sd) return;
    
    BOOL withinSameMonth = [sd isWithinSameMonth:self.selectedDate];
    
    // set the isInitialLoad so that when the rootTableView is built it can 
    // call the method scrollToCurrentHour
    if (!self.selectedDate) {
        self.rootTableViewController.shouldScrollToCurrentHour = YES;
    }
    
    // check that the new value is a different value than the current value
    // if it is check that it is today, if it is scroll to current hour
    else if (![self.selectedDate isEqualToDate:sd]) {
        if ([sd isWithinSameDay:[NSDate date]]) {
            // scroll to current hour
            self.rootTableViewController.shouldScrollToCurrentHour = YES;
        }
    }
    self.rootTableViewController.shouldScrollToDate = YES;

    // update the ivar
    super.selectedDate = sd;
	
	// update the month table view controller
	self.monthTableViewController.selectedDate = sd;
    if (self.monthViewPushedUpDirection == CVRootMonthViewAnimateDirectionUp) {
        [self.monthTableViewController scrollToRowForDate:sd animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    else {
        [self.monthTableViewController scrollToRowForDate:[sd startOfCurrentMonth] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    // reload table view
    [self loadTableView];
    
    // update the month view if this is a new month
    if (!withinSameMonth) {
                    
        // update month label
        NSInteger numberOfRows = [self.selectedDate numberOfCalendarRowsInCurrentMonth];
        NSString *titleOfCurrentMonthAbbreviated = (numberOfRows != 4 ? [sd stringWithTitleOfCurrentMonthAndYearAbbreviated:YES] : [sd stringWithTitleOfCurrentMonthAbbreviated:YES]);
        self.monthLabelControl.titleLabel.text = [titleOfCurrentMonthAbbreviated uppercaseString];

        if (self.monthViewPushedUpDirection == CVRootMonthViewAnimateDirectionDown)
            [self updateLayout];
    }
}

- (void)showQuickAddWithDefault:(BOOL)def durationMode:(BOOL)dur date:(NSDate *)date mode:(CVQuickAddMode)mode
{
    CVQuickAddViewController_iPhone *quickAddViewController = [[CVQuickAddViewController_iPhone alloc] init];
    quickAddViewController.delegate = self;
    quickAddViewController.startDate = date;
	quickAddViewController.mode = mode;
    quickAddViewController.isDurationMode = dur;
    [self presentFullScreenModalViewController:quickAddViewController animated:YES];
    if (def) {
        [quickAddViewController displayDefault];
    }
}

- (void)showSnoozeDialogForEvent:(EKEvent *)snoozeEvent 
{
	[super showSnoozeDialogForEvent:snoozeEvent];
}

- (void)animateMonthViewDirection:(CVRootMonthViewAnimateDirection)direction 
{
	
	self.monthViewPushedUpDirection = direction;
	
	NSInteger numberOfRows = [self.selectedDate numberOfCalendarRowsInCurrentMonth];
	NSInteger rowsToHide = numberOfRows - 2;
    
    CGFloat h = 40.0f;
    
	CGFloat screenHeight = self.view.bounds.size.height;
	CGFloat pushedUpY = -((h * rowsToHide) + self.weekdayTitleBar.frame.size.height);
	CGFloat pushedUpHeight = screenHeight + CVABS(pushedUpY);
	CGFloat pushedDownY = 0;
	CGFloat pushedDownHeight = screenHeight;
	
	[UIView animateWithDuration:ANIMATION_SPEED animations:^(void) {
		
		CGRect f = self.rootViewWrapper.frame;
        CGRect r = self.monthTableView.frame;
		
		if (direction == CVRootMonthViewAnimateDirectionDown) {
			f.origin.y = pushedDownY;
			f.size.height = pushedDownHeight;
            
            r.origin.y = self.weekdayTitleBar.frame.size.height;
            r.size.height = numberOfRows * h;
		}
		else {
			f.origin.y = pushedUpY;
			f.size.height = pushedUpHeight;
            
            r.origin.y = self.weekdayTitleBar.frame.size.height + (rowsToHide * h);
            r.size.height = 2 * h;
		}
        
		[self.rootViewWrapper setFrame:f];
        [self.monthTableView setFrame:r];
		
	}
                     completion:^(BOOL finished) {
                         [self.monthTableViewController reframeRedSelectedDaySquare];
                     }];
}

- (void)updateLayout 
{
    // runs on thread
    
    // adjust layout
    NSInteger numberOfRows = [self.selectedDate numberOfCalendarRowsInCurrentMonth];
    CGFloat h = 40.0f;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect r;
        
        // stretch day button container
        r = self.monthTableView.frame;
        r.size.height = numberOfRows * h;
        [self.monthTableView setFrame:r];
        
        // self.redBarImageView red bar
        r = _redBar.frame;
        r.size.height = (numberOfRows * h) + self.weekdayTitleBar.bounds.size.height;
        [self.redBar setFrame:r];
        
        CGRect redBarImageFrame = CGRectMake(self.redBarImageView.bounds.origin.x, self.redBarImageView.bounds.origin.y, r.size.width, r.size.height);
        [self.redBarImageView setFrame:redBarImageFrame];
        
        // adjust table view
        r = self.rootTableView.frame;
        r.origin.y = ((numberOfRows * h) + self.weekdayTitleBar.bounds.size.height);        
        r.size.height = _rootViewWrapper.frame.size.height - r.origin.y;
        [self.rootTableView setFrame:r];
        
        // adjust vignette background
        r = self.vignetteBackground.frame;
        r.origin.y = ((numberOfRows * h) + self.weekdayTitleBar.bounds.size.height);
        [self.vignetteBackground setFrame:r];
        
    }
                     completion:^(BOOL finished) {
                         [self.monthTableViewController reframeRedSelectedDaySquare];
                         [self animateMonthViewDirection:self.monthViewPushedUpDirection];
                     }];
	
}



#pragma mark - View Controller Delegates

- (void)orientationChanged:(NSNotification *)notification 
{
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if (deviceOrientation == UIInterfaceOrientationPortrait || deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        // if the landscape week view isn't even up, don't dismiss it, just return
        if (![self.presentedViewController isKindOfClass:[CVLandscapeWeekView_iPhone class]]) {
            return;
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft || deviceOrientation == UIInterfaceOrientationLandscapeRight) {
        
        // if a modal view controller is already being displayed, return
        if (self.presentedViewController) return;
        
        CVLandscapeWeekView_iPhone *landscapeViewController = [[CVLandscapeWeekView_iPhone alloc] init];
        landscapeViewController.delegate = self;
        landscapeViewController.startDate = [NSDate date];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self presentViewController:landscapeViewController animated:YES completion:nil];
    }
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    
    // rotate month button
    CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90.0f));
    self.monthLabelControl.transform = rotateTransform;
    
    // if the view is not scrollable, lock it
    if (![CVSettings scrollableMonthView]) {
        self.monthTableView.scrollEnabled = NO;
    }
    
    // swipe gesture should shift to the next month
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(monthTableViewWasSwiped:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.monthTableView addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(monthTableViewWasSwiped:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.rootViewWrapper addGestureRecognizer:swipeDownGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(monthTableViewWasSwiped:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.monthTableView addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(monthTableViewWasSwiped:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.rootViewWrapper addGestureRecognizer:swipeUpGesture];
    
    // register to know when the phone is turned sideways
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidLoad]; 
}

- (void)viewDidUnload
{
    [self setMonthLabelControl:nil];
    [self setWeekdayTitleBar:nil];
    [self setRedBar:nil];
	[self setRootViewWrapper:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [self setWeekDayTitles];
	self.selectedDate = self.selectedDate;
	[self updateLayout];
}




#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer 
{
    // We allow taps and long presses to occur at the same time. This lets us select a day when the user is long pressing on a day.
    if ([gestureRecognizer isKindOfClass:[CVTapGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}




#pragma mark - Actions

- (IBAction)handleLongPressOnPlusButtonGesture:(UILongPressGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
    [super handleLongPressOnPlusButtonGesture:gesture];
    CVGenericReminderViewController_iPhone *genericReminderViewController = [[CVGenericReminderViewController_iPhone alloc] init];
    genericReminderViewController.delegate = self;
    [self presentFullScreenModalViewController:genericReminderViewController animated:YES];
}

- (IBAction)handleLongPressOnMonthTitleGesture:(UILongPressGestureRecognizer *)gesture 
{
	[super handleLongPressOnMonthTitleGesture:gesture];
	
	
}

- (IBAction)showViewOptionsButtonWasTapped:(id)sender 
{
	[super showViewOptionsButtonWasTapped:sender];
	CVViewOptionsPopoverViewController *viewOptionsPopover = [[CVViewOptionsPopoverViewController alloc] init];
    viewOptionsPopover.delegate = self;
    viewOptionsPopover.currentViewMode = (CVViewOptionsPopoverOption)self.tableMode;
    viewOptionsPopover.mode = (CVViewOptionsMode)self.mode;
    viewOptionsPopover.popoverBackdropColor = patentedDarkGray;
    viewOptionsPopover.attachPopoverArrowToSide = CVPopoverModalAttachToSideRight;
    [self presentPopoverModalViewController:viewOptionsPopover forView:sender animated:YES];
}

- (IBAction)redBarPlusButtonWasTapped:(UITapGestureRecognizer *)gesture 
{
    [super redBarPlusButtonWasTapped:gesture];
	[self showQuickAddWithDefault:NO
					 durationMode:NO
							 date:self.selectedDate
							 mode:(self.mode == CVRootViewControllerModeEvents ? CVQuickAddModeEvent : CVQuickAddModeReminder)];
}

- (IBAction)toggleRemindersEventsViewIconTapped:(id)sender 
{
    [super toggleRemindersEventsViewIconTapped:sender];
}

- (IBAction)monthLabelWasTapped:(UITapGestureRecognizer *)gesture 
{
    CVEventDayViewController_iPhone *eventDayViewController = [[CVEventDayViewController_iPhone alloc] init];
    eventDayViewController.initialDate = self.selectedDate;
    CVJumpToDateViewController_iPhone *jumpToDateController = [[CVJumpToDateViewController_iPhone alloc] initWithContentViewController:eventDayViewController];
    jumpToDateController.delegate = self;
    [self presentPageModalViewController:jumpToDateController animated:YES];
}

- (IBAction)monthTableViewWasSwiped:(UISwipeGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateEnded) return;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSDate *date = [self.selectedDate oneMonthNext];        
        [UIApplication showBezelWithTitle:[date stringWithTitleOfCurrentMonthAbbreviated:NO]];
        self.selectedDate = date;
    } 
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        NSDate *date = [self.selectedDate oneMonthPrevious];
        [UIApplication showBezelWithTitle:[date stringWithTitleOfCurrentMonthAbbreviated:NO]];
        self.selectedDate = date;
    }
	
	
	else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
		[self animateMonthViewDirection:CVRootMonthViewAnimateDirectionUp];
	}
	else if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
		[self animateMonthViewDirection:CVRootMonthViewAnimateDirectionDown];
	}
}




#pragma mark - Notifications

- (void)eventStoreChanged 
{
    [super eventStoreChanged];
}

- (void)reminderStoreChanged 
{
    [super reminderStoreChanged];
}

- (void)pocketLintSyncDidFinish 
{
	if (self.mode == CVRootViewControllerModeEvents) return;
	[super pocketLintSyncDidFinish];
    [self.monthTableViewController drawDotsForVisibleRows];
}




#pragma mark - Table view cell delegate

- (void)cellHourTimeWasTapped:(CVEventCell *)cell 
{
    if (cell.event) {
		CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:cell.event andMode:CVEventModeHour];
		eventViewController.delegate = self;
		[self presentPageModalViewController:eventViewController animated:YES];
    }
    else {
        [super cellHourTimeWasTapped:cell];
    }
}

- (void)cellWasTapped:(id)tappedCell 
{
    if (self.mode == CVRootViewControllerModeEvents) {
        CVEventCell *cell = (CVEventCell *)tappedCell;
        if (cell.event) {
            CVEventViewController_iPhone *eventViewController = [[CVEventViewController_iPhone alloc] initWithEvent:cell.event andMode:CVEventModeDetails];
            eventViewController.delegate = self;
            [self presentPageModalViewController:eventViewController animated:YES];
        } else {
            [self showQuickAddWithDefault:YES
							 durationMode:YES
									 date:cell.date
									 mode:(self.mode == CVRootViewControllerModeEvents ? CVQuickAddModeEvent : CVQuickAddModeReminder)];
        }
    }
    else if (self.mode == CVRootViewControllerModeReminders) {
        CVReminderCell *cell = (CVReminderCell *)tappedCell;
        CVReminderViewController_iPhone *reminderViewController = [[CVReminderViewController_iPhone alloc] initWithReminder:cell.reminder andMode:CVReminderViewControllerModeDetails];
        reminderViewController.delegate = self;
        [self presentPageModalViewController:reminderViewController animated:YES];
    }
    
    [super cellWasTapped:tappedCell];
}

- (void)cellWasLongPressed:(id)tappedCell 
{
	if (![tappedCell isKindOfClass:[CVEventCell class]]) return;
	
    if (self.mode == CVRootViewControllerModeEvents) {
        CVEventCell *cell = (CVEventCell *)tappedCell;
		[self showQuickAddWithDefault:YES
						 durationMode:YES
								 date:cell.date
								 mode:(self.mode == CVRootViewControllerModeEvents ? CVQuickAddModeEvent : CVQuickAddModeReminder)];
    }
    else if (self.mode == CVRootViewControllerModeReminders) {
        CVReminderCell *cell = (CVReminderCell *)tappedCell;
        CVReminderViewController_iPhone *reminderViewController = [[CVReminderViewController_iPhone alloc] initWithReminder:cell.reminder andMode:CVReminderViewControllerModeDay];
        reminderViewController.delegate = self;
        [self presentPageModalViewController:reminderViewController animated:YES];
    }
    
    [super cellWasTapped:tappedCell];
}

- (void)searchController:(CVSearchViewController_iPhone *)controller cellWasTapped:(CVEventCell *)cell
{
	[self cellWasTapped:cell];	
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
		
		[holder.event removeThenDoActionBlock:^(void) {
			holder.event = nil;
			holder.isAllDay = NO;
			
			if (![holder.date isStartOfAnHour] || self.tableMode != CVRootTableViewModeFull) {
				[self.rootTableViewController removeObjectAtIndexPath:indexPath];
				[self.rootTableView deleteRowsAtIndexPaths:@[[self.rootTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationMiddle];
			}
			else {
				[self.rootTableView reloadRowsAtIndexPaths:@[[self.rootTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
			}
            [self.monthTableViewController drawDotsForVisibleRows];
		} cancelBlock:^(void) {}];
    }
	
}

- (void)cellReminderWasDeleted:(CVReminderCell *)cell 
{
    [super cellReminderWasDeleted:cell];
    [self.monthTableViewController drawDotsForVisibleRows];
}

- (void)cellReminderWasCompleted:(CVReminderCell *)cell 
{
    [super cellReminderWasCompleted:cell];
    [self.monthTableViewController drawDotsForVisibleRows];
}

- (void)cellReminderWasUncompleted:(CVReminderCell *)cell 
{
    [super cellReminderWasUncompleted:cell];
    [self.monthTableViewController drawDotsForVisibleRows];
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
									 mode:(self.mode == CVRootViewControllerModeEvents ? CVQuickAddModeEvent : CVQuickAddModeReminder)];

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
    [self dismissPageModalViewControllerAnimated:YES];
}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)result
{
    [super quickAddViewController:controller didCompleteWithAction:result];
    
	[self dismissFullScreenModalViewControllerAnimated:YES];
	
    if (result == CVQuickAddResultSaved) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
	else if (result == CVQuickAddResultMore) {
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
}




#pragma mark - Jump to date view controller delegate

- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller didFinishWithResult:(CVJumpToDateResult)result
{
    [super jumpToDateViewController:controller didFinishWithResult:result];
    [self dismissPageModalViewControllerAnimated:YES];
}




#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController_iPhone *)controller didFinishWithResult:(CVEventResult)result
{
    [super eventViewController:controller didFinishWithResult:result];
    if (result == CVEventResultSaved) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
    else if (result == CVEventResultDeleted) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
    [self dismissPageModalViewControllerAnimated:YES];
}




#pragma mark - Reminder view controller delegate

- (void)reminderViewController:(CVReminderViewController_iPhone *)controller didFinishWithResult:(CVReminderViewControllerResult)result
{
    [super reminderViewController:controller didFinishWithResult:result];
    if (result == CVReminderViewControllerResultSaved) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
    else if (result == CVReminderViewControllerResultDeleted) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
    [self dismissPageModalViewControllerAnimated:YES];
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
        [self presentPageModalViewController:eventViewController animated:YES];
    }
}



#pragma mark - Sub Hour Picker Delegate

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didPickDate:(NSDate *)date 
{
    [super subHourPicker:subHourPicker didPickDate:date];
    [self showQuickAddWithDefault:YES
					 durationMode:YES
							 date:date
							 mode:(self.mode == CVRootViewControllerModeEvents ? CVQuickAddModeEvent : CVQuickAddModeReminder)];
}

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didFinishWithResult:(CVSubHourPickerViewControllerResult)result 
{
    [super subHourPicker:subHourPicker didFinishWithResult:result];
}




#pragma mark - CVSearchViewControllerDelegate

- (void)searchViewController:(CVSearchViewController_iPhone *)searchViewController didFinishWithResult:(CVSearchViewControllerResult)result
{
    [super searchViewController:searchViewController didFinishWithResult:result];
    [self dismissFullScreenModalViewControllerAnimated:YES];
}




#pragma mark - CVGenericReminderViewControllerDelegate

- (void)genericReminderViewController:(CVGenericReminderViewController_iPhone *)controller didFinishWithResult:(CVGenericReminderViewControllerResult)result
{
    [super genericReminderViewController:controller didFinishWithResult:result];
    [self dismissFullScreenModalViewControllerAnimated:YES];
}




#pragma mark - RootTableViewControllerProtocol Methods

- (void)tableViewDidScrollToDay:(NSDate *)day 
{
	if ([day isEqualToDate:self.selectedDate]) return;
	
	[super tableViewDidScrollToDay:day];
	if (![self.selectedDate isWithinSameMonth:day]) {
		self.selectedDate = day;	
	}
	else {
		super.selectedDate = day;
//		[self highlightSelectedDay];
	}
}




#pragma mark - CVWelcomeViewControllerDelegate

- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result 
{
	[super welcomeController:controller didFinishWithResult:result];
	if (result == CVWelcomeViewControllerResultCancel || result == CVWelcomeViewControllerResultDontShowMe) {
		[self dismissPageModalViewControllerAnimated:YES];
	}
}

- (void)doneViewingHelp 
{
	[self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - CVLandscapeWeekViewDelegate

- (void)landscapeWeekViewController:(CVLandscapeWeekView *)controller didFinishWithResult:(CVLandscapeWeekViewResult)result 
{
    [super landscapeWeekViewController:controller didFinishWithResult:result];
    if (result == CVLandscapeWeekViewResultModified) {
        [self.monthTableViewController drawDotsForVisibleRows];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end


