//
//  CVRootViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootViewController.h"
#import "CVRootFullDayTableViewController.h"
#import "CVRootAgendaTableViewController.h"
#import "CVRootWeekTableViewController.h"
#import "CVRootDetailedWeekTableViewController.h"
#import "CVRootCompactWeekTableViewController.h"
#import "CVGenericReminderViewController.h"
#import "CVWelcomeViewController.h"
#import "CVManageCalendarsViewController.h"
#import "CVAllDayAlarmPickerViewController.h"
#import "CVViewOptionsPopoverViewController.h"
#import "CVSubHourPickerViewController.h"
#import "CVLandscapeWeekView.h"
#import "CVSearchViewController.h"
#import "CVCalendarItemCellModel.h"
#import "CVEventStoreNotificationCenter.h"
#import "CVLineButton.h"
#import "UITableView+Utilities.h"
// iPhone
#import "CVLandscapeWeekView_iPhone.h"
// iPad
#import "CVPopoverModalViewController_iPad.h"
#import "CVLandscapeWeekView_iPad.h"
#import "UILabel+Utilities.h"
#import "CVAppDelegate.h"

#define NOTCH_HEIGHT_OFFSET 55
#define WEEKDAY_LABEL_BOTTOM_MARGIN 14


typedef NS_ENUM(NSUInteger, CVRootMonthViewMoveDirection) {
    CVRootMonthViewMoveDirectionDown,
    CVRootMonthViewMoveDirectionUp
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
@property (nonatomic, weak  ) IBOutlet UIView                       *bottomToolbar;
@property (nonatomic, weak  ) IBOutlet CVLineButton                 *twoBarButton;
@property (nonatomic, weak  ) IBOutlet CVLineButton                 *threeBarButton;
@property (nonatomic, weak  ) IBOutlet CVLineButton                 *fourBarButton;
@property (nonatomic, weak  ) IBOutlet CVLineButton                 *fiveBarButton;
@property (nonatomic, weak  ) IBOutlet CVLineButton                 *settingsButton;
@property (nonatomic, weak  ) IBOutlet CVLineButton                 *searchButton;

// iPhone
@property (nonatomic, assign)          CVRootMonthViewMoveDirection monthViewPushedUpDirection;

// iPad
@property (nonatomic, weak  ) IBOutlet UILabel                      *redBarMonthLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                      *redBarYearLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                      *grayBarWeekdayLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                      *grayBarDateLabel;

// Week number (common to all views)
@property (nonatomic, strong)          UILabel                      *weekNumberLabel;
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
    
    if ([CVAppDelegate hasNotch]) {
        _monthTableViewContainer.y = NOTCH_HEIGHT_OFFSET;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.monthTableViewController.delegate  = nil;
    self.rootTableViewController.delegate   = nil;
    self.rootTableView.delegate             = nil;
    self.rootTableView.dataSource           = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateSelectionSquare:NO];
}

- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    if ([CVAppDelegate hasNotch]) {
        CGFloat topHeight = [self safeAreaTopHeight];
        _monthTableViewContainer.y = topHeight;
        [self updateWeekdayTitleLabels];
        [self updateLayoutAnimated:NO];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];

    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        self.rootTableView.backgroundColor = patentedWhite();
        self.rootTableView.separatorColor = patentedWhite();
        [self.rootTableViewController updateAppearanceForTraitChange];
        [self.rootTableView reloadData];
        self.weekNumberLabel.textColor = patentedBlack();
        self.weekNumberLabel.backgroundColor = patentedWhite();
    }
}

- (void)viewDidAppearAfterLoad:(BOOL)animated
{
    [super viewDidAppearAfterLoad:animated];

    if (![EKEventStore isPermissionGranted]) {
        [[EKEventStore permissionStore] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                [MTq main:^{
                    [self notifyOfNeededPermission];
                }];
            }
            [[EKEventStore permissionStore] requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                [MTq main:^{
                    if (!granted) {
                        [self notifyOfNeededPermission];
                    }
                    [EKEventStore setPermissionGranted:granted];
                    self.selectedDate = self.todaysDate;
                    [self refreshUIAnimated:NO];
                    [self showWelcomeScreen];
                }];
            }];
        }];
    }

    [self updateLayoutAnimated:NO];
}

