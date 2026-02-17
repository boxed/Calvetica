//
//  CVEventDetailsCalendarTableViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVCalendarPickerTableViewControllerDelegate;


@interface CVCalendarPickerTableViewController : UITableViewController

@property (nonatomic, nullable, weak) id<CVCalendarPickerTableViewControllerDelegate> delegate;
@property (nonatomic, copy) NSArray<EKCalendar *> *editableCalendars;
@property (nonatomic, copy) NSArray<EKCalendar *> *allCalendars;
@property (nonatomic, assign) BOOL showUneditableCalendars;

- (NSArray *)calendars;
- (void)setSelectedCalendar:(EKCalendar *)calendar;

@end




@protocol CVCalendarPickerTableViewControllerDelegate <NSObject>
@optional
- (void)calendarPicker:(CVCalendarPickerTableViewController *)calendarPicker didPickCalendar:(EKCalendar *)calendar;
@end

NS_ASSUME_NONNULL_END