//
//  CVRootViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootViewController.h"
#import "CVEventsFullDayTableViewController.h"
#import "CVEventsAgendaTableViewController.h"
#import "CVEventsWeekAgendaTableViewController.h"
#import "CVEventsDetailedWeekTableViewController.h"
#import "CVGenericReminderViewController.h"
#import "CVWelcomeViewController.h"
#import "CVManageCalendarsViewController_iPhone.h"
#import "CVAllDayAlarmPickerViewController.h"
#import "CVViewOptionsPopoverViewController.h"
#import "CVSubHourPickerViewController.h"
#import "CVLandscapeWeekView.h"
#import "CVSearchViewController_iPhone.h"
#import "CVEventCellDataHolder.h"
// iPhone
#import "CVLandscapeWeekView_iPhone.h"
// iPad
#import "CVPopoverModalViewController_iPad.h"
#import "CVLandscapeWeekView_iPad.h"


typedef NS_ENUM(NSUInteger, CVRootMonthViewMoveDirection) {
    CVRootMonthViewMoveDirectionDown,
    CVRootMonthViewMoveDirectionUp
};

typedef NS_ENUM(NSUInteger, CVRootTableViewMode) {
    CVRootTableViewModeFull,
    CVRootTableViewModeAgenda,
    CVRootTableViewModeWeek,
    CVRootTableViewModeDetailedWeek
};


@interface CVRootViewController () <CVMonthTableViewControllerDelegate,
                                    CVQuickAddViewControllerDelegate,
                                    CVJumpToDateViewControllerDelegate,
                                    CVEventViewControllerDelegate,
                                    CVAlarmPickerViewControllerDelegate,
                                    CVManageCalendarsViewControllerDelegate,
                                    CVEventSnoozeViewControllerDelegate,
                                    CVViewOptionsPopoverViewControllerDelegate,
                                    CVSubHourPickerViewControllerDelegate,
                                    CVGenericReminderViewControllerDelegate,
                                    CVRootTableViewControllerDelegate,
                                    CVWelcomeViewControllerDelegate,
                                    CVSearchViewControllerDelegate,
                                    CVLandscapeWeekViewDelegate>

@property (nonatomic, weak  ) IBOutlet UIControl                    *redBarPlusButton;
@property (nonatomic, strong)          CVRootTableViewController    *rootTableViewController;
@property (nonatomic, weak  ) IBOutlet CVMonthTableViewController   *monthTableViewController;
@property (nonatomic, weak  ) IBOutlet UIButton                     *openCalendarsButton;
@property (nonatomic, strong)          UIPopoverController          *nativePopoverController;
@property (nonatomic, weak  ) IBOutlet UIButton                     *showViewOptionsButton;
@property (nonatomic, assign)          CVRootTableViewMode          rootTableMode;
@property (nonatomic, weak  ) IBOutlet UITableView                  *rootTableView;
@property (nonatomic, weak  ) IBOutlet UIButton                     *monthLabelControl;
@property (nonatomic, weak  ) IBOutlet UIView                       *monthTableViewContainer;
@property (nonatomic, weak  ) IBOutlet UIView                       *redBar;
@property (nonatomic, weak  ) IBOutlet UIView                       *weekdayTitleBar;

// iPhone
@property (nonatomic, assign)          CVRootMonthViewMoveDirection monthViewPushedUpDirection;

// iPad
@property (nonatomic, weak  ) IBOutlet UILabel                      *redBarMonthLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                      *redBarYearLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                      *grayBarWeekdayLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                      *grayBarDateLabel;
@end


@implementation CVRootViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

    [self setupNotifications];
    [self setupDefaults];
    [self setupUI];
    [self setupGestures];
    [self setUpMonthTableViewController];
    [self setupRootTableViewController];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.monthTableViewController.delegate  = nil;
    self.rootTableViewController.delegate   = nil;
    self.rootTableView.delegate             = nil;
    self.rootTableView.dataSource           = nil;
}

- (void)viewDidAppearAfterLoad:(BOOL)animated
{
    [super viewDidAppearAfterLoad:animated];

    if (![EKEventStore isPermissionGranted]) {
        [[EKEventStore permissionStore] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                [[EKEventStore permissionStore] requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                    [MTq main:^{
                        if (granted) {
                            [EKEventStore setPermissionGranted:granted];
                            self.selectedDate = self.todaysDate;
                            [self refreshUIAnimated:NO];
                            [self showWelcomeScreen];
                        }
                        else {
                            [self notifyOfNeededPermission];
                        }
                    }];
                }];
            }
            else {
                [MTq main:^{
                    [self notifyOfNeededPermission];
                }];
            }
        }];
    }

    [self updateLayoutAnimated:NO];
}

#pragma mark (rotation)

- (NSUInteger)supportedInterfaceOrientations
{
    if (PAD) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

// iPad

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (PAD) {
        self.monthTableViewController.selectedDayView.hidden = YES;
        for (CVPopoverModalViewController_iPad *controller in self.popoverModalViewControllers) {
            controller.view.hidden = YES;
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self updateLayoutAnimated:YES];
}


#pragma mark (appearance)

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}





#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CVMonthTableViewController"]) {
        self.monthTableViewController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"WeekViewSegue"]) {
        if (PAD) {
            CVLandscapeWeekView_iPhone *landscapeWeekView   = [segue destinationViewController];
            landscapeWeekView.delegate                      = self;
            landscapeWeekView.startDate                     = [NSDate date];
        }
        else {
            CVLandscapeWeekView_iPad *landscapeWeekView = [segue destinationViewController];
            landscapeWeekView.delegate                  = self;
            landscapeWeekView.startDate                 = [NSDate date];
        }
    }
    else if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        CVSearchViewController_iPhone *searchViewController = [segue destinationViewController];
        searchViewController.delegate = self;
    }
}

- (IBAction)closeSettings:(UIStoryboardSegue *)segue
{
	[NSDate mt_setFirstDayOfWeek:[CVSettings weekStartsOnWeekday]];
	[NSDate mt_setTimeZone:[CVSettings timezone]];
    [self updateWeekdayTitleLabels];
    [self reloadMonthTableView];
    [self updateSelectionSquare:NO];
    [self reloadRootTableViewWithCompletion:nil];

	if (PAD) {
		if (self.nativePopoverController) {
			[self.nativePopoverController dismissPopoverAnimated:YES];
			self.nativePopoverController = nil;
		}
	}
	else {
		if (![CVSettings scrollableMonthView]) {
			self.monthTableViewController.tableView.scrollEnabled = NO;
		}
		else {
			self.monthTableViewController.tableView.scrollEnabled = YES;
		}
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (IBAction)handleEventTableViewPinchGesture:(UIPinchGestureRecognizer *)sender
{
	if (sender.state != UIGestureRecognizerStateEnded) return;

    if (sender.scale < 1) {
        if (self.rootTableMode < CVRootTableViewModeDetailedWeek) {
            self.rootTableMode += 1;
        }
    }
    else {
        if (self.rootTableMode > CVRootTableViewModeFull) {
            self.rootTableMode -= 1;
        }
    }

    if (self.rootTableMode == CVRootTableViewModeFull) {
        [UIApplication showBezelWithTitle:@"Full Day"];
    }
    else if (self.rootTableMode == CVRootTableViewModeAgenda) {
        [UIApplication showBezelWithTitle:@"Agenda"];
    }
    else if (self.rootTableMode == CVRootTableViewModeWeek) {
        [UIApplication showBezelWithTitle:@"Week"];
    }
    else if (self.rootTableMode == CVRootTableViewModeDetailedWeek) {
        [UIApplication showBezelWithTitle:@"Detail Week"];
    }

    [self reloadRootTableViewWithCompletion:nil];
}

- (IBAction)handleSwipeOnTableView:(UISwipeGestureRecognizer *)gesture
{
    if (self.rootTableMode == CVRootTableViewModeWeek) {
        NSDate *newSelectedDate = nil;

        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            newSelectedDate = [self.selectedDate mt_oneWeekNext];
        }
        else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            newSelectedDate = [self.selectedDate mt_oneWeekPrevious];
        }

        if (newSelectedDate) {
            self.selectedDate = newSelectedDate;
            [self reloadMonthTableView];
            [self scrollMonthTableView];
            [self reloadRootTableViewWithCompletion:^{
                [self scrollRootTableView];
            }];
        }
    }
}

- (IBAction)handleLongPressOnPlusButtonGesture:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;

    CVGenericReminderViewController *genericReminderViewController = [CVGenericReminderViewController new];
    genericReminderViewController.delegate = self;

    if (PAD) {
        // resize view so that it doesn't have the black space at the bottom
        CGRect f = genericReminderViewController.view.frame;
        f.size.height -= IPHONE_KEYBOARD_PORTRAIT_HEIGHT;
        [genericReminderViewController.view setFrame:f];
        [self presentPopoverModalViewController:genericReminderViewController
                                        forView:self.redBarPlusButton
                                       animated:YES];
    }
    else {
        [self presentFullScreenModalViewController:genericReminderViewController animated:YES];
    }
}

- (IBAction)handleLongPressOnMonthTitleGesture:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;

    NSDate *chosenDate                      = [[NSDate date] mt_startOfCurrentDay];
    self.monthTableViewController.startDate = [[chosenDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
    self.selectedDate                       = chosenDate;
    [self reloadMonthTableView];
    [self scrollMonthTableView];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableView];
    }];
    [self updateSelectionSquare:YES];
}

- (IBAction)showCalendarsButtonWasTapped:(id)sender
{
    CVManageCalendarsViewController_iPhone *manageCalendarsController = [CVManageCalendarsViewController_iPhone new];
    manageCalendarsController.delegate = self;

    if (PAD) {
        [self presentPopoverModalViewController:manageCalendarsController forView:self.openCalendarsButton animated:YES];
    }
    else {
        [self presentPageModalViewController:manageCalendarsController animated:YES completion:nil];
    }
}

- (IBAction)showViewOptionsButtonWasTapped:(id)sender
{
    CVViewOptionsPopoverViewController *viewOptionsPopover = [[CVViewOptionsPopoverViewController alloc] init];
    viewOptionsPopover.delegate = self;
    viewOptionsPopover.currentViewMode = (CVViewOptionsPopoverOption)self.rootTableMode;
    if (PAD) {
        viewOptionsPopover.popoverBackdropColor = patentedDarkGray;
        viewOptionsPopover.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
        [self presentPopoverModalViewController:viewOptionsPopover forView:sender animated:YES];
    }
    else {
        viewOptionsPopover.popoverBackdropColor     = patentedDarkGray;
        viewOptionsPopover.attachPopoverArrowToSide = CVPopoverModalAttachToSideRight;
        [self presentPopoverModalViewController:viewOptionsPopover forView:sender animated:YES];
    }
}

- (IBAction)redBarPlusButtonWasTapped:(UITapGestureRecognizer *)gesture
{
    if (PAD) {
        [self showQuickAddWithDefault:NO
                         durationMode:NO
                                 date:self.selectedDate
                                title:nil
                                 view:gesture.view];
    }
    else {
       	[self showQuickAddWithDefault:NO
                         durationMode:NO
                                 date:self.selectedDate
                                title:nil
                                 view:nil];
    }
}

