//
//  CVCalendarPickerViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarPickerTableViewController.h"
#import "CVViewController.h"


@protocol CVCalendarPickerViewController_iPhoneDelegate;


@interface CVCalendarPickerViewController_iPhone : CVViewController <CVCalendarPickerTableViewControllerDelegate, CVModalProtocol>

@property (nonatomic, weak  )          id <CVCalendarPickerViewController_iPhoneDelegate> delegate;
@property (nonatomic        )          CVCalendarPickerMode                               mode;
@property (nonatomic, strong)          CVCalendarPickerTableViewController                *calendarPickerController;
@property (nonatomic, weak  ) IBOutlet UIView                                             *eventCalendarBlock;
@property (nonatomic, weak  ) IBOutlet UITableView                                        *calendarsTableView;
@property (nonatomic, weak  ) IBOutlet UIScrollView                                       *scrollView;

- (void)adjustLayoutOfTableView;

@end




@protocol CVCalendarPickerViewController_iPhoneDelegate <NSObject>
@required
- (void)calendarPickerController:(CVCalendarPickerViewController_iPhone *)controller didPickCalendar:(EKCalendar *)calendar;
@end