#pragma mark (rotation)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (PAD) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

// iPad
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (PAD) {
        self.monthTableViewController.selectedDayView.hidden = YES;
        for (CVPopoverModalViewController_iPad *controller in self.popoverModalViewControllers) {
            controller.view.hidden = YES;
        }
    }
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.monthTableViewController.selectedDayView.hidden = NO;
        
        [self updateWeekdayTitleLabels];
        [self updateLayoutAnimated:NO];
        [self reloadMonthTableView];
        [self scrollMonthTableViewAnimated:NO];
        [self updateSelectionSquare:NO];
        
        if (PAD) {
            for (CVPopoverModalViewController_iPad *popoverController in self.popoverModalViewControllers) {
                popoverController.view.hidden = NO;
                [popoverController layout];
            }
        }
    }];
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
        CVSearchViewController *searchViewController = [segue destinationViewController];
        searchViewController.delegate = self;
    }
}

- (IBAction)closeSettings:(UIStoryboardSegue *)segue
{
    [self refreshUIBasedOnChangedSettings];
	if (PAD) {
		if (self.nativePopoverController) {
			[self.nativePopoverController dismissPopoverAnimated:YES];
			self.nativePopoverController = nil;
		}
	}
	else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
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
            [self scrollMonthTableViewAnimated:YES];
            [self reloadRootTableViewWithCompletion:^{
                [self scrollRootTableViewAnimated:YES];
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
    [self scrollMonthTableViewAnimated:YES];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:YES];
    }];
    [self updateSelectionSquare:YES];
    [self updateMonthAndDayLabels];
}

- (IBAction)showCalendarsButtonWasTapped:(id)sender
{
    CVManageCalendarsViewController *manageCalendarsController = [CVManageCalendarsViewController new];
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
    viewOptionsPopover.popoverBackdropColor = patentedDarkGray();
    if (PAD) {
        viewOptionsPopover.attachPopoverArrowToSide = CVPopoverModalAttachToSideBottom;
    }
    else {
        viewOptionsPopover.attachPopoverArrowToSide = CVPopoverModalAttachToSideRight;
    }
    [self presentPopoverModalViewController:viewOptionsPopover forView:sender animated:YES];
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
    CVEventDayViewController *eventDayViewController = [[CVEventDayViewController alloc] init];
    eventDayViewController.initialDate = self.selectedDate;

    CVJumpToDateViewController *jumpToDateController = [[CVJumpToDateViewController alloc]
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

- (IBAction)twoBarButtonWasTapped:(id)sender
{
    self.rootTableMode = CVRootTableViewModeFull;
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:NO];
    }];
}

- (IBAction)threeBarButtonWasTapped:(id)sender
{
    self.rootTableMode = CVRootTableViewModeAgenda;
    [self reloadRootTableViewWithCompletion:nil];
}

- (IBAction)fourBarButtonTapped:(id)sender
{
    self.rootTableMode = CVRootTableViewModeWeek;
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:NO];
    }];
}

- (IBAction)fiveBarButtonWasTapped:(id)sender
{
    self.rootTableMode = CVRootTableViewModeDetailedWeek;
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:NO];
    }];
}

