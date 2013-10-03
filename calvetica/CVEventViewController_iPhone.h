//
//  CVEventViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTextToggleButton.h"
#import "CVEventDayViewController_iPhone.h"
#import "CVEventHourViewController_iPhone.h"
#import "CVEventDetailsViewController_iPhone.h"
#import "CVEventSnoozeViewController_iPhone.h"
#import "EKEvent+Utilities.h"
#import "EKEvent+Utilities.h"
#import "CVEventDayViewController_iPhone.h"
#import "CVEventHourViewController_iPhone.h"
#import "CVEventDetailsViewController_iPhone.h"
#import "CVNavigationController.h"
#import "CVModalProtocol.h"

typedef enum {
    CVEventResultCancelled,
    CVEventResultSaved,
    CVEventResultDeleted
} CVEventResult;

typedef enum {
    CVEventModeDay,
    CVEventModeHour,
    CVEventModeDetails,
    CVEventModeDetailsMore,
} CVEventMode;


@protocol CVEventViewControllerDelegate;


@interface CVEventViewController_iPhone : CVNavigationController <CVEventDayViewControllerDelegate, CVEventDetailsViewControllerDelegate, CVModalProtocol>

@property (nonatomic, weak  )          id<CVEventViewControllerDelegate> delegate;
@property (nonatomic, strong)          EKEvent                           *event;
@property (nonatomic, assign)          CVEventMode                       mode;

@property (nonatomic, weak  ) IBOutlet CVTextToggleButton                *dayBarButton;
@property (nonatomic, weak  ) IBOutlet CVTextToggleButton                *hourBarButton;
@property (nonatomic, weak  ) IBOutlet CVTextToggleButton                *detailsBarButton;
@property (nonatomic, weak  ) IBOutlet UIControl                         *cancelButton;
@property (nonatomic, weak  ) IBOutlet UIControl                         *saveButton;
@property (nonatomic, weak  ) IBOutlet UIControl                         *closeButton;
@property (nonatomic, weak  ) IBOutlet UILabel                           *subDetailHeaderTitle;
@property (nonatomic, weak  ) IBOutlet UIControl                         *applyButton;

- (id)initWithEvent:(EKEvent *)initEvent andMode:(CVEventMode)initMode;

@end





@protocol CVEventViewControllerDelegate <NSObject>
@required
- (void)eventViewController:(CVEventViewController_iPhone *)controller didFinishWithResult:(CVEventResult)result;
@end