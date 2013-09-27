//
//  CVRootViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootViewController.h"
#import "UITableView+Utilities.h"
#import "UIApplication+Utilities.h"
#import "CVSubHourPickerViewController.h"
#import "CVEventsFullDayTableViewController.h"
#import "CVEventsAgendaTableViewController.h"
#import "CVEventsWeekAgendaTableViewController.h"
#import "CVEventsWeekStdAgendaTableViewController.h"
#import "CVRemindersWeekStdAgendaTableViewController.h"
#import "CVRemindersTableViewController.h"
#import "CVRemindersWeekAgendaTableViewController.h"
#import "CVEventSnoozeViewController_iPhone.h"
#import "EKReminder+Calvetica.h"
#import "geometry.h"
#import "EKCalendarItem+Calvetica.h"




@implementation CVRootViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

    self.view.window.tintColor = patentedRed;

    // @hack: from a google search, it looks like a bug in xcode 4 that viewDidLoad gets called
    // twice on the root view controller for some reason.  This is a temporary hack.
    if (self.monthTableViewController.delegate) return;

    self.monthTableViewController.delegate = self;

    // register to know when the event store changes.  When it does, we need to update calvetica alerts if that preferences is enabled.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged) name:EKEventStoreChangedNotification object:nil];

    // set up the pinch gesture on the table view
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self  action:@selector(handleEventTableViewPinchGesture:)];
    [self.rootTableView addGestureRecognizer:pinchGesture];

    // set up swipe gesture on the table view
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnTableView:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.rootTableView addGestureRecognizer:swipeLeftGesture];

    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnTableView:)];
    [self.rootTableView addGestureRecognizer:swipeRightGesture];

    // set up tap gesture on red plus button
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(redBarPlusButtonWasTapped:)];
    [self.redBarPlusButton addGestureRecognizer:tapGesture];

    // set up long press button on the quick add
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(handleLongPressOnPlusButtonGesture:)];
    [self.redBarPlusButton addGestureRecognizer:longPressGesture];

    // set up tap gesture on red plus button
    UITapGestureRecognizer *monthTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(monthLabelWasTapped:)];
    [self.monthLabelControl addGestureRecognizer:monthTapGesture];

    // set up long press button on the quick add
    UILongPressGestureRecognizer *monthLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(handleLongPressOnMonthTitleGesture:)];
    [self.monthLabelControl addGestureRecognizer:monthLongPressGesture];


    // set the mode based on the saved state from previous use
    self.mode = [CVSettings isReminderView] ? CVRootViewControllerModeReminders : CVRootViewControllerModeEvents;
    if (self.mode == CVRootViewControllerModeEvents) {
        self.tableMode = [CVSettings eventRootTableMode];
    }
    else if (self.mode == CVRootViewControllerModeReminders) {
        self.tableMode = [CVSettings reminderRootTableMode];
    }

    // set day
    self.selectedDate = [[NSDate date] mt_startOfCurrentDay];

    // set todays day, used for reference when coming out of background
    self.todaysDate = [NSDate date];

    // NO UPDATE SCREEN THIS TIME
    // if this is the first time they've ever opened the app, or if the welcome screen
    // was updated, show them the welcome screen