- (IBAction)handleEventTableViewPinchGesture:(UIPinchGestureRecognizer *)sender
{
	if (sender.state != UIGestureRecognizerStateEnded) return;

    if (sender.scale < 1) {
        if (self.rootTableMode < CVRootTableViewModeCompactWeek) {
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
    else if (self.rootTableMode == CVRootTableViewModeCompactWeek) {
        [UIApplication showBezelWithTitle:@"Compact Week"];
    }

    [self reloadRootTableViewWithCompletion:nil];
}

- (IBAction)settingsButtonWasTapped:(id)sender
{
    [self openSettingsWithCompletionHandler:nil];
}

- (IBAction)searchButtonWasTapped:(id)sender
{
    [self openSearch];
}



#pragma mark (iphone)

- (IBAction)monthTableViewWasSwiped:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateEnded) return;

    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.monthViewPushedUpDirection == CVRootMonthViewMoveDirectionDown) {
            self.selectedDate = [self.selectedDate mt_oneMonthNext];
            [self updateLayoutAnimated:YES];
        }
        else {
            self.selectedDate = [self.selectedDate mt_dateWeeksAfter:2];
            [self updateLayoutAnimated:NO];
        }
        [self updateSelectionSquare:YES];
        [self updateMonthAndDayLabels];
        [self scrollMonthTableViewAnimated:YES];
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:YES];
        }];
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.monthViewPushedUpDirection == CVRootMonthViewMoveDirectionDown) {
            self.selectedDate = [self.selectedDate mt_oneMonthPrevious];
            [self updateLayoutAnimated:YES];
        }
        else {
            self.selectedDate = [self.selectedDate mt_dateWeeksBefore:2];
            [self updateLayoutAnimated:NO];
        }
        [self updateSelectionSquare:YES];
        [self updateMonthAndDayLabels];
        [self scrollMonthTableViewAnimated:YES];
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:YES];
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
	[self scrollMonthTableViewAnimated:YES];
    [self updateSelectionSquare:YES];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:YES];
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
    [self updateWeekNumberLabel];
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
	CVEventSnoozeViewController *eventSnoozeController = [[CVEventSnoozeViewController alloc] init];
	eventSnoozeController.event = snoozeEvent;
	eventSnoozeController.delegate = self;

	// hide the keyboard if its up
	[self.view endEditing:YES];

	[self presentFullScreenModalViewController:eventSnoozeController animated:YES];
}

- (void)refreshUIAnimated:(BOOL)animated
{
    [self reloadMonthTableView];
    [self scrollMonthTableViewAnimated:animated];
    [self updateSelectionSquare:animated];
    [self updateLayoutAnimated:animated];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:animated];
    }];
    [self updateWeekdayTitleLabels];
    [self updateMonthAndDayLabels];
    [self updateWeekNumberLabel];
}





#pragma mark - DELEGATE root table view

