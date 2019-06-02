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
#import "CVTextView.h"
#import "CVButton.h"
#import "CVNavigationController.h"
#import "CVEventDetailsNotesViewController.h"
#import "CVEventDetailsLocationViewController.h"
#import "CVCalendarPickerTableViewController.h"
#import "CVEventDetailsRepeatViewController.h"
#import "CVEventDetailsRepeatDailyViewController.h"
#import "CVEventDetailsRepeatWeeklyViewController.h"
#import "CVEventDetailsRepeatMonthlyViewController.h"
#import "CVEventDetailsRepeatYearlyViewController.h"
#import "CVRoundedToggleButton.h"
#import "strings.h"
#import "CVSlideLockControl.h"
#import "UIView+Nibs.h"
#import "SCEventDetailsAllDayAlarmPicker.h"
#import "SCEventDetailsAlarmPicker.h"
#import "CVViewController.h"


typedef NS_ENUM(NSUInteger, CVEventDetailsResult) {
    CVEventDetailsResultDeleted
};


@protocol CVEventDetailsViewControllerDelegate;


@interface CVEventDetailsViewController : CVViewController <UITextViewDelegate, CVTextViewDelegate, CVEventDetailsNotesViewControllerDelegate, CVEventDetailsLocationViewControllerDelegate, CVCalendarPickerTableViewControllerDelegate, CVEventDetailsRecurrenceDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, EKEventEditViewDelegate>

@property (nonatomic, weak  ) id<CVEventDetailsViewControllerDelegate>       delegate;
@property (nonatomic, strong) UIViewController                               *rootController;
@property (nonatomic, strong) EKEvent                                        *event;
@property (nonatomic, strong) CVCalendarPickerTableViewController            *calendarTableViewController;
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
- (void)eventDetailsViewController:(CVEventDetailsViewController *)controller didPushViewController:(CVViewController *)pushedController animated:(BOOL)animated;
- (void)eventDetailsViewController:(CVEventDetailsViewController *)controller didFinishWithResult:(CVEventDetailsResult)result;
@end
