//
//  CVEventDetailsViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/5/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <EventKitUI/EventKitUI.h>
#import "EKCalendar+Utilities.h"
#import "EKRecurrenceDayOfWeek+Utilities.h"
#import "EKRecurrenceRule+Utilities.h"
#import "CVTextView.h"
#import "CVButton.h"
#import "CVNavigationController.h"
#import "CVEventDetailsNotesViewController_iPhone.h"
#import "CVEventDetailsLocationViewController_iPhone.h"
#import "CVCalendarPickerTableViewController.h"
#import "CVEventDetailsRepeatViewController_iPhone.h"
#import "CVEventDetailsRepeatDailyViewController_iPhone.h"
#import "CVEventDetailsRepeatWeeklyViewController_iPhone.h"
#import "CVEventDetailsRepeatMonthlyViewController_iPhone.h"
#import "CVEventDetailsRepeatYearlyViewController_iPhone.h"
#import "CVEventDetailsPeopleTableViewController_iPhone.h"
#import "CVRoundedToggleButton.h"
#import "strings.h"
#import "CVSlideLockControl.h"
#import "UIView+nibs.h"
#import "SCEventDetailsAllDayAlarmPicker.h"
#import "SCEventDetailsAlarmPicker.h"
#import "EKEvent+Utilities.h"
#import "CVViewController.h"

typedef enum {
    CVEventDetailsResultDeleted
} CVEventDetailsResult;


@protocol CVEventDetailsViewControllerDelegate;


@interface CVEventDetailsViewController_iPhone : CVViewController <UITextViewDelegate, CVTextViewDelegate, CVEventDetailsNotesViewControllerDelegate, CVEventDetailsLocationViewControllerDelegate, CVCalendarPickerTableViewControllerDelegate, CVEventDetailsRecurrenceDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, CVEventDetailsPeopleTableViewController_iPhoneDelegate, EKEventEditViewDelegate>

@property (nonatomic, weak  ) id<CVEventDetailsViewControllerDelegate>       delegate;
@property (nonatomic, strong) UIViewController                               *rootController;
@property (nonatomic, strong) EKEvent                                        *event;
@property (nonatomic, strong) CVCalendarPickerTableViewController            *calendarTableViewController;
@property (nonatomic, strong) CVEventDetailsPeopleTableViewController_iPhone *peopleTableViewController;
@property (nonatomic, strong) CVSlideLockControl                             *deleteSlideLock;
@property (nonatomic, strong) SCEventDetailsAlarmPicker                      *alarmPicker;
@property (nonatomic, strong) SCEventDetailsAllDayAlarmPicker                *allDayAlarmPicker;

- (id)initWithEvent:(EKEvent *)initEvent;

- (void)adjustLayoutOfBlocks;
- (void)configureAvailabilityButtons;
- (void)configureRepeatButtons;
- (void)editRecurrenceRule:(EKRecurrenceFrequency)newFrequency;

- (EKRecurrenceFrequency)recurrenceFrequencyFromRepeatButtons;
- (NSString *)recurrenceString;
- (void)doneViewingPerson;
- (void)setAvailability:(EKEventAvailability)availability;
- (void)showEditRuleConfirmationThenDoAction:(void (^)(void))action cancel:(void (^)(void))cancel;

@end



@protocol CVEventDetailsViewControllerDelegate <NSObject>
@required
- (void)eventDetailsViewController:(CVEventDetailsViewController_iPhone *)controller didPushViewController:(CVViewController *)pushedController animated:(BOOL)animated;
- (void)eventDetailsViewController:(CVEventDetailsViewController_iPhone *)controller didFinishWithResult:(CVEventDetailsResult)result;
@end