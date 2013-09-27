//
//  CVRootViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootViewController.h"
#import "CVQuickAddViewController_iPhone.h"
#import "CVJumpToDateViewController_iPhone.h"
#import "CVEventDayViewController_iPhone.h"
#import "CVEventViewController_iPhone.h"
#import "CVManageCalendarsViewController_iPhone.h"
#import "CVSearchViewController_iPhone.h"
#import "CVReminderViewController_iPhone.h"
#import "CVGenericReminderViewController_iPhone.h"
#import "dimensions.h"
#import "CVTapGestureRecognizer.h"
#import "UIApplication+Utilities.h"


typedef enum {
    CVRootMonthViewAnimateDirectionDown,
    CVRootMonthViewAnimateDirectionUp
} CVRootMonthViewAnimateDirection;


@interface CVRootViewController_iPhone : CVRootViewController <UIGestureRecognizerDelegate> {}

- (void)animateMonthViewDirection:(CVRootMonthViewAnimateDirection)direction;
- (void)eventStoreChanged;

@end
