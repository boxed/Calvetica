//
//  CVReminderCalendarPickerViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarTableViewCell_iPhone.h"
#import "UITableViewCell+Nibs.h"


@protocol CVReminderCalendarPickerViewControllerDelegate;


@interface CVReminderCalendarPickerViewController : UITableViewController
@property (nonatomic, weak) id<CVReminderCalendarPickerViewControllerDelegate> delegate;
@property (nonatomic, copy) NSArray                                            *availableCalendars;
- (void)setSelectedCalendar:(EKCalendar *)calendar;
@end


@protocol CVReminderCalendarPickerViewControllerDelegate <NSObject>
@optional
- (void)calendarPicker:(CVReminderCalendarPickerViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar;
@end
