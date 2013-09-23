//
//  CVRootViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAppDelegate.h"
#import "CVEventCellDataHolder.h"
#import "CVReminderCellDataHolder.h"
#import "CVMonthTableViewController.h"
#import "CVReminderViewController_iPhone.h"
#import "CVViewOptionsPopoverViewController.h"
#import "CVGenericReminderViewController_iPhone.h"
#import "CVSubHourPickerViewController.h"
#import "CVEventDot.h"
#import "CVViewController.h"
#import "CVQuickAddViewController_iPhone.h"
#import "CVJumpToDateViewController_iPhone.h"
#import "CVEventViewController_iPhone.h"
#import "CVAllDayAlarmPickerViewController.h"
#import "CVManageCalendarsViewController_iPhone.h"
#import "CVEventSnoozeViewController_iPhone.h"
#import "CVSearchViewController_iPhone.h"
#import "NSDate+ViewHelpers.h"
#import "EKEvent+Utilities.h"
#import "UITableViewCell+Nibs.h"
#import "CVEventCell.h"
#import "dimensions.h"
#import "times.h"
#import "dimensions.h"
#import "CVRootTableViewController.h"
#import "CVWelcomeViewController.h"
#import "CVFAQViewController.h"
#import "CVGestureHowToViewController.h"
#import "CVLandscapeWeekView.h"
#import "CVAgendaEventCell.h"
#import "CVEventReminderToggleButton.h"


typedef enum {
    CVRootViewControllerModeEvents,
    CVRootViewControllerModeReminders
} CVRootViewControllerMode;


typedef enum {
    CVRootTableViewModeFull,
    CVRootTableViewModeAgenda,
    CVRootTableViewModeWeek
} CVRootTableViewMode;


@interface CVRootViewController : CVViewController <CVWeekTableViewCellDelegate, CVQuickAddViewControllerDelegate, CVJumpToDateViewControllerDelegate, CVEventCellDelegate, CVAgendaEventCellDelegate, CVReminderCellDelegate, CVEventViewControllerDelegate, CVAlarmPickerViewControllerDelegate, CVManageCalendarsViewControllerDelegate, CVEventSnoozeViewControllerDelegate, CVViewOptionsPopoverViewControllerDelegate, CVSubHourPickerViewControllerDelegate, CVSearchViewControllerDelegate, CVReminderViewControllerDelegate, CVGenericReminderViewControllerDelegate, CVRootTableViewControllerProtocol, CVWelcomeViewControllerDelegate, CVLandscapeWeekViewDelegate>


@property (nonatomic, copy) NSDate *selectedDate;

// used when coming out of background to check if it's a new day so the month buttons
// can be updated to show current day
@property (nonatomic, strong) NSDate *todaysDate;

@property (nonatomic, strong) IBOutlet UIImageView                 *vignetteBackground;
@property (nonatomic, strong) IBOutlet UIControl                   *redBarPlusButton;
@property (nonatomic, strong) IBOutlet CVEventReminderToggleButton *toggleModeButton;
@property (nonatomic, strong) IBOutlet UIButton                    *showViewOptionsButton;
@property (nonatomic, assign)          CVRootViewControllerMode    mode;
@property (nonatomic, assign)          CVRootTableViewMode         tableMode;
@property (nonatomic, strong)          CVRootTableViewController   *rootTableViewController;
@property (nonatomic, strong) IBOutlet UITableView                 *rootTableView;
@property (nonatomic, strong) IBOutlet UIButton                    *monthLabelControl;
@property (nonatomic, weak  ) IBOutlet UIView                      *monthTableViewContainer;
@property (nonatomic, assign)          NSInteger                   reminderAddPlusButtonCount;
@property (nonatomic, strong) IBOutlet UIView                      *redBar;
@property (nonatomic, strong)          UIPopoverController         *nativePopoverController;
@property (nonatomic, strong) IBOutlet CVMonthTableViewController  *monthTableViewController;
@property (nonatomic, strong) IBOutlet UIView                      *weekdayTitleBar;


#pragma mark - Methods
- (void)showNewReminderScreenWithDate:(NSDate *)date;
- (void)showSnoozeDialogForEvent:(EKEvent *)snoozeEvent;
- (void)toggleRemindersEventsViewMode;
- (void)setWeekDayTitles;
- (void)updateRootTableView;
- (void)loadTableView;
- (void)toggleDetailOutlinePortraitWeekViews;
- (void)redrawDotsOnMonthView;
- (void)redrawRowsForEvent:(EKEvent *)event;
- (void)redrawRowsForReminder:(EKReminder *)reminder;


#pragma mark - Notifications
- (void)eventStoreChanged;
- (void)reminderStoreChanged;
- (void)pocketLintSyncDidFinish;


#pragma mark - Actions
- (IBAction)handleEventTableViewPinchGesture:(UIPinchGestureRecognizer *)sender;
- (IBAction)handleLongPressOnPlusButtonGesture:(UILongPressGestureRecognizer *)gesture;
- (IBAction)handleLongPressOnMonthTitleGesture:(UILongPressGestureRecognizer *)gesture;
- (IBAction)handleSwipeOnTableView:(UISwipeGestureRecognizer *)gesture;
- (IBAction)showViewOptionsButtonWasTapped:(id)sender;
- (IBAction)redBarPlusButtonWasTapped:(UITapGestureRecognizer *)gesture;
- (IBAction)toggleRemindersEventsViewIconTapped:(id)sender;
- (IBAction)monthLabelWasTapped:(UITapGestureRecognizer *)gesture;

- (IBAction)closeSettings:(UIStoryboardSegue *)segue;


@end