- (void)rootTableViewController:(CVRootTableViewController *)controller didScrollToDay:(NSDate *)date
{
    self.selectedDate = date;
    [self updateSelectionSquare:YES];
    [self scrollMonthTableViewAnimated:YES];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                           cell:(UITableViewCell *)cell
                    updatedItem:(EKCalendarItem *)item
{
    NSDate *date = item.mys_date ?: [NSDate date];
    [self.monthTableViewController reloadRowForDate:date];
    [self reloadRootTableViewWithCompletion:nil];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     tappedCell:(UITableViewCell *)cell
                   calendarItem:(EKCalendarItem *)calendarItem
{
    if (calendarItem && calendarItem.isEvent) {
        CVEventViewController *eventViewController = [[CVEventViewController alloc] initWithEvent:(EKEvent *)calendarItem
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
    }
    
    else if (calendarItem && calendarItem.isReminder) {
        if (calendarItem.isReminder) {
            NSIndexPath *ip         = [self.rootTableView indexPathForCell:cell];
            EKReminder *reminder    = (EKReminder *)calendarItem;
            reminder.completed      = !reminder.completed;
            [reminder saveWithError:nil];
            [self.rootTableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

    else if ([cell isKindOfClass:[CVEventCell class]]) {
        [self showQuickAddWithDefault:YES
                         durationMode:YES
                                 date:[(CVEventCell *)cell date]
                                title:nil
                                 view:cell];
    }
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     tappedCell:(UITableViewCell *)cell
                         onTime:(NSDate *)time
                           view:(UIView *)view
{
    CVSubHourPickerViewController *subHourPickerViewController = [[CVSubHourPickerViewController alloc]
                                                                  initWithDate:time];
    subHourPickerViewController.delegate = self;
    subHourPickerViewController.popoverBackdropColor = patentedRed;
    subHourPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideRight;
    subHourPickerViewController.popoverArrowDirection = (CVPopoverArrowDirectionLeftTop |
                                                         CVPopoverArrowDirectionLeftMiddle |
                                                         CVPopoverArrowDirectionLeftBottom);
    [self presentPopoverModalViewController:subHourPickerViewController
                                    forView:view
                                   animated:YES];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                longPressedCell:(UITableViewCell *)cell
                   calendarItem:(EKCalendarItem *)calendarItem
{
    if ([cell isKindOfClass:[CVEventCell class]]) {
        [self showQuickAddWithDefault:YES
                         durationMode:YES
                                 date:[(CVEventCell *)cell date]
                                title:nil
                                 view:cell];
    }
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     swipedCell:(UITableViewCell *)cell
                        forItem:(EKCalendarItem *)calendarItem
                    inDirection:(CVCalendarItemCellSwipedDirection)direction
{
	if (direction == CVCalendarItemCellSwipedDirectionLeft) {
		self.selectedDate = [self.selectedDate mt_oneDayNext];
	}
	else {
        self.selectedDate = [self.selectedDate mt_oneDayPrevious];
	}
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:YES];
    }];
    [self updateSelectionSquare:YES];
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     tappedCell:(UITableViewCell *)cell
                      alarmView:(UIView *)alarmView
                   calendarItem:(EKCalendarItem *)calendarItem
{
    if (calendarItem.mys_isAllDay) {
        CVAllDayAlarmPickerViewController *alarmPickerViewController = [[CVAllDayAlarmPickerViewController alloc] init];
        alarmPickerViewController.delegate                  = self;
        alarmPickerViewController.calendarItem              = calendarItem;
        alarmPickerViewController.popoverBackdropColor      = patentedRed;
        alarmPickerViewController.attachPopoverArrowToSide  = CVPopoverModalAttachToSideLeft;
        alarmPickerViewController.popoverArrowDirection     = (CVPopoverArrowDirectionRightTop |
                                                               CVPopoverArrowDirectionRightMiddle |
                                                               CVPopoverArrowDirectionRightBottom);
        [self presentPopoverModalViewController:alarmPickerViewController
                                        forView:alarmView
                                       animated:YES];
    } else {
        CVAlarmPickerViewController *alarmPickerViewController = [[CVAlarmPickerViewController alloc] init];
        alarmPickerViewController.delegate = self;
        alarmPickerViewController.calendarItem = calendarItem;
        alarmPickerViewController.popoverBackdropColor = patentedRed;
        alarmPickerViewController.attachPopoverArrowToSide = CVPopoverModalAttachToSideLeft;
        alarmPickerViewController.popoverArrowDirection = (CVPopoverArrowDirectionRightTop |
                                                           CVPopoverArrowDirectionRightMiddle |
                                                           CVPopoverArrowDirectionRightBottom);
        [self presentPopoverModalViewController:alarmPickerViewController
                                        forView:alarmView animated:YES];
    }
}

- (void)rootTableViewController:(CVRootTableViewController *)controller
             tappedDeleteOnCell:(CVEventCell *)cell
                   calendarItem:(EKCalendarItem *)calendarItem
{
	// find the cell of the event that was deleted. If it was not on an even hour its agenda mode, delete the cell.
    NSIndexPath *indexPath = [self.rootTableView indexPathForRowContainingView:cell];

	if (calendarItem.isEvent) {
        EKEvent *eventToDelete = (EKEvent *)calendarItem;

        [self.rootTableViewController removeCalendarItem:calendarItem];
        [eventToDelete removeThenDoActionBlock:^(void) {
            if (![eventToDelete.startDate mt_isStartOfAnHour] ||
                calendarItem.mys_isAllDay ||
                self.rootTableMode != CVRootTableViewModeFull)
            {
                [self.rootTableView beginUpdates];
				[self.rootTableView deleteRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                [self.rootTableView endUpdates];
            }
            else {
                [self.rootTableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
            }
        } cancelBlock:^(void) {}];

        // if it repeats we need to reload all the rows in ase dots for this week appear on other weeks
        if (eventToDelete.hasRecurrenceRules || ![eventToDelete fitsWithinWeekOfDate:self.selectedDate]) {
            [self.monthTableViewController reloadTableView];
        } else {
            [self.monthTableViewController reloadRowForDate:self.selectedDate];
        }
    }
}





#pragma mark - DELEGATE month table view

- (void)monthTableViewController:(CVMonthTableViewController *)controller
                      tappedCell:(CVWeekTableViewCell *)cell
                          onDate:(NSDate *)date
{
    BOOL monthChanged = ![date mt_isWithinSameMonth:self.selectedDate];
    self.selectedDate = date;
    [self updateSelectionSquare:YES];
    [self updateMonthAndDayLabels];
    [self reloadRootTableViewWithCompletion:^{
        [self scrollRootTableViewAnimated:YES];
    }];
    if (!PAD) {
        if (monthChanged) {
            [self updateLayoutAnimated:YES];
        }
        [self scrollMonthTableViewAnimated:YES];
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

- (void)manageCalendarsViewController:(CVManageCalendarsViewController *)controller
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

- (void)quickAddViewController:(CVQuickAddViewController *)controller
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

- (void)jumpToDateViewController:(CVJumpToDateViewController *)controller
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
    [self.rootTableView reloadData];
}




#pragma mark - DELEGATE snooze view controller

- (void)eventSnoozeViewController:(CVEventSnoozeViewController *)controller
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
                                               scrollPosition:UITableViewScrollPositionTop];
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
            [self scrollRootTableViewAnimated:NO];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionAgendaView) {
        self.rootTableMode = CVRootTableViewModeAgenda;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:NO];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionWeekView) {
        self.rootTableMode = CVRootTableViewModeWeek;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:NO];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionDetailedWeekView) {
        self.rootTableMode = CVRootTableViewModeDetailedWeek;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:NO];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionCompactWeekView) {
        self.rootTableMode = CVRootTableViewModeCompactWeek;
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:NO];
        }];
    }

    else if (option == CVViewOptionsPopoverOptionSearch) {
        [self openSearch];
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
    [self dismissPopoverModalViewControllerAnimated:YES];
    [self showQuickAddWithDefault:YES
					 durationMode:YES
							 date:date
                            title:nil
							 view:self.redBarPlusButton];
}

- (void)subHourPicker:(CVSubHourPickerViewController *)subHourPicker
  didFinishWithResult:(CVSubHourPickerViewControllerResult)result
{
    [self dismissPopoverModalViewControllerAnimated:YES];
}




#pragma mark - DELEGATE search view controller

- (void)searchViewController:(CVSearchViewController *)searchViewController
         didFinishWithResult:(CVSearchViewControllerResult)result
{
    if (!PAD) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self dismissPopoverModalViewControllerAnimated:YES];
    }
}

