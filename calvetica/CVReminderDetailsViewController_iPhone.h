//
//  CVReminderDetailsViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTextView.h"
#import "CVNavigationController.h"
#import "CVEventDetailsNotesViewController_iPhone.h"
#import "CVReminderCalendarPickerViewController.h"

#import "CVViewController.h"

typedef enum {
    CVReminderDetailsResultDeleted,
    CVReminderDetailsResultComplete,
    CVReminderDetailsResultUncomplete
} CVReminderDetailsResult;


@protocol CVReminderDetailsViewControllerDelegate;


@interface CVReminderDetailsViewController_iPhone : CVViewController <UIScrollViewDelegate, UITextViewDelegate, CVTextViewDelegate, CVEventDetailsNotesViewControllerDelegate, CVReminderCalendarPickerViewControllerDelegate>

@property (nonatomic, weak) id<CVReminderDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) EKReminder *reminder;


- (id)initWithReminder:(EKReminder *)initReminder;

- (void)adjustLayoutOfBlocks;
- (void)setPriority:(NSInteger)priority;
- (void)doneSliderWasToggled:(id)sender;
- (void)deleteSliderWasToggled:(id)sender;

@end



@protocol CVReminderDetailsViewControllerDelegate <NSObject>
@required
- (void)reminderDetailsViewController:(CVReminderDetailsViewController_iPhone *)controller didPushViewController:(BOOL)animated;
- (void)reminderDetailsViewController:(CVReminderDetailsViewController_iPhone *)controller didFinishWithResult:(CVReminderDetailsResult)result;
@end