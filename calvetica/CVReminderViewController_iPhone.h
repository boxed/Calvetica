//
//  CVReminderViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



#import "CVEventDayViewController_iPhone.h"
#import "CVEventHourViewController_iPhone.h"
#import "CVReminderDetailsViewController_iPhone.h"
#import "CVNavigationController.h"

typedef enum {
    CVReminderViewControllerResultCancelled,
    CVReminderViewControllerResultSaved,
    CVReminderViewControllerResultDeleted
} CVReminderViewControllerResult;

typedef enum {
    CVReminderViewControllerModeDay,
	CVReminderViewControllerModeHour,
    CVReminderViewControllerModeDetails,
    CVReminderViewControllerModeMore
} CVReminderViewControllerMode;


@protocol CVReminderViewControllerDelegate;


@interface CVReminderViewController_iPhone : CVNavigationController <CVEventDayViewControllerDelegate, CVModalProtocol, CVReminderDetailsViewControllerDelegate>

@property (nonatomic, weak) id<CVReminderViewControllerDelegate> delegate;
@property (nonatomic, strong) EKReminder *reminder;
@property (nonatomic, assign) CVReminderViewControllerMode mode;
@property (nonatomic) BOOL editable;

- (id)initWithReminder:(EKReminder *)initReminder andMode:(CVReminderViewControllerMode)initMode;

@end





@protocol CVReminderViewControllerDelegate <NSObject>
@required
- (void)reminderViewController:(CVReminderViewController_iPhone *)controller didFinishWithResult:(CVReminderViewControllerResult)result;
@end
