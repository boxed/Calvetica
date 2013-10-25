//
//  CVGenericReminderViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVModalProtocol.h"


typedef NS_ENUM(NSUInteger, CVGenericReminderViewControllerResult) {
    CVGenericReminderViewControllerResultCancelled,
    CVGenericReminderViewControllerResultAdded
};


@protocol CVGenericReminderViewControllerDelegate;


@interface CVGenericReminderViewController : CVViewController <CVModalProtocol>

@property (nonatomic, weak) id<CVGenericReminderViewControllerDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;

@end



@protocol CVGenericReminderViewControllerDelegate <NSObject>
@required
- (void)genericReminderViewController:(CVGenericReminderViewController *)controller didFinishWithResult:(CVGenericReminderViewControllerResult)result;
@end
