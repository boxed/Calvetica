//
//  CVQuickAddViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVQuickAddViewController_iPhone.h"
#import "CVCalendarPickerViewController_iPhone.h"

#import "EKEvent+Utilities.h"
#import "CVViewController.h"
#import "CVModalProtocol.h"

typedef enum {
    CVQuickAddModeEvent,
    CVQuickAddModeReminder
} CVQuickAddMode;

typedef enum {
    CVQuickAddResultCancelled,
    CVQuickAddResultSaved,
    CVQuickAddResultMore
} CVQuickAddResult;


@protocol CVQuickAddViewControllerDelegate;


@interface CVQuickAddViewController_iPhone : CVViewController <CVModalProtocol, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate, CVCalendarPickerViewController_iPhoneDelegate>

@property (nonatomic, unsafe_unretained) id<CVQuickAddViewControllerDelegate> delegate;
@property (nonatomic) CVQuickAddMode mode;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) EKCalendarItem *calendarItem;
@property (nonatomic, strong) EKCalendar *calendar;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic) BOOL isDurationMode;
@property (nonatomic, assign) BOOL isAM;

- (void)displayDefault;
- (void)renderEventStartTimeString;
- (void)loadTableViews;
- (void)createNewEventAndRequestMore:(BOOL)more;
- (void)showCalendarPicker;

@end



@protocol CVQuickAddViewControllerDelegate <NSObject>
@required
- (void)quickAddViewController:(CVQuickAddViewController_iPhone *)controller didCompleteWithAction:(CVQuickAddResult)action;
@end