- (void)searchViewController:(CVSearchViewController *)controller tappedCell:(CVSearchEventCell *)cell
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
        [self scrollMonthTableViewAnimated:YES];
        [self reloadRootTableViewWithCompletion:^{
            [self scrollRootTableViewAnimated:YES];
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

            if ([CVAppDelegate hasNotch]) {
                [self performSegueWithIdentifier:@"WeekViewSegue" sender:self];
            }
            
        }
    }
}

- (void)eventStoreChanged:(NSNotification *)notif
{
    CVEventStoreNotification *notification = [notif object];

    if (notification.source == CVNotificationSourceExternal) {
        [[EKEventStore sharedStore] clearRemindersCacheAndReloadWithCompletion:^{
            [MTq main:^{
                [self reloadMonthTableView];
                [self reloadRootTableViewWithCompletion:nil];
            }];
        }];
        return;
    }

    EKCalendarItem *calendarItem = notification.calendarObject;

    if (calendarItem) {
        if (calendarItem.isEvent) {
            EKEvent *event = (EKEvent *)calendarItem;
            [self reloadMonthTableViewRowsForEvent:event];
        }
        else if (notification.changeType != CVNotificationChangeTypeUpdate) {
            [[EKEventStore sharedStore] clearRemindersCacheAndReloadWithCompletion:^{
                [MTq main:^{
                    [self reloadMonthTableView];
                    [self reloadRootTableViewWithCompletion:nil];
                }];
            }];
        }
    }
}

- (void)sharedSettingsChanged
{
    [self refreshUIBasedOnChangedSettings];
}




#pragma mark - Private

