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

NS_ASSUME_NONNULL_BEGIN


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

@property (nonatomic, nullable, weak  )          id<CVEventViewControllerDelegate> delegate;
@property (nonatomic, strong)          EKEvent                           *event;
@property (nonatomic, assign)          CVEventMode                       mode;

@property (nonatomic, nullable, weak  ) IBOutlet CVTextToggleButton                *dayBarButton;
@property (nonatomic, nullable, weak  ) IBOutlet CVTextToggleButton                *hourBarButton;
@property (nonatomic, nullable, weak  ) IBOutlet CVTextToggleButton                *detailsBarButton;
@property (nonatomic, nullable, weak  ) IBOutlet UIControl                         *cancelButton;
@property (nonatomic, nullable, weak  ) IBOutlet UIControl                         *saveButton;
@property (nonatomic, nullable, weak  ) IBOutlet UIControl                         *closeButton;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                           *subDetailHeaderTitle;
@property (nonatomic, nullable, weak  ) IBOutlet UIControl                         *applyButton;

- (instancetype)initWithEvent:(EKEvent *)initEvent andMode:(CVEventMode)initMode;

@end





@protocol CVEventViewControllerDelegate <NSObject>
@required
- (void)eventViewController:(CVEventViewController *)controller didFinishWithResult:(CVEventResult)result;
@end

NS_ASSUME_NONNULL_END