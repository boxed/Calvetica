//
//  CVCalendarPickerViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarPickerTableViewController.h"
#import "CVViewController.h"


@protocol CVCalendarPickerViewControllerDelegate;


@interface CVCalendarPickerViewController : CVViewController <CVCalendarPickerTableViewControllerDelegate, CVModalProtocol>

@property (nonatomic, weak  )          id <CVCalendarPickerViewControllerDelegate> delegate;
@property (nonatomic, strong)          CVCalendarPickerTableViewController                *calendarPickerController;
@property (nonatomic, weak  ) IBOutlet UIView                                             *eventCalendarBlock;
@property (nonatomic, weak  ) IBOutlet UITableView                                        *calendarsTableView;
@property (nonatomic, weak  ) IBOutlet UIScrollView                                       *scrollView;

- (void)adjustLayoutOfTableView;

@end




@protocol CVCalendarPickerViewControllerDelegate <NSObject>
@required
- (void)calendarPickerController:(CVCalendarPickerViewController *)controller didPickCalendar:(EKCalendar *)calendar;
@end
