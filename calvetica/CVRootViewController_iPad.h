//
//  CVRootViewController_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVRootViewController.h"
#import "CVEventDayViewController_iPhone.h"
#import "CVJumpToDateViewController_iPhone.h"
#import "CVQuickAddViewController_iPhone.h"
#import "CVEventViewController_iPhone.h"
#import "CVManageCalendarsViewController_iPhone.h"
#import "CVSearchViewController_iPhone.h"
#import "CVReminderViewController_iPhone.h"
#import "CVGenericReminderViewController_iPhone.h"
#import "CVLandscapeWeekView_iPad.h"
#import "CVWeekTableViewCell_iPad.h"


@interface CVRootViewController_iPad : CVRootViewController <CVFAQViewControllerDelegate, CVGestureHowToViewControllerDelegate> {}


- (void)setMonthAndDayLabels;
- (void)showQuickAddWithDefault:(BOOL)def durationMode:(BOOL)dur date:(NSDate *)date view:(UIView *)view mode:(CVQuickAddMode)mode;
- (void)showWeekView;


#pragma mark - Notifications
- (void)eventStoreChanged;


@end
