//
//  CVEventDetailsCalendarTableViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKCalendar+Utilities.h"
#import "CVEventStore.h"
#import "CVCalendarTableViewCell_iPhone.h"

typedef enum {
    CVCalendarPickerModeEvent,
    CVCalendarPickerModeReminder
} CVCalendarPickerMode;


@protocol CVCalendarPickerTableViewControllerDelegate;


@interface CVCalendarPickerTableViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<CVCalendarPickerTableViewControllerDelegate> delegate;
@property (nonatomic) CVCalendarPickerMode mode;
@property (nonatomic, strong) NSArray *editableCalendars;
@property (nonatomic, strong) NSArray *allCalendars;
@property (nonatomic, assign) BOOL showUneditableCalendars;

- (NSArray *)calendars;
- (void)setSelectedCalendar:(EKCalendar *)calendar;

@end




@protocol CVCalendarPickerTableViewControllerDelegate <NSObject>
@optional
- (void)calendarPicker:(CVCalendarPickerTableViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar;
@end