- (CGFloat)safeAreaTopHeight
{
    CGFloat safeAreaTop = self.view.window.safeAreaInsets.top;
    if (safeAreaTop > 20) {
        // Device has notch or Dynamic Island - use safe area plus margin for weekday labels
        return safeAreaTop + WEEKDAY_LABEL_BOTTOM_MARGIN;
    }
    return 0;
}

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

//        UISwipeGestureRecognizer *swipeDownOnMonthTableView             = [[UISwipeGestureRecognizer alloc]
//                                                                           initWithTarget:self
//                                                                           action:@selector(monthTableViewWasSwiped:)];
//        swipeDownOnMonthTableView.direction                             = UISwipeGestureRecognizerDirectionDown;
//        [self.monthTableViewContainer addGestureRecognizer:swipeDownOnMonthTableView];

        UISwipeGestureRecognizer *swipeLeftOnMonthTableView             = [[UISwipeGestureRecognizer alloc]
                                                                           initWithTarget:self
                                                                           action:@selector(monthTableViewWasSwiped:)];
        swipeLeftOnMonthTableView.direction                             = UISwipeGestureRecognizerDirectionLeft;
        [self.monthTableViewContainer addGestureRecognizer:swipeLeftOnMonthTableView];

//        UISwipeGestureRecognizer *swipeUpOnMonthTableView               = [[UISwipeGestureRecognizer alloc]
//                                                                           initWithTarget:self
//                                                                           action:@selector(monthTableViewWasSwiped:)];
//        swipeUpOnMonthTableView.direction                               = UISwipeGestureRecognizerDirectionUp;
//        [self.monthTableViewContainer addGestureRecognizer:swipeUpOnMonthTableView];

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
                                             selector:@selector(eventStoreChanged:)
                                                 name:CVEventStoreChangedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sharedSettingsChanged)
                                                 name:MYSSharedSettingsChangedNotification
                                               object:nil];
}

- (void)setupDefaults
{
    // if the view is not scrollable, lock it
    if (!PAD && !PREFS.iPhoneScrollableMonthView) {
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
    [self setupWeekNumberLabel];
}

- (void)setupWeekNumberLabel
{
    self.weekNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weekNumberLabel.textAlignment = NSTextAlignmentRight;
    self.weekNumberLabel.textColor = patentedBlack();
    self.weekNumberLabel.backgroundColor = patentedWhite();
    self.weekNumberLabel.opaque = YES;
    self.weekNumberLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.weekNumberLabel];
}

- (void)updateWeekNumberLabel
{
    CGFloat labelHeight = 20;
    CGFloat rightPadding = 8;

    if (!PREFS.showWeekNumbers) {
        self.weekNumberLabel.hidden = YES;
        self.rootTableView.contentInset = UIEdgeInsetsZero;
        return;
    }

    self.weekNumberLabel.hidden = NO;
    NSInteger weekOfYear = [self.selectedDate mt_weekOfYear];
    self.weekNumberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Week %1$i",
                                                                              @"The week number of a selected date. %1$i: the week number."),
                                  (int)weekOfYear];

    // Position at top of root table view area, right-aligned
    CGRect frame = CGRectMake(0,
                              self.rootTableView.frame.origin.y,
                              self.view.bounds.size.width - rightPadding,
                              labelHeight);
    self.weekNumberLabel.frame = frame;

    // Add content inset so table content doesn't go behind the label
    self.rootTableView.contentInset = UIEdgeInsetsMake(labelHeight, 0, 0, 0);
}

- (void)setUpMonthTableViewController
{
    self.monthTableViewController.delegate      = self;
    self.monthTableViewController.startDate     = [[self.todaysDate mt_dateWeeksBefore:100] mt_startOfCurrentWeek];
    self.monthTableViewController.selectedDate  = self.todaysDate;
}

- (void)setupRootTableViewController
{
    self.rootTableMode = PREFS.localRootTableViewMode ?: CVRootTableViewModeAgenda;
    [self.rootTableView reloadData];
}

#pragma mark (iphone)

