//
//  CVReminderCalendarPickerViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarTableViewCell_iPhone.h"
#import "UITableViewCell+Nibs.h"


@protocol CVReminderCalendarPickerViewControllerDelegate;


@interface CVReminderCalendarPickerViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, weak) id<CVReminderCalendarPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *availableCalendars;

#pragma mark - Public Methods
- (void)setSelectedCalendar:(EKCalendar *)calendar;

#pragma mark - Notifications


@end




@protocol CVReminderCalendarPickerViewControllerDelegate <NSObject>
@optional
- (void)calendarPicker:(CVReminderCalendarPickerViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar;
@end