- (IBAction)monthLabelWasTapped:(UITapGestureRecognizer *)gesture
{
    CVEventDayViewController_iPhone *eventDayViewController = [[CVEventDayViewController_iPhone alloc] init];
    eventDayViewController.initialDate = self.selectedDate;

    CVJumpToDateViewController_iPhone *jumpToDateController = [[CVJumpToDateViewController_iPhone alloc]
                                                               initWithContentViewController:eventDayViewController];
    jumpToDateController.delegate = self;

    if (PAD) {
        jumpToDateController.popoverArrowDirection = CVPopoverArrowDirectionTopLeft;
        jumpToDateController.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
        [self presentPopoverModalViewController:jumpToDateController forView:gesture.view animated:YES];
    }
    else {
        [self presentPageModalViewController:jumpToDateController animated:YES completion:nil];
    }
}


#pragma mark (iphone)

- (IBAction)monthTableViewWasSwiped:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateEnded) return;

    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.selectedDate = [self.selectedDate mt_oneMonthNext];
        [self updateSelectionSquare:YES];
        [self scrollMonthTableView];
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        self.selectedDate = [self.selectedDate mt_oneMonthPrevious];
        [self updateSelectionSquare:YES];
        [self scrollMonthTableView];
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }
	else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
		[self moveMonthView:CVRootMonthViewMoveDirectionUp animated:YES];
	}
	else if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
		[self moveMonthView:CVRootMonthViewMoveDirectionDown animated:YES];
	}
}

#pragma mark (iPad)

- (IBAction)handleThreeFingerSwipeOnMonthView:(UISwipeGestureRecognizer *)gesture
{
    [self showWeekView];
}

- (IBAction)dayViewHeaderTapped:(id)sender
{
	[self scrollMonthTableView];
    [self updateSelectionSquare:YES];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableView];
    }];
}

- (IBAction)showWeekViewButtonWasTapped:(id)sender
{
    [self showWeekView];
}




#pragma mark - Public

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    self.monthTableViewController.selectedDate = selectedDate;
    self.rootTableViewController.selectedDate = selectedDate;
}

- (void)showQuickAddWithTitle:(NSString *)title date:(NSDate *)date
{
    [self showQuickAddWithDefault:YES
                     durationMode:NO
                             date:date
                            title:title
                             view:self.redBarPlusButton];
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

- (void)refreshUIAnimated:(BOOL)animated
{
    [self reloadMonthTableView];
    [self scrollMonthTableView];
    [self updateSelectionSquare:animated];
    [self updateLayoutAnimated:animated];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableView];
    }];
    [self updateWeekdayTitleLabels];
    [self updateMonthAndDayLabels];
}





#pragma mark - DELEGATE root table view

- (void)rootTableViewController:(CVRootTableViewController *)controller didScrollToDay:(NSDate *)date
{
    self.selectedDate = date;
    [self updateSelectionSquare:YES];
    [self scrollMonthTableView];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller tappedCell:(CVEventCell *)cell
{
    if (cell.event) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:cell.event
                                                                                          andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        if (PAD) {
            eventViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
            eventViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                         CVPopoverArrowDirectionRightMiddle |
                                                         CVPopoverArrowDirectionRightBottom);
            [self presentPopoverModalViewController:eventViewController
                                            forView:cell
                                           animated:YES];
        }
        else {
            [self presentPageModalViewController:eventViewController animated:YES completion:nil];
        }
    } else {
        [self showQuickAddWithDefault:YES
                         durationMode:YES
                                 date:cell.date
                                title:nil
                                 view:cell];
    }
}

- (void)rootTableViewController:(CVRootTableViewController *)controller tappedHourOnCell:(CVEventCell *)cell
{
    if (cell.event) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:cell.event
                                                                                          andMode:CVEventModeHour];
        eventViewController.delegate = self;
        if (PAD) {
            eventViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
            eventViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                         CVPopoverArrowDirectionRightMiddle |
                                                         CVPopoverArrowDirectionRightBottom);
            [self presentPopoverModalViewController:eventViewController forView:cell animated:YES];
        }
        else {
            [self presentPageModalViewController:eventViewController animated:YES completion:nil];
        }
    }
    else {
        CVSubHourPickerViewController *subHourPickerViewController = [[CVSubHourPickerViewController alloc]
                                                                      initWithDate:cell.date];
        subHourPickerViewController.delegate = self;
        subHourPickerViewController.popoverBackdropColor = patentedRed;
        subHourPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideRight;
        subHourPickerViewController.popoverArrowDirection = (CVPopoverArrowDirectionLeftTop |
                                                             CVPopoverArrowDirectionLeftMiddle |
                                                             CVPopoverArrowDirectionLeftBottom);
        [self presentPopoverModalViewController:subHourPickerViewController forView:cell.timeTextHitArea animated:YES];
    }
}

- (void)rootTableViewController:(CVRootTableViewController *)controller longPressedCell:(CVEventCell *)cell
{
    [self showQuickAddWithDefault:YES
                     durationMode:YES
                             date:cell.date
                            title:nil
                             view:cell];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     swipedCell:(CVEventCell *)cell
                    inDirection:(CVEventCellSwipedDirection)direction
{
	if (direction == CVEventCellSwipedDirectionLeft) {
		self.selectedDate = [self.selectedDate mt_oneDayNext];
	}
	else {
        self.selectedDate = [self.selectedDate mt_oneDayPrevious];
	}
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableView];
    }];
    [self updateSelectionSquare:YES];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller tappedAlarmOnCell:(CVEventCell *)cell
{
    if (cell.event.isAllDay) {
        CVAllDayAlarmPickerViewController *alarmPickerViewController = [[CVAllDayAlarmPickerViewController alloc] init];
        alarmPickerViewController.delegate = self;
        alarmPickerViewController.calendarItem = cell.event;
        alarmPickerViewController.popoverBackdropColor = patentedRed;
        alarmPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        alarmPickerViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                           CVPopoverArrowDirectionRightMiddle |
                                                           CVPopoverArrowDirectionRightBottom);
        [self presentPopoverModalViewController:alarmPickerViewController
                                        forView:cell.cellAccessoryButton animated:YES];
    } else {
        CVAlarmPickerViewController *alarmPickerViewController = [[CVAlarmPickerViewController alloc] init];
        alarmPickerViewController.delegate = self;
        alarmPickerViewController.calendarItem = cell.event;
        alarmPickerViewController.popoverBackdropColor = patentedRed;
        alarmPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        alarmPickerViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                           CVPopoverArrowDirectionRightMiddle |
                                                           CVPopoverArrowDirectionRightBottom);
        [self presentPopoverModalViewController:alarmPickerViewController
                                        forView:cell.cellAccessoryButton animated:YES];
    }
}