- (void)updateLayoutAnimated:(BOOL)animated
{
    CGFloat safeAreaTop = [self safeAreaTopHeight];
    if ([CVAppDelegate hasNotch] && safeAreaTop > 0) {
        self.weekdayTitleBar.height = safeAreaTop;
    }
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
            r.origin.y = ((numberOfRows * h) + self.weekdayTitleBar.bounds.size.height) + 1;
            r.size.height = self.view.height - self.rootTableView.y - 1;// - self.bottomToolbar.height;
            self.rootTableView.frame = r;
        };

        void (^completion)(void) = ^{
            [self moveMonthView:self.monthViewPushedUpDirection animated:animated];
            [self updateWeekNumberLabel];
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
    [self updateWeekNumberLabel];
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
        rootTableView.y         = monthTableView.y + monthTableView.height + 1;
        rootTableView.height    = self.view.height - rootTableView.y - 1;// - self.bottomToolbar.height;
    };

    void (^completion)(void) = ^{
        [self updateSelectionSquare:NO];
        [self updateWeekNumberLabel];
    };

    if (animated) {
        BOOL isUp = direction == CVRootMonthViewMoveDirectionUp;
        [UIView mt_animateWithDuration:(isUp ? 0.3 : 0.5)
                        timingFunction:(isUp ? kMTEaseOutBack : kMTEaseOutBounce)
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^{
                                animations();
                                [self updateWeekNumberLabel];
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
        _redBarYearLabel.text       = [NSString stringWithFormat:@"%lu", (unsigned long)[self.selectedDate mt_year]];
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
    PREFS.localRootTableViewMode = self.rootTableMode;

    if (self.rootTableViewController != nil) {
        [self.rootTableViewController viewDidDisappear:NO];
    }

    if (self.rootTableMode == CVRootTableViewModeFull) {
        self.rootTableViewController = [CVRootFullDayTableViewController new];
    }

    else if (self.rootTableMode == CVRootTableViewModeAgenda) {
        self.rootTableViewController = [CVRootAgendaTableViewController new];
    }

    else if (self.rootTableMode == CVRootTableViewModeWeek) {
        self.rootTableViewController = [CVRootWeekTableViewController new];
    }

    else if (self.rootTableMode == CVRootTableViewModeDetailedWeek) {
        self.rootTableViewController = [CVRootDetailedWeekTableViewController new];
    }
    else if (self.rootTableMode == CVRootTableViewModeCompactWeek) {
        self.rootTableViewController = [CVRootCompactWeekTableViewController new];
    }
    else {
        self.rootTableViewController = [CVRootAgendaTableViewController new];
    }

    self.rootTableViewController.delegate       = self;
    self.rootTableViewController.selectedDate   = self.selectedDate;
    self.rootTableViewController.tableView      = self.rootTableView;
}

- (void)updateWeekdayTitleLabels
{
    // set weekday labels
    CGFloat safeAreaTop = self.view.window.safeAreaInsets.top;
    for (int i = 0; i < 7; i++) {
        UILabel *l = (UILabel *)[self.weekdayTitleBar viewWithTag:WEEKDAY_TITLES_OFFSET + i];
        BOOL abbr = (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
                     self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
        NSString *weekDayAbbr = [[NSDate stringWithWeekDayAbbreviated:abbr forWeekdayIndex:i+1] uppercaseString];
        l.text = weekDayAbbr;
        if ([CVAppDelegate hasNotch] && safeAreaTop > 20) {
            // Position labels just below the safe area (notch/Dynamic Island)
            l.y = safeAreaTop;
        }
    }
}

- (void)reloadRootTableViewWithCompletion:(void (^)(void))completion
{
    [self.rootTableViewController reloadTableViewWithCompletion:completion];
}

- (void)scrollRootTableViewAnimated:(BOOL)animated
{
    // check whether the table view needs to scroll
    if ([self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
        [self.rootTableViewController scrollToCurrentHourAnimated:animated];
    }
    [self.rootTableViewController scrollToDate:self.selectedDate animated:animated];
}

- (void)reloadMonthTableView
{
    [self.monthTableViewController reloadTableView];
}

- (void)scrollMonthTableViewAnimated:(BOOL)animated
{
    if (PAD) {
        [self.monthTableViewController scrollToRowForDate:self.selectedDate
                                                 animated:animated
                                           scrollPosition:UITableViewScrollPositionTop];
    }
    else {
        if (self.monthViewPushedUpDirection == CVRootMonthViewMoveDirectionUp) {
            [self.monthTableViewController scrollToRowForDate:self.selectedDate
                                                     animated:animated
                                               scrollPosition:UITableViewScrollPositionTop];
        }
        else {
            [self.monthTableViewController scrollToRowForDate:[self.selectedDate mt_startOfCurrentMonth]
                                                     animated:animated
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

- (void)refreshUIBasedOnChangedSettings
{
    NSArray *changedSettings = [[CVSharedSettings sharedSettings] changedPropertyNames];

    if ([changedSettings containsObject:@"remindersEnabled"]) {
        [self reloadMonthTableView];
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"timezoneSupportEnabled"] ||
        [changedSettings containsObject:@"timeZoneName"])
    {
        if (PREFS.timeZoneName) {
            [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:PREFS.timeZoneName]];
        }
    }

    if ([changedSettings containsObject:@"twentyFourHourFormat"]) {
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"dotsOnlyMonthView"]) {
        [self reloadMonthTableView];
    }

    if ([changedSettings containsObject:@"iPhoneScrollableMonthView"]) {
        if (PREFS.iPhoneScrollableMonthView && !PAD) {
            self.monthTableViewController.tableView.scrollEnabled = YES;
        }
        else {
            self.monthTableViewController.tableView.scrollEnabled = NO;
        }
    }

    if ([changedSettings containsObject:@"showDurationOnReadOnlyEvents"]) {
        [self reloadMonthTableView];
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"hiddenEventCalendarIdentifiers"]) {
        [self reloadMonthTableView];
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"customCalendarColors"]) {
        [self reloadMonthTableView];
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"customCalendarColors"]) {
        [self reloadMonthTableView];
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"weekStartsOnWeekday"]) {
        [NSDate mt_setFirstDayOfWeek:PREFS.weekStartsOnWeekday];
        [self.monthTableViewController resetStartDate];
        [self reloadMonthTableView];
        [self reloadRootTableViewWithCompletion:nil];
        [self updateWeekdayTitleLabels];
    }

    if ([changedSettings containsObject:@"dayStartHour"] ||
        [changedSettings containsObject:@"dayEndHour"])
    {
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"eventDetailsSubtitleTextPriority"]) {
        [self reloadRootTableViewWithCompletion:nil];
    }

    if ([changedSettings containsObject:@"showWeekNumbers"]) {
        [self updateWeekNumberLabel];
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
        CVQuickAddViewController *quickAddViewController = [[CVQuickAddViewController alloc] init];
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
        CVQuickAddViewController *quickAddViewController = [[CVQuickAddViewController alloc] init];
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
    PSPDFAlertView *alertView = [[PSPDFAlertView alloc] initWithTitle:@"We need permission!"
                                                              message:(@"This app can't function unless you give it permission "
                                                                       @"to access your calendars: Go to Settings.app > "
                                                                       @"Privacy > Calendars/Reminders and make sure Calvetica is ON")];
    [alertView addButtonWithTitle:@"OK" block:nil];
    [alertView show];
}

- (void)showWelcomeScreen
{
    // if this is the first time they've ever opened the app, or if the welcome screen
    // was updated, show them the welcome screen
    static BOOL launched = NO;
    if (!launched) {
        [MTMigration applicationUpdateBlock:^{
            CVWelcomeViewController *welcomeController = [[CVWelcomeViewController alloc] init];
            welcomeController.delegate = self;
            [self presentPageModalViewController:welcomeController
                                        animated:YES
                                      completion:nil];
        }];
        launched = YES;
    }
}

- (void)openSearch
{
    if (PAD) {
        CVSearchViewController *searchViewController = [[CVSearchViewController alloc] init];
        searchViewController.delegate = self;
        [self presentPopoverModalViewController:searchViewController
                                        forView:self.monthLabelControl
                                       animated:YES];
    }
    else {
        [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    }
}


@end
