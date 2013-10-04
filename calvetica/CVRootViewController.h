//
//  CVRootViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAppDelegate.h"
#import "CVEventCellDataHolder.h"
#import "CVMonthTableViewController.h"
#import "CVViewOptionsPopoverViewController.h"
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
#import "CVGenericReminderViewController_iPhone.h"


typedef enum {
    CVRootTableViewModeFull,
    CVRootTableViewModeAgenda,
    CVRootTableViewModeWeek,
    CVRootTableViewModeDetailedWeek
} CVRootTableViewMode;


@interface CVRootViewController : CVViewController <CVWeekTableViewCellDelegate, CVQuickAddViewControllerDelegate, CVJumpToDateViewControllerDelegate, CVEventCellDelegate, CVAgendaEventCellDelegate, CVEventViewControllerDelegate, CVAlarmPickerViewControllerDelegate, CVManageCalendarsViewControllerDelegate, CVEventSnoozeViewControllerDelegate, CVViewOptionsPopoverViewControllerDelegate, CVSubHourPickerViewControllerDelegate, CVSearchViewControllerDelegate, CVGenericReminderViewControllerDelegate, CVRootTableViewControllerProtocol, CVWelcomeViewControllerDelegate, CVLandscapeWeekViewDelegate>


@property (nonatomic, copy) NSDate *selectedDate;

// used when coming out of background to check if it's a new day so the month buttons
// can be updated to show current day
@property (nonatomic, strong)          NSDate                     *todaysDate;
@property (nonatomic, weak  ) IBOutlet UIControl                  *redBarPlusButton;
@property (nonatomic, weak  ) IBOutlet UIButton                   *showViewOptionsButton;
@property (nonatomic, assign)          CVRootTableViewMode        tableMode;
@property (nonatomic, strong)          CVRootTableViewController  *rootTableViewController;
@property (nonatomic, weak  ) IBOutlet UITableView                *rootTableView;
@property (nonatomic, weak  ) IBOutlet UIButton                   *monthLabelControl;
@property (nonatomic, weak  ) IBOutlet UIView                     *monthTableViewContainer;
@property (nonatomic, weak  ) IBOutlet UIView                     *redBar;
@property (nonatomic, strong)          UIPopoverController        *nativePopoverController;
@property (nonatomic, weak  ) IBOutlet CVMonthTableViewController *monthTableViewController;
@property (nonatomic, weak  ) IBOutlet UIView                     *weekdayTitleBar;
@property (nonatomic, weak  ) IBOutlet UIButton                   *openCalendarsButton;


- (void)showSnoozeDialogForEvent:(EKEvent *)snoozeEvent;
- (void)setWeekDayTitles;
- (void)updateRootTableView;
- (void)loadTableView;
- (void)redrawDotsOnMonthView;
- (void)redrawRowsForEvent:(EKEvent *)event;
- (void)showQuickAddWithDefault:(BOOL)def durationMode:(BOOL)dur date:(NSDate *)date view:(UIView *)view;


#pragma mark - Notifications
- (void)eventStoreChanged;



#pragma mark - Actions
- (IBAction)handleEventTableViewPinchGesture:(UIPinchGestureRecognizer *)sender;
- (IBAction)handleLongPressOnPlusButtonGesture:(UILongPressGestureRecognizer *)gesture;
- (IBAction)handleLongPressOnMonthTitleGesture:(UILongPressGestureRecognizer *)gesture;
- (IBAction)handleSwipeOnTableView:(UISwipeGestureRecognizer *)gesture;
- (IBAction)showCalendarsButtonWasTapped:(id)sender;
- (IBAction)showViewOptionsButtonWasTapped:(id)sender;
- (IBAction)redBarPlusButtonWasTapped:(UITapGestureRecognizer *)gesture;
- (IBAction)monthLabelWasTapped:(UITapGestureRecognizer *)gesture;
- (IBAction)closeSettings:(UIStoryboardSegue *)segue;


@end