- (void)rootTableViewController:(CVRootTableViewController *)controller tappedDeleteOnCell:(CVEventCell *)cell
{
	// find the cell of the event that was deleted. If it was not on an even hour its agenda mode, delete the cell.
    NSIndexPath *indexPath = [self.rootTableView indexPathForRowContainingView:cell];
    CVEventCellDataHolder *holder = (CVEventCellDataHolder *)[self.rootTableViewController
                                                              cellDataHolderAtIndexPath:indexPath];

	if (holder) {

		EKEvent *eventToDelete = holder.event;

		[eventToDelete removeThenDoActionBlock:^(void) {
			holder.event = nil;
			holder.isAllDay = NO;

			if (![holder.date mt_isStartOfAnHour] || self.rootTableMode != CVRootTableViewModeFull) {
				[self.rootTableViewController removeObjectAtIndexPath:indexPath];
                [self.rootTableView beginUpdates];
				[self.rootTableView deleteRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                [self.rootTableView endUpdates];
			}
			else {
				[self.rootTableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
			}

			// if it repeats we need to reload all the rows in ase dots for this week appear on other weeks
			if (eventToDelete.hasRecurrenceRules || ![eventToDelete fitsWithinWeekOfDate:self.selectedDate]) {
				[self.monthTableViewController reloadTableView];
			} else {
				[self.monthTableViewController reloadRowForDate:self.selectedDate];
			}
		} cancelBlock:^(void) {}];
    }
}





#pragma mark - DELEGATE month table view

- (void)monthTableViewController:(CVMonthTableViewController *)controller
                      tappedCell:(CVWeekTableViewCell *)cell
                          onDate:(NSDate *)date
{
    self.selectedDate = date;
    [self updateSelectionSquare:YES];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableView];
    }];
    if (!PAD) {
        [self scrollMonthTableView];
    }
}

- (void)monthTableViewController:(CVMonthTableViewController *)controller
               longPressedOnCell:(CVWeekTableViewCell *)cell
                          onDate:(NSDate *)date
                 placeholderView:(UIView *)placeholder
{
    self.selectedDate = date;

    [self showQuickAddWithDefault:NO
                     durationMode:NO
                             date:date
                            title:nil
                             view:placeholder];

    [placeholder removeFromSuperview];
}




#pragma mark - DELEATE manage calendars

- (void)manageCalendarsViewController:(CVManageCalendarsViewController_iPhone *)controller
                  didFinishWithResult:(CVManageCalendarsResult)result
{
    if (result == CVManageCalendarsResultModified) {
        [self refreshUIAnimated:YES];
    }

    if (PAD) {
        [self dismissPopoverModalViewControllerAnimated:YES];
    }
    else {
        [self dismissPageModalViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - DELEGATE quick add

- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller
         didCompleteWithAction:(CVQuickAddResult)result
{
    if (result == CVQuickAddResultSaved) {
        [UIApplication showBezelWithTitle:@"Event Added"];
        [self refreshUIAnimated:YES];
    }

    if (PAD) {
        [self dismissPopoverModalViewControllerAnimated:YES];
    }
    else {
        [self dismissFullScreenModalViewControllerAnimated:YES];
    }

    if (result == CVQuickAddResultSaved) {
        [self reloadMonthTableViewRowsForEvent:(EKEvent *)controller.calendarItem];
    }
    else if (result == CVQuickAddResultMore) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc]
                                                      initWithEvent:(EKEvent *)controller.calendarItem
                                                      andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        if (PAD) {
            [self presentPopoverModalViewController:eventViewController
                                            forView:controller.popoverTargetView
                                           animated:YES];
        }
        else {
            [self presentPageModalViewController:eventViewController
                                        animated:YES
                                      completion:nil];
        }
    }
}




#pragma mark - DELEGATE jump to date

- (void)jumpToDateViewController:(CVJumpToDateViewController_iPhone *)controller
             didFinishWithResult:(CVJumpToDateResult)result
{
	if (result == CVJumpToDateResultDateChosen) {
        NSDate *chosenDate = controller.chosenDate;
        self.monthTableViewController.startDate = [[chosenDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
        self.selectedDate = chosenDate;
        [self refreshUIAnimated:YES];
    }

    if (PAD) {
        [self dismissPopoverModalViewControllerAnimated:YES];
    }
    else {
        [self dismissPageModalViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - DELEGATE event view controller

- (void)eventViewController:(CVEventViewController *)controller didFinishWithResult:(CVEventResult)result
{
    if (result == CVEventResultSaved) {
        [self reloadRootTableViewWithCompletion:nil];
        [self reloadMonthTableView];
    }
    else if (result == CVEventResultDeleted) {       
        [self reloadRootTableViewWithCompletion:nil];
        [self reloadMonthTableView];
    }

    if (result == CVEventResultSaved || result == CVEventResultDeleted) {
        // if they moved it to a different day, that could be any day.
        [self.monthTableViewController reloadTableView];
    }

    if (PAD) {
        [self dismissPopoverModalViewControllerAnimated:YES];
    }
    else {
        [self dismissPageModalViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - DELEGATE alarm picker

- (void)alarmPicker:(CVAlarmPickerViewController *)picker didFinishWithResult:(CVAlarmPickerResult)result 
{
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - DELEGATE snooze view controller

- (void)eventSnoozeViewController:(CVEventSnoozeViewController_iPhone *)controller
              didFinishWithResult:(CVEventSnoozeResult)result
{
    self.selectedDate = [controller.event.startingDate mt_startOfCurrentDay];
    [self refreshUIAnimated:NO];

    [self dismissFullScreenModalViewControllerAnimated:YES];

	if (result == CVEventSnoozeResultShowDetails) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:controller.event
                                                                                          andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        if (PAD) {
            [self presentPopoverModalViewController:eventViewController
                                            forView:self.redBarPlusButton animated:YES];
            [self.monthTableViewController scrollToRowForDate:controller.event.startingDate
                                                     animated:YES
                                               scrollPosition:UITableViewScrollPositionMiddle];
        }
        else {
            [self presentPageModalViewController:eventViewController animated:YES completion:nil];
        }
    }
}




#pragma mark - DELEGATE view options popover

- (void)viewOptionsViewController:(CVViewOptionsPopoverViewController *)viewOptionsViewController
                  didSelectOption:(CVViewOptionsPopoverOption)option
                 byPressingButton:(CVRoundedToggleButton *)button
{

	[self dismissPopoverModalViewControllerAnimated:YES];
	
    if (option == CVViewOptionsPopoverOptionFullDayView) {
        self.rootTableMode = CVRootTableViewModeFull;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionAgendaView) {
        self.rootTableMode = CVRootTableViewModeAgenda;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionWeekView) {
        self.rootTableMode = CVRootTableViewModeWeek;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionDetailedWeekView) {
        self.rootTableMode = CVRootTableViewModeDetailedWeek;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionSearch) {
		if (PAD) {
            CVSearchViewController_iPhone *searchViewController = [[CVSearchViewController_iPhone alloc] init];
            searchViewController.delegate = self;
            [self presentPopoverModalViewController:searchViewController
                                            forView:viewOptionsViewController.popoverTargetView animated:YES];
        }
        else {
            [self performSegueWithIdentifier:@"SearchSegue" sender:self];
        }
    }

	else if (option == CVViewOptionsPopoverOptionSettings) {
		[self openSettingsWithCompletionHandler:nil];
	}
}

- (void)viewOptionsViewControllerDidRequestToClose:(CVViewOptionsPopoverViewController *)viewOptionsViewController 
{
	[self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - DELEGATE sub hour picker

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker
          didPickDate:(NSDate *)date
{
    [self showQuickAddWithDefault:YES
					 durationMode:YES
							 date:date
                            title:nil
							 view:self.redBarPlusButton];
    [self dismissPopoverModalViewControllerAnimated:YES];
}

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker
  didFinishWithResult:(CVSubHourPickerViewControllerResult)result
{
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - DELEGATE search view controller

- (void)searchViewController:(CVSearchViewController_iPhone *)searchViewController
         didFinishWithResult:(CVSearchViewControllerResult)result
{
    if (!PAD) {
        [self dismissViewControllerAnimated:YES completion:NO];
    }
}

- (void)searchViewController:(CVSearchViewController_iPhone *)controller tappedCell:(CVSearchEventCell *)cell
{
    if (PAD) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:cell.event
                                                                                          andMode:CVEventModeDetails];
        eventViewController.delegate = self;
        eventViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        eventViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                     CVPopoverArrowDirectionRightMiddle |
                                                     CVPopoverArrowDirectionRightBottom);
        [self presentPopoverModalViewController:eventViewController
                                        forView:cell
                                       animated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:cell.event
                                                                                              andMode:CVEventModeDetails];
            eventViewController.delegate = self;
            [self presentPageModalViewController:eventViewController animated:YES completion:nil];
        }];
    }
}






#pragma mark - DELEGATE generic reminder

- (void)genericReminderViewController:(CVGenericReminderViewController *)controller
                  didFinishWithResult:(CVGenericReminderViewControllerResult)result
{
    if (result == CVGenericReminderViewControllerResultAdded) {
        self.selectedDate = [NSDate date];
        [self reloadMonthTableView];
        [self scrollMonthTableView];
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableView];
        }];
    }

    if (PAD) {
        [self dismissPopoverModalViewControllerAnimated:YES];
    }
    else {
        [self dismissFullScreenModalViewControllerAnimated:YES];
    }
}







#pragma mark - DELEGATE welcome view controller

- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result 
{
	if (result != CVWelcomeViewControllerResultDontShowMe) {
        [MTMigration reset];
	}

	if (result == CVWelcomeViewControllerResultFAQ) {
		[self openSettingsWithCompletionHandler:^(UINavigationController *settingsNavController) {
			[[settingsNavController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"FAQSegue"
                                                                                         sender:nil];
		}];
	}
	else if (result == CVWelcomeViewControllerResultGestures) {
		[self openSettingsWithCompletionHandler:^(UINavigationController *settingsNavController) {
			[[settingsNavController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"GesturesSegue"
                                                                                         sender:nil];
		}];
	}
	else if (result == CVWelcomeViewControllerResultContactUs) {
		[self openSettingsWithCompletionHandler:^(UINavigationController *settingsNavController) {
			[[settingsNavController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"ContactUsSegue"
                                                                                         sender:nil];
		}];
	}

    if (result == CVWelcomeViewControllerResultDontShowMe || result == CVWelcomeViewControllerResultCancel) {
		[self dismissPageModalViewControllerAnimated:YES completion:nil];
	}
}




#pragma mark - DELEGATE landscape week view

- (void)landscapeWeekViewController:(CVLandscapeWeekView *)controller
                didFinishWithResult:(CVLandscapeWeekViewResult)result
{
	[self.monthTableViewController reloadTableView];
    if (result != CVLandscapeWeekViewResultModified) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - DELEGATE gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // We allow taps and long presses to occur at the same time. This lets us select a day when
    // the user is long pressing on a day.
    if ([gestureRecognizer isKindOfClass:[CVTapGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        return YES;
    }
    return NO;
}






#pragma mark - Notifications

- (void)orientationDidChange:(NSNotification *)notification
{
    if (PAD) {
        if (self.view.window) return;
        [self updateLayoutAnimated:YES];
    }
    else {
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

            [self performSegueWithIdentifier:@"WeekViewSegue" sender:self];
        }
    }
}

- (void)eventStoreChanged
{
    [self reloadMonthTableView];
    [self reloadRootTableViewWithCompletion:nil];
}





#pragma mark - Private

#pragma mark (setup)

- (void)setupGestures
{
    UIPinchGestureRecognizer *pinchOnRootTableViewToToggleMode  = [[UIPinchGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(handleEventTableViewPinchGesture:)];
    [self.rootTableView addGestureRecognizer:pinchOnRootTableViewToToggleMode];

    UISwipeGestureRecognizer *swipeLeftOnRootTableView          = [[UISwipeGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(handleSwipeOnTableView:)];
    swipeLeftOnRootTableView.direction                          = UISwipeGestureRecognizerDirectionLeft;
    [self.rootTableView addGestureRecognizer:swipeLeftOnRootTableView];

    UISwipeGestureRecognizer *swipeRightOnRootTableView         = [[UISwipeGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(handleSwipeOnTableView:)];
    [self.rootTableView addGestureRecognizer:swipeRightOnRootTableView];

    UITapGestureRecognizer *tapOnRedBarPlusButton               = [[UITapGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(redBarPlusButtonWasTapped:)];
    [self.redBarPlusButton addGestureRecognizer:tapOnRedBarPlusButton];

    UILongPressGestureRecognizer *longPressOnRedBarPlusButton   = [[UILongPressGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(handleLongPressOnPlusButtonGesture:)];
    [self.redBarPlusButton addGestureRecognizer:longPressOnRedBarPlusButton];

    UITapGestureRecognizer *tapOnRedBarMonthLabel               = [[UITapGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(monthLabelWasTapped:)];
    [self.monthLabelControl addGestureRecognizer:tapOnRedBarMonthLabel];

    UILongPressGestureRecognizer *longPressOnRedBarMonthLabel   = [[UILongPressGestureRecognizer alloc]
                                                                   initWithTarget:self
                                                                   action:@selector(handleLongPressOnMonthTitleGesture:)];
    [self.monthLabelControl addGestureRecognizer:longPressOnRedBarMonthLabel];

    if (PAD) {
        UISwipeGestureRecognizer *swipeRightOnMonthViewWithThreeFingers = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(handleThreeFingerSwipeOnMonthView:)];
        swipeRightOnMonthViewWithThreeFingers.numberOfTouchesRequired   = 3;
        swipeRightOnMonthViewWithThreeFingers.direction                 = (UISwipeGestureRecognizerDirectionLeft |
                                                                           UISwipeGestureRecognizerDirectionRight);
        [self.monthTableViewController.tableView addGestureRecognizer:swipeRightOnMonthViewWithThreeFingers];
    }
    else {
        UISwipeGestureRecognizer *swipeRightOnMonthTableView            = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeRightOnMonthTableView.direction                            = UISwipeGestureRecognizerDirectionRight;
        [self.monthTableViewContainer addGestureRecognizer:swipeRightOnMonthTableView];

        UISwipeGestureRecognizer *swipeDownOnMonthTableView             = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeDownOnMonthTableView.direction                             = UISwipeGestureRecognizerDirectionDown;
        [self.monthTableViewContainer addGestureRecognizer:swipeDownOnMonthTableView];

        UISwipeGestureRecognizer *swipeLeftOnMonthTableView             = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeLeftOnMonthTableView.direction                             = UISwipeGestureRecognizerDirectionLeft;
        [self.monthTableViewContainer addGestureRecognizer:swipeLeftOnMonthTableView];

        UISwipeGestureRecognizer *swipeUpOnMonthTableView               = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeUpOnMonthTableView.direction                               = UISwipeGestureRecognizerDirectionUp;
        [self.monthTableViewContainer addGestureRecognizer:swipeUpOnMonthTableView];

        UISwipeGestureRecognizer *swipeUpOniPhoneRedBar                 = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeUpOniPhoneRedBar.direction                                 = UISwipeGestureRecognizerDirectionUp;
        [self.redBar addGestureRecognizer:swipeUpOniPhoneRedBar];

        UISwipeGestureRecognizer *swipeDownOniPhoneRedBar               = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeDownOniPhoneRedBar.direction                               = UISwipeGestureRecognizerDirectionDown;
        [self.redBar addGestureRecognizer:swipeDownOniPhoneRedBar];
    }
}

- (void)setupNotifications
{
    // register to know when the phone is turned sideways
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    // register to know when the event store changes.  When it does, we need to update calvetica alerts
    // if that preferences is enabled.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventStoreChanged)
                                                 name:EKEventStoreChangedNotification
                                               object:nil];
}

- (void)setupDefaults
{
    // if the view is not scrollable, lock it
    if (!PAD && ![CVSettings scrollableMonthView]) {
        self.monthTableViewController.tableView.scrollEnabled = NO;
    }

    // set todays day, used for reference when coming out of background
    self.todaysDate     = [[NSDate date] mt_startOfCurrentDay];;
    self.selectedDate   = self.todaysDate;

    self.monthViewPushedUpDirection = CVRootMonthViewMoveDirectionDown;
}

- (void)setupUI
{
    if (!PAD) {
        // rotate month button
        CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-90.0f));
        self.monthLabelControl.transform = rotateTransform;
    }
    [self updateWeekdayTitleLabels];
}

- (void)setUpMonthTableViewController
{
    self.monthTableViewController.delegate      = self;
    self.monthTableViewController.startDate     = [[self.todaysDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
    self.monthTableViewController.selectedDate  = self.todaysDate;
}

- (void)setupRootTableViewController
{
    self.rootTableMode = [CVSettings eventRootTableMode];
}



#pragma mark (iphone)

- (void)updateLayoutAnimated:(BOOL)animated
{
    if (PAD) {
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

        if (deviceOrientation == UIInterfaceOrientationPortrait ||
            deviceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.monthTableViewController.tableView.rowHeight = IPAD_MONTH_VIEW_ROW_HEIGHT_PORTRAIT;
        }
        else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft ||
                 deviceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            self.monthTableViewController.tableView.rowHeight = IPAD_MONTH_VIEW_ROW_HEIGHT_LANDSCAPE;
        }

        [self reloadMonthTableView];
        [self scrollMonthTableView];
        [self updateWeekdayTitleLabels];

        for (CVPopoverModalViewController_iPad *popoverController in self.popoverModalViewControllers) {
            popoverController.view.hidden = NO;
            [popoverController layout];
        }

        self.monthTableViewController.selectedDayView.hidden = NO;
    }
    else {
        // adjust layout
        NSInteger numberOfRows = [self.selectedDate numberOfCalendarRowsInCurrentMonth];
        CGFloat h = 40.0f;

        void (^animations)(void) = ^{
            // stretch day button container
            self.monthTableViewContainer.height = numberOfRows * h;
            self.redBar.height = self.monthTableViewContainer.height;

            // adjust table view
            CGRect r = self.rootTableView.frame;
            r.origin.y = ((numberOfRows * h) + self.weekdayTitleBar.bounds.size.height);
            r.size.height = self.view.height - self.rootTableView.y;
            self.rootTableView.frame = r;
        };

        void (^completion)(void) = ^{
            [self moveMonthView:self.monthViewPushedUpDirection animated:animated];
        };

        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                animations();
            } completion:^(BOOL finished) {
                completion();
            }];
        }
        else {
            animations();
            completion();
        }
    }
}

- (void)moveMonthView:(CVRootMonthViewMoveDirection)direction animated:(BOOL)animated
{
	self.monthViewPushedUpDirection = direction;

	NSInteger numberOfRows = [self.selectedDate numberOfCalendarRowsInCurrentMonth];
	NSInteger rowsToHide = numberOfRows - 2;

    CGFloat h = 40.0f;

    UIView *monthTableView      = self.monthTableViewContainer;
    UITableView *rootTableView  = self.rootTableView;
    UIView *redBar              = self.redBar;

    void (^animations)(void) = ^{
        if (direction == CVRootMonthViewMoveDirectionDown) {
            redBar.y                = self.weekdayTitleBar.y + self.weekdayTitleBar.height;
            monthTableView.height   = numberOfRows * h;
        }
        else {
            redBar.y                = -(h * rowsToHide) + self.weekdayTitleBar.height;
            monthTableView.height   = 2 * h;
        }
        rootTableView.y         = monthTableView.y + monthTableView.height;
        rootTableView.height    = self.view.height - rootTableView.y;
    };

    void (^completion)(void) = ^{
        [self updateSelectionSquare:NO];
    };

    if (animated) {
        [UIView mt_animateViews:@[monthTableView, rootTableView, redBar]
                       duration:0.4
                 timingFunction:(direction == CVRootMonthViewMoveDirectionUp ? kMTEaseOutBack : kMTEaseOutBounce)
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         animations();
                     } completion:^{
                         completion();
                     }];
    }
    else {
        animations();
        completion();
    }
}


#pragma mark (iPad)

- (void)showWeekView
{
    [self performSegueWithIdentifier:@"WeekViewSegue" sender:self];
}

- (void)updateMonthAndDayLabels
{
    if (PAD) {
        _redBarMonthLabel.text      = [[self.selectedDate stringWithTitleOfCurrentMonthAbbreviated:NO] lowercaseString];
        _redBarYearLabel.text       = [NSString stringWithFormat:@"%d", [self.selectedDate mt_year]];
        _grayBarWeekdayLabel.text   = [[self.selectedDate stringWithTitleOfCurrentWeekDayAbbreviated:NO] lowercaseString];
        _grayBarDateLabel.text      = [[self.selectedDate stringWithMonthAndDayAbbreviated:YES] uppercaseString];

        // shift year label in red bar horizontally
        _redBarYearLabel.x          = _redBarMonthLabel.frame.origin.x + [_redBarMonthLabel sizeOfTextInLabel].width + MONTH_YEAR_TEXT_SPACING;

        // shift date label in gray bar horizontally
        _grayBarDateLabel.x         = _grayBarWeekdayLabel.frame.origin.x + [_grayBarWeekdayLabel sizeOfTextInLabel].width + MONTH_YEAR_TEXT_SPACING;
    }
    else {
        NSInteger numberOfRows = [self.selectedDate numberOfCalendarRowsInCurrentMonth];
        NSString *titleOfCurrentMonthAbbreviated = (numberOfRows != 4 ?
                                                    [self.selectedDate stringWithTitleOfCurrentMonthAndYearAbbreviated:YES] :
                                                    [self.selectedDate stringWithTitleOfCurrentMonthAbbreviated:YES]);
        self.monthLabelControl.titleLabel.text = [titleOfCurrentMonthAbbreviated uppercaseString];
    }
}


#pragma mark (Refreshing the UI)

- (void)setRootTableMode:(CVRootTableViewMode)newTableMode
{
    _rootTableMode = newTableMode;
    [CVSettings setEventRootTableMode:self.rootTableMode];

    if (self.rootTableMode == CVRootTableViewModeFull) {
        self.rootTableViewController = [CVEventsFullDayTableViewController new];
    }

    else if (self.rootTableMode == CVRootTableViewModeAgenda) {
        self.rootTableViewController = [CVEventsAgendaTableViewController new];
    }

    else if (self.rootTableMode == CVRootTableViewModeWeek) {
        self.rootTableViewController = [CVEventsWeekAgendaTableViewController new];
    }

    else if (self.rootTableMode == CVRootTableViewModeDetailedWeek) {
        self.rootTableViewController = [CVEventsDetailedWeekTableViewController new];
    }

    self.rootTableViewController.delegate       = self;
    self.rootTableViewController.selectedDate   = self.selectedDate;
    self.rootTableViewController.tableView      = self.rootTableView;
}

- (void)updateWeekdayTitleLabels
{
    // set weekday labels
    for (int i = 0; i < 7; i++) {
        UILabel *l = (UILabel *)[self.weekdayTitleBar viewWithTag:WEEKDAY_TITLES_OFFSET + i];
        BOOL abbr = (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
                     self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
        NSString *weekDayAbbr = [[NSDate stringWithWeekDayAbbreviated:abbr forWeekdayIndex:i+1] uppercaseString];
        l.text = weekDayAbbr;
    }
}

- (void)reloadRootTableViewWithCompletion:(void (^)(void))completion
{
    [self.rootTableViewController reloadTableViewWithCompletion:completion];
}

- (void)scrollRootTableView
{
    // check whether the table view needs to scroll
    if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
        [self.rootTableViewController scrollToCurrentHour];
    }
    [self.rootTableViewController scrollToDate:self.selectedDate];
}

- (void)reloadMonthTableView
{
    [self.monthTableViewController reloadTableView];
}

- (void)scrollMonthTableView
{
    if (PAD) {
        NSInteger midRow = [self.monthTableViewController rowInMiddleOfVisibleRegion];
        [self.monthTableViewController scrollToRow:midRow animated:NO];
    }
    else {
        if (self.monthViewPushedUpDirection == CVRootMonthViewMoveDirectionUp) {
            [self.monthTableViewController scrollToRowForDate:self.selectedDate
                                                     animated:YES
                                               scrollPosition:UITableViewScrollPositionTop];
        }
        else {
            [self.monthTableViewController scrollToRowForDate:[self.selectedDate mt_startOfCurrentMonth]
                                                     animated:YES
                                               scrollPosition:UITableViewScrollPositionTop];
        }
    }
}

- (void)updateSelectionSquare:(BOOL)animated
{
    [self.monthTableViewController reframeRedSelectedDaySquareAnimated:animated];
}

- (void)reloadMonthTableViewRowsForEvent:(EKEvent *)event
{
	NSInteger daysDuration = [event.endingDate mt_daysSinceDate:event.startingDate];
	for (NSInteger i = 0; i <= daysDuration; i++) {
		[self.monthTableViewController reloadRowForDate:[event.startingDate mt_dateDaysAfter:i]];
	}
}




#pragma mark (misc)

- (void)showQuickAddWithDefault:(BOOL)def
                   durationMode:(BOOL)dur
                           date:(NSDate *)date
                          title:(NSString *)title
                           view:(UIView *)view
{
    if (PAD) {
        CVQuickAddViewController_iPhone *quickAddViewController = [[CVQuickAddViewController_iPhone alloc] init];
        quickAddViewController.defaultTitle     = title;
        quickAddViewController.delegate         = self;
        quickAddViewController.startDate        = date;
        quickAddViewController.isDurationMode   = dur;

        // if showing up by the plus button
        if (view == self.redBarPlusButton) {
            quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
            quickAddViewController.popoverArrowDirection = CVPopoverArrowDirectionTopMiddle;
        }

        // if pointing to a row in the root table
        else if (def) {
            quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
            quickAddViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                            CVPopoverArrowDirectionRightMiddle |
                                                            CVPopoverArrowDirectionRightBottom);
        }

        // if pointing at the middle of a day button (because the user long pressed on a day button)
        else {
            quickAddViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideCenter;
            quickAddViewController.popoverArrowDirection = (CVPopoverArrowDirectionLeftMiddle |
                                                            CVPopoverArrowDirectionTopMiddle);
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
    else {
        CVQuickAddViewController_iPhone *quickAddViewController = [[CVQuickAddViewController_iPhone alloc] init];
        quickAddViewController.defaultTitle     = title;
        quickAddViewController.delegate         = self;
        quickAddViewController.startDate        = date;
        quickAddViewController.isDurationMode   = dur;
        [self presentFullScreenModalViewController:quickAddViewController animated:YES];
        if (def) {
            [quickAddViewController displayDefault];
        }
    }
}

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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We need permission!"
                                                        message:(@"This app can't function unless you give it permission "
                                                                 @"to access your calendars: Go to Settings.app > "
                                                                 @"Privacy > Calendars/Reminders and make sure Calvetica is ON")];
    [alertView addButtonWithTitle:@"OK" handler:nil];
    [alertView show];
}

- (void)showWelcomeScreen
{
    // if this is the first time they've ever opened the app, or if the welcome screen
    // was updated, show them the welcome screen
    static BOOL launched = NO;
    if (!launched) {
        [MTMigration migrateToVersion:@"5.0.1" block:^{
            CVWelcomeViewController *welcomeController = [[CVWelcomeViewController alloc] init];
            welcomeController.delegate = self;
            [self presentPageModalViewController:welcomeController animated:YES completion:nil];
        }];
        launched = YES;
    }
}



@end