//    if (![CVSettings welcomeScreenHasBeenShown]) {
//        CVWelcomeViewController *welcomeController = [[CVWelcomeViewController alloc] init];
//        welcomeController.delegate = self;
//        [self presentPageModalViewController:welcomeController animated:YES completion:nil];
//    }

    [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        [[CVEventStore sharedStore].eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                [MTq main:^{
                    [self notifyOfNeededPermission];
                }];
            }
            [[CVEventStore sharedStore].eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                [MTq main:^{
                    [CVEventStore reset];
                    [self updateRootTableView];
                    [self redrawDotsOnMonthView];
                }];
            }];
        }];
    } repeats:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];

	self.monthTableViewController.startDate = [[self.selectedDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
	self.monthTableViewController.selectedDate = self.selectedDate;
	[self.monthTableViewController scrollToRowForDate:[self.selectedDate mt_startOfCurrentWeek] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
	[self.monthTableViewController reframeRedSelectedDaySquareAnimated:NO];

	[self.rootTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    // if this gets dealloced and we don't remove it as an observer, when the event
    // db changes, we'll get a segfault.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

// for shake gesture
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (self.tableMode == CVRootTableViewModeWeek) {
        if (motion == UIEventSubtypeMotionShake) {
            [self toggleDetailOutlinePortraitWeekViews];
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CVMonthTableViewController"]) {
        self.monthTableViewController = segue.destinationViewController;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}






#pragma mark - Public

- (void)setMode:(CVRootViewControllerMode)mode
{
    _mode = mode;
    if (mode == CVRootViewControllerModeEvents) {
        self.tableMode = [CVSettings eventRootTableMode];
    }
    else if (mode == CVRootViewControllerModeReminders) {
        self.tableMode = [CVSettings reminderRootTableMode];
		
    }
    
    // toggle icon
    if (_mode == CVRootViewControllerModeEvents) {
        self.toggleModeButton.icon = CVEventReminderToggleButtonIconCheck;
    } else {
        self.toggleModeButton.icon = CVEventReminderToggleButtonIconCalendar;
    }

    [CVSettings setReminderView:(mode == CVRootViewControllerModeReminders ? YES : NO)];
    [self updateRootTableView];
    
    // get the table ready to scroll
    if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
        // scroll to current hour
        self.rootTableViewController.shouldScrollToCurrentHour = YES;
    }
    self.rootTableViewController.shouldScrollToDate = YES;
    
    // this causes the table to be redrawn
    self.monthTableViewController.mode = mode;
    
    // every time the table is reloaded, the red square needs to be reframed.
    self.monthTableViewController.selectedDate = self.selectedDate;
    
    if (self.mode == CVRootViewControllerModeEvents) {
        self.redBar.backgroundColor = RGBHex(0xCC0000);
    }
    else if (self.mode == CVRootViewControllerModeReminders) {
        self.redBar.backgroundColor = [UIColor blackColor];
    }
}

- (void)setTableMode:(CVRootTableViewMode)newTableMode 
{
    _tableMode = newTableMode;
    if (self.mode == CVRootViewControllerModeEvents) {
        [CVSettings setEventRootTableMode:self.tableMode];
    }
    if (self.mode == CVRootViewControllerModeReminders) {
        [CVSettings setReminderRootTableMode:self.tableMode];
    }
    [self updateRootTableView];
}

- (void)setWeekDayTitles
{
    // set weekday labels
    for (int i = 0; i < 7; i++) {
        UILabel *l = (UILabel *)[self.weekdayTitleBar viewWithTag:WEEKDAY_TITLES_OFFSET + i];
        BOOL abbr = self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
        NSString *weekDayAbbr = [[NSDate stringWithWeekDayAbbreviated:abbr forWeekdayIndex:i+1] uppercaseString];
        l.text = weekDayAbbr;
    }
}

- (void)showNewReminderScreenWithDate:(NSDate *)date 
{
}

- (void)showSnoozeDialogForEvent:(EKEvent *)snoozeEvent 
{
	CVEventSnoozeViewController_iPhone *eventSnoozeController = [[CVEventSnoozeViewController_iPhone alloc] init];
	eventSnoozeController.event = snoozeEvent;
	eventSnoozeController.delegate = self;
	
	// hide the keyboard if its up
	[self.view endEditing:YES];
	
	[self presentFullScreenModalViewController:eventSnoozeController animated:YES];
}

- (void)toggleRemindersEventsViewMode 
{
    // toggle the mode
    if (self.mode == CVRootViewControllerModeReminders) {
        [CVSettings setReminderView:NO];
        self.mode = CVRootViewControllerModeEvents;
        [UIApplication showBezelWithTitle:@"Events"];
    }
    else if (self.mode == CVRootViewControllerModeEvents) {
        [CVSettings setReminderView:YES];
        self.mode = CVRootViewControllerModeReminders;
        [UIApplication showBezelWithTitle:@"Reminders"];
    }
}

- (void)updateRootTableView 
{
    if (self.mode == CVRootViewControllerModeEvents) {
        if (self.tableMode == CVRootTableViewModeFull) {
            self.rootTableViewController = [[CVEventsFullDayTableViewController alloc] init];
        }
        
        else if (self.tableMode == CVRootTableViewModeAgenda) {
            self.rootTableViewController = [[CVEventsAgendaTableViewController alloc] init];
        }
        
        else if (self.tableMode == CVRootTableViewModeWeek) {
            //james
            if ([CVSettings useOutlinePortraitWeekView]) {
                self.rootTableViewController = [[CVEventsWeekAgendaTableViewController alloc] init];
            }
            else {
                self.rootTableViewController = [[CVEventsWeekStdAgendaTableViewController alloc] init];
            }
        }
    }
    else if (self.mode == CVRootViewControllerModeReminders) {
        if (self.tableMode == CVRootTableViewModeFull) _tableMode = CVRootTableViewModeAgenda;
        
        if (self.tableMode == CVRootTableViewModeFull || _tableMode == CVRootTableViewModeAgenda) {
            self.rootTableViewController = [[CVRemindersTableViewController alloc] init];
        }
        
        else if (self.tableMode == CVRootTableViewModeWeek) {
            //james
            if ([CVSettings useOutlinePortraitWeekView]) {
                self.rootTableViewController = [[CVRemindersWeekAgendaTableViewController alloc] init];
            }
            else {
                self.rootTableViewController = [[CVRemindersWeekStdAgendaTableViewController alloc] init];
            }
        }
    }
    
    [self.rootTableViewController setDelegate:self];
    self.rootTableViewController.tableControllerProtocol = self;
    self.rootTableViewController.tableView = self.rootTableView;    
    [self loadTableView];
}

- (void)loadTableView 
{
    self.rootTableViewController.selectedDate = self.selectedDate;
    [self.rootTableViewController loadTableView];
}

- (void)toggleDetailOutlinePortraitWeekViews 
{
    [CVSettings setUseOutlinePortraitWeekView:![CVSettings useOutlinePortraitWeekView]];
    if ([CVSettings useOutlinePortraitWeekView]) {
        [UIApplication showBezelWithTitle:@"Outline Week"];
    }
    else {
        [UIApplication showBezelWithTitle:@"Detail Week"];
    }
    
    if (self.tableMode == CVRootTableViewModeWeek) {
        [self updateRootTableView];
    }
}

- (void)redrawDotsOnMonthView 
{
    [self.monthTableViewController drawDotsForVisibleRows];
}

- (void)redrawRowsForEvent:(EKEvent *)event 
{
	NSInteger daysDuration = [event.endingDate mt_daysSinceDate:event.startingDate];
	for (NSInteger i = 0; i <= daysDuration; i++) {
		[self.monthTableViewController reloadRowForDate:[event.startingDate mt_dateDaysAfter:i]];
	}
}

- (void)redrawRowsForReminder:(EKReminder *)reminder 
{
	if (reminder.isCompleted) {
		[self.monthTableViewController reloadRowForDate:reminder.completionDate];
	}
	else
		[self.monthTableViewController reloadRowForDate:reminder.preferredDate];
}

- (void)showQuickAddWithDefault:(BOOL)def durationMode:(BOOL)dur date:(NSDate *)date view:(UIView *)view mode:(CVQuickAddMode)mode
{
}




#pragma mark - Actions

- (IBAction)handleEventTableViewPinchGesture:(UIPinchGestureRecognizer *)sender 
{
	if (sender.state != UIGestureRecognizerStateEnded) return;
    
    if (sender.scale < 1) {
        if (self.tableMode < CVRootTableViewModeWeek) {
            self.tableMode += 1;
        }
    }
    else {
        if (self.tableMode > CVRootTableViewModeFull) {
            self.tableMode -= 1;
        }
    }
    
    if (self.tableMode == CVRootTableViewModeFull) {
        [UIApplication showBezelWithTitle:@"Full Day"];
        if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
            // scroll to current hour
            self.rootTableViewController.shouldScrollToCurrentHour = YES;
        }
    }
    else if (self.tableMode == CVRootTableViewModeAgenda) {
        [UIApplication showBezelWithTitle:@"Agenda"];
        if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
            // scroll to current hour
            self.rootTableViewController.shouldScrollToCurrentHour = YES;
        }
    }
    else if (self.tableMode == CVRootTableViewModeWeek) {
        [UIApplication showBezelWithTitle:@"Week"];
        self.rootTableViewController.shouldScrollToDate = YES;
    }
}

- (IBAction)handleSwipeOnTableView:(UISwipeGestureRecognizer *)gesture 
{
    if (self.tableMode == CVRootTableViewModeWeek) {
        NSDate *newSelectedDate = nil;
        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            newSelectedDate = [self.selectedDate mt_oneWeekNext];
        } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            newSelectedDate = [self.selectedDate mt_oneWeekPrevious];
        }
        
        if (newSelectedDate) {
            self.selectedDate = newSelectedDate;
        }
    }
}

