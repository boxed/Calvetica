//
//  CVEventViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTextToggleButton.h"
#import "CVEventDayViewController.h"
#import "CVEventHourViewController.h"
#import "CVEventDetailsViewController.h"
#import "CVEventSnoozeViewController.h"
#import "CVEventDayViewController.h"
#import "CVEventHourViewController.h"
#import "CVEventDetailsViewController.h"
#import "CVNavigationController.h"
#import "CVModalProtocol.h"

typedef NS_ENUM(NSUInteger, CVEventResult) {
    CVEventResultCancelled,
    CVEventResultSaved,
    CVEventResultDeleted
};

typedef NS_ENUM(NSUInteger, CVEventMode) {
    CVEventModeDay,
    CVEventModeHour,
    CVEventModeDetails,
    CVEventModeDetailsMore,
};


@protocol CVEventViewControllerDelegate;


@interface CVEventViewController : CVNavigationController <CVEventDayViewControllerDelegate, CVEventDetailsViewControllerDelegate, CVModalProtocol>

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

- (instancetype)initWithEvent:(EKEvent *)initEvent andMode:(CVEventMode)initMode;

@end





@protocol CVEventViewControllerDelegate <NSObject>
@required
- (void)eventViewController:(CVEventViewController *)controller didFinishWithResult:(CVEventResult)result;
@end