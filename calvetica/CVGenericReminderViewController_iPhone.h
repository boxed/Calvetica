//
//  CVGenericReminderViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVModalProtocol.h"


typedef enum {
    CVGenericReminderViewControllerResultCancelled,
    CVGenericReminderViewControllerResultAdded
} CVGenericReminderViewControllerResult;


@protocol CVGenericReminderViewControllerDelegate;


@interface CVGenericReminderViewController_iPhone : CVViewController <CVModalProtocol>

@property (nonatomic, weak) id<CVGenericReminderViewControllerDelegate> delegate;
@property (nonatomic, strong) EKReminder *reminder;

@end



@protocol CVGenericReminderViewControllerDelegate <NSObject>
@required
- (void)genericReminderViewController:(CVGenericReminderViewController_iPhone *)controller didFinishWithResult:(CVGenericReminderViewControllerResult)result;
@end
