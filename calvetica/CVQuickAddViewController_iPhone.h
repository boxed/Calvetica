//
//  CVQuickAddViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVQuickAddViewController_iPhone.h"
#import "CVCalendarPickerViewController_iPhone.h"

#import "CVViewController.h"
#import "CVModalProtocol.h"

typedef NS_ENUM(NSUInteger, CVQuickAddResult) {
    CVQuickAddResultCancelled,
    CVQuickAddResultSaved,
    CVQuickAddResultMore
};


@protocol CVQuickAddViewControllerDelegate;


@interface CVQuickAddViewController_iPhone : CVViewController <CVModalProtocol, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, CVCalendarPickerViewController_iPhoneDelegate>

@property (nonatomic, weak  ) id<CVQuickAddViewControllerDelegate> delegate;
@property (nonatomic, copy  ) NSString                             *defaultTitle;
@property (nonatomic, strong) NSDate                               *startDate;
@property (nonatomic, strong) NSDate                               *endDate;
@property (nonatomic, strong) EKCalendarItem                       *calendarItem;
@property (nonatomic, strong) EKCalendar                           *calendar;
@property (nonatomic, assign) BOOL                                 isAllDay;
@property (nonatomic, assign) BOOL                                 isDurationMode;
@property (nonatomic, assign) BOOL                                 isAM;

- (void)displayDefault;
- (void)renderEventStartTimeString;
- (void)loadTableViews;
- (void)createNewEventAndRequestMore:(BOOL)more;
- (void)showCalendarPicker;

@end



@protocol CVQuickAddViewControllerDelegate <NSObject>
- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)action;
@end