- (IBAction)handleLongPressOnPlusButtonGesture:(UILongPressGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
}

- (IBAction)handleLongPressOnMonthTitleGesture:(UILongPressGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
	self.selectedDate = [[NSDate date] mt_startOfCurrentDay];
}

- (IBAction)showViewOptionsButtonWasTapped:(id)sender 
{
}

- (IBAction)redBarPlusButtonWasTapped:(UITapGestureRecognizer *)gesture 
{
}

- (IBAction)toggleRemindersEventsViewIconTapped:(id)sender 
{
    [self toggleRemindersEventsViewMode];
}

- (IBAction)monthLabelWasTapped:(UITapGestureRecognizer *)gesture 
{
}




#pragma mark - Notifications

- (void)eventStoreChanged 
{
    [self.rootTableViewController loadTableView];
    [self.monthTableViewController drawDotsForVisibleRows];
}

- (void)reminderStoreChanged 
{
    [self.rootTableViewController loadTableView];
}

- (void)pocketLintSyncDidFinish 
{
    [self.rootTableViewController loadTableView];
}




#pragma mark - Table view cell delegate

- (void)cellHourTimeWasTapped:(CVEventCell *)cell 
{
    if (!cell.event) {
        CVSubHourPickerViewController *subHourPickerViewController = [[CVSubHourPickerViewController alloc] initWithDate:cell.date];
        subHourPickerViewController.delegate = self;
        subHourPickerViewController.popoverBackdropColor = patentedRed;
        subHourPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideRight;
        subHourPickerViewController.popoverArrowDirection = CVPopoverArrowDirectionLeftTop | CVPopoverArrowDirectionLeftMiddle | CVPopoverArrowDirectionLeftBottom;
        [self presentPopoverModalViewController:subHourPickerViewController forView:cell.timeTextHitArea animated:YES];
    }
}

- (void)cellWasTapped:(CVEventCell *)cell 
{
}

- (void)cellWasLongPressed:(CVEventCell *)cell 
{
    [self showQuickAddWithDefault:YES
                     durationMode:NO
                             date:cell.date
                             view:cell
                             mode:(self.mode == CVRootViewControllerModeEvents ? CVQuickAddModeEvent : CVQuickAddModeReminder)];
}

- (void)searchController:(CVSearchViewController_iPhone *)controller cellWasTapped:(CVEventCell *)cell
{
}

- (void)cell:(CVEventCell *)cell wasSwipedInDirection:(CVEventCellSwipedDirection)direction 
{
	if (direction == CVEventCellSwipedDirectionLeft) {
		self.selectedDate = [self.selectedDate mt_oneDayNext];
	}
	else {
		self.selectedDate = [self.selectedDate mt_oneDayPrevious];
	}
}

- (void)cell:(CVCell *)cell alarmButtonWasTappedForCalendarItem:(EKCalendarItem *)calendarItem
{
    if ([calendarItem isKindOfClass:[EKEvent class]] && ((EKEvent *)calendarItem).allDay) {
        CVAllDayAlarmPickerViewController *alarmPickerViewController = [[CVAllDayAlarmPickerViewController alloc] init];
        alarmPickerViewController.delegate = self;
        alarmPickerViewController.calendarItem = calendarItem;
        alarmPickerViewController.popoverBackdropColor = patentedRed;
        alarmPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        alarmPickerViewController.popoverArrowDirection = CVPopoverArrowDirectionRightTop | CVPopoverArrowDirectionRightMiddle | CVPopoverArrowDirectionRightBottom;
        [self presentPopoverModalViewController:alarmPickerViewController forView:cell.cellAccessoryButton animated:YES];
    } else {
        CVAlarmPickerViewController *alarmPickerViewController = [[CVAlarmPickerViewController alloc] init];
        alarmPickerViewController.delegate = self;
        alarmPickerViewController.calendarItem = calendarItem;
        alarmPickerViewController.popoverBackdropColor = patentedRed;
        alarmPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        alarmPickerViewController.popoverArrowDirection = CVPopoverArrowDirectionRightTop | CVPopoverArrowDirectionRightMiddle | CVPopoverArrowDirectionRightBottom;
        [self presentPopoverModalViewController:alarmPickerViewController forView:cell.cellAccessoryButton animated:YES];
    }
}

- (void)cellEventWasDeleted:(CVEventCell *)cell 
{
    [self.monthTableViewController.tableView reloadData];
}

- (void)cellReminderWasDeleted:(CVReminderCell *)cell 
{
    NSIndexPath *indexPath = [self.rootTableView indexPathForRowContainingView:cell];
    CVReminderCellDataHolder *holder = [self.rootTableViewController cellDataHolderAtIndexPath:indexPath];
    if (holder && holder.reminder) {
		EKReminder *reminderToRemove = holder.reminder;
        dispatch_async([CVOperationQueue backgroundQueue], ^{
            [reminderToRemove remove];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rootTableViewController removeObjectAtIndexPath:indexPath];
                [self.rootTableView deleteRowsAtIndexPaths:@[[self.rootTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationMiddle];
                [self.monthTableViewController.tableView reloadData];
            });
        });
		holder.reminder = nil;
    }
}

- (void)cellReminderWasCompleted:(CVReminderCell *)cell 
{
    [self.rootTableViewController loadTableView];
    [self.monthTableViewController.tableView reloadData];
}

- (void)cellReminderWasUncompleted:(CVReminderCell *)cell 
{
    [self.rootTableViewController loadTableView];
    [self.monthTableViewController.tableView reloadData];
}





#pragma mark - CVWeekTableViewCellDelegate

- (BOOL)isInPortrait 
{
    return self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
}

- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasPressedOnDate:(NSDate *)date 
{
  	self.selectedDate = date;
}

- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasLongPressedOnDate:(NSDate *)date withPlaceholder:(UIView *)placeholder 
{
	self.selectedDate = date;
}




#pragma mark - Manage calendars view controller delegate

- (void)manageCalendarsViewController:(CVManageCalendarsViewController_iPhone *)controller didFinishWithResult:(CVManageCalendarsResult)result
{
}




#pragma mark - Quick add view controller delegate

- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)result
{
    if (result == CVQuickAddResultSaved) {
        [UIApplication showBezelWithTitle:(controller.calendarItem.isEvent ? @"Event Added" : @"Reminder Added")];
        [_rootTableViewController loadTableView];
        [_monthTableViewController.tableView reloadData];
		[_monthTableViewController reframeRedSelectedDaySquareAnimated:NO];
    }
    [self becomeFirstResponder];
}




#pragma mark - Jump to date view controller delegate

- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller didFinishWithResult:(CVJumpToDateResult)result
{
	if (result == CVJumpToDateResultDateChosen) {
        NSDate *chosenDate = controller.chosenDate;
        self.monthTableViewController.startDate = [[chosenDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
		self.selectedDate = chosenDate;
    }
}




#pragma mark - Event view controller delegate

- (void)eventViewController:(CVEventViewController_iPhone *)controller didFinishWithResult:(CVEventResult)result
{
    if (result == CVEventResultSaved) {
        [self.rootTableViewController loadTableView];
        [self.monthTableViewController.tableView reloadData];
    }
    else if (result == CVEventResultDeleted) {       
        [self.rootTableViewController loadTableView];
        [self.monthTableViewController.tableView reloadData];
    }
    [self becomeFirstResponder];
}




#pragma mark - Reminder view controller delegate

- (void)reminderViewController:(CVReminderViewController_iPhone *)controller didFinishWithResult:(CVReminderViewControllerResult)result
{
    if (result == CVReminderViewControllerResultSaved) {
        [self.rootTableViewController loadTableView];
        [self.monthTableViewController.tableView reloadData];
		[self.monthTableViewController reframeRedSelectedDaySquareAnimated:NO];
    }
    else if (result == CVReminderViewControllerResultDeleted) {
        [self.rootTableViewController loadTableView];
        [self.monthTableViewController.tableView reloadData];
		[self.monthTableViewController reframeRedSelectedDaySquareAnimated:NO];
    }
    [self becomeFirstResponder];
}




#pragma mark - Alarm Picker Delegates

- (void)alarmPicker:(CVAlarmPickerViewController *)picker didFinishWithResult:(CVAlarmPickerResult)result 
{
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - Event Snooze View Controller Delegate

- (void)eventSnoozeViewController:(CVEventSnoozeViewController_iPhone *)controller didFinishWithResult:(CVEventSnoozeResult)result
{
	self.selectedDate = [controller.event.startingDate mt_startOfCurrentDay];
}




#pragma mark - View Options Popover Delegate

- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController didSelectOption:(CVViewOptionsPopoverOption)option byPressingButton:(CVRoundedToggleButton *)button
{

	[self dismissPopoverModalViewControllerAnimated:YES];
	
    if (option == CVViewOptionsPopoverOptionFullDayView) {
        [UIApplication showBezelWithTitle:@"Full Day"];
        self.tableMode = CVRootTableViewModeFull;
        if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
            // scroll to current hour
            self.rootTableViewController.shouldScrollToCurrentHour = YES;
        }
    }

    else if (option == CVViewOptionsPopoverOptionAgendaView) {
        [UIApplication showBezelWithTitle:@"Agenda"];
        self.tableMode = CVRootTableViewModeAgenda;
        if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
            // scroll to current hour
            self.rootTableViewController.shouldScrollToCurrentHour = YES;
        }
    }

    else if (option == CVViewOptionsPopoverOptionWeekView) {
        [UIApplication showBezelWithTitle:@"Week"];
        self.tableMode = CVRootTableViewModeWeek;
        self.rootTableViewController.shouldScrollToDate = YES;
    }

    else if (option == CVViewOptionsPopoverOptionSearch) {
		if (PAD) {
            CVSearchViewController_iPhone *searchViewController = [[CVSearchViewController_iPhone alloc] init];
            searchViewController.delegate = self;
            [self presentPopoverModalViewController:searchViewController forView:viewOptionsViewController.popoverTargetView animated:YES];
        }
        else {
            [self performSegueWithIdentifier:@"SearchSegue" sender:self];
        }
    }

	else if (option == CVViewOptionsPopoverOptionCalendars) {
        CVManageCalendarsViewMode viewMode = CVManageCalendarsViewModeEvents;
		
        // check current mode
        if (self.mode == CVRootViewControllerModeEvents) {
            viewMode = CVManageCalendarsViewModeEvents;
        }
        else if (self.mode == CVRootViewControllerModeReminders) {
            viewMode = CVManageCalendarsViewModeReminders;
        }

        CVManageCalendarsViewController_iPhone *manageCalendarsController = [[CVManageCalendarsViewController_iPhone alloc] initWithMode:viewMode];
        manageCalendarsController.delegate = self;

		if (PAD)	[self presentPopoverModalViewController:manageCalendarsController forView:viewOptionsViewController.popoverTargetView animated:YES];
		else		[self presentPageModalViewController:manageCalendarsController animated:YES completion:nil];
    }

	else if (option == CVViewOptionsPopoverOptionSettings) {
		[self openSettingsWithCompletionHandler:nil];
	}
}

- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController weekButtonWasLongPressed:(CVRoundedToggleButton *)button
{
    if ([button isEqual:viewOptionsViewController.weekButton]) {
        
        [self toggleDetailOutlinePortraitWeekViews];
        
        if (self.tableMode != CVRootTableViewModeWeek) {
            self.tableMode = CVRootTableViewModeWeek;
        }
        
        self.rootTableViewController.shouldScrollToDate = YES;
    }
}

- (void)viewOptionsViewControllerDidRequestToClose:(CVViewOptionsPopoverViewController *)viewOptionsViewController 
{
	[self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - Sub Hour Picker Delegate

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didPickDate:(NSDate *)date 
{
    [self dismissPopoverModalViewControllerAnimated:YES];    
}

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker didFinishWithResult:(CVSubHourPickerViewControllerResult)result 
{
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - Settings Segue Unwind

- (IBAction)closeSettings:(UIStoryboardSegue *)segue
{
	[NSDate mt_setFirstDayOfWeek:[CVSettings weekStartsOnWeekday]];
	[NSDate mt_setTimeZone:[CVSettings timezone]];
    [self setWeekDayTitles];
	[self updateRootTableView];

	self.monthTableViewController.startDate = [[self.selectedDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
	[self.monthTableViewController scrollToRowForDate:[self.selectedDate mt_startOfCurrentWeek] animated:NO scrollPosition:(PAD ? UITableViewScrollPositionMiddle : UITableViewScrollPositionTop)];
	[self.monthTableViewController reframeRedSelectedDaySquareAnimated:NO];
	
	[self.monthTableViewController.tableView reloadData];

	if (!PAD) {
		if (![CVSettings scrollableMonthView]) {
			self.monthTableViewController.tableView.scrollEnabled = NO;
		}
		else {
			self.monthTableViewController.tableView.scrollEnabled = YES;
		}
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		if (self.nativePopoverController) {
			[self.nativePopoverController dismissPopoverAnimated:YES];
			self.nativePopoverController = nil;
		}
	}
}




#pragma mark - CVSearchViewControllerDelegate

- (void)searchViewController:(CVSearchViewController_iPhone *)searchViewController didFinishWithResult:(CVSearchViewControllerResult)result
{
    [self becomeFirstResponder];
}




#pragma mark - CVGenericReminderViewControllerDelegate

- (void)genericReminderViewController:(CVGenericReminderViewController_iPhone *)controller didFinishWithResult:(CVGenericReminderViewControllerResult)result
{
    if (result == CVGenericReminderViewControllerResultAdded) {
        [self.rootTableViewController loadTableView];
		[self.monthTableViewController drawDotsForVisibleRows];
		[self setSelectedDate:[NSDate date]];
    }
}



#pragma mark - RootTableViewControllerProtocol Methods

- (void)tableViewDidScrollToDay:(NSDate *)day 
{
}




#pragma mark - CVWelcomeViewControllerDelegate

- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result 
{
	if (result == CVWelcomeViewControllerResultDontShowMe) {
		[CVSettings setWelcomeScreenHasBeenShown:YES];
	}
	if (result == CVWelcomeViewControllerResultStore) {
		[self openSettingsWithCompletionHandler:^(UINavigationController *settingsNavController) {
			[[settingsNavController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"StoreSegue" sender:nil];
		}];
	}
	else if (result == CVWelcomeViewControllerResultFAQ) {
		[self openSettingsWithCompletionHandler:^(UINavigationController *settingsNavController) {
			[[settingsNavController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"FAQSegue" sender:nil];
		}];
	}
	else if (result == CVWelcomeViewControllerResultGestures) {
		[self openSettingsWithCompletionHandler:^(UINavigationController *settingsNavController) {
			[[settingsNavController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"GesturesSegue" sender:nil];
		}];
	}
}




#pragma mark - CVLandscapeWeekViewDelegate

- (void)landscapeWeekViewController:(CVLandscapeWeekView *)controller didFinishWithResult:(CVLandscapeWeekViewResult)result 
{
}





#pragma mark - Private

- (void)openSettingsWithCompletionHandler:(void(^)(UINavigationController *settingsNavController))handler
{
	UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
	UINavigationController *navController = [settingsStoryboard instantiateInitialViewController];

	if (PAD) {
		navController.modalPresentationStyle = UIModalPresentationFormSheet;
		navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentViewController:navController animated:YES completion:^{
			if (handler) handler(navController);
		}];
	}
	else
		[self presentViewController:navController animated:YES completion:^{
			if (handler) handler(navController);
		}];
}

- (void)notifyOfNeededPermission
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We need permission"
                                                        message:@"This app can't function unless you give it permission to access your calendars: Go to Settings.app > Privacy > Calendars and make sure Calvetica is ON"];
    [alertView addButtonWithTitle:@"OK" handler:nil];
    [alertView show];
}



@end
