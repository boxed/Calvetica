//
//  CVCalendarPickerViewController_iPhone.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarPickerTableViewController.h"
#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVCalendarPickerViewControllerDelegate;


@interface CVCalendarPickerViewController : CVViewController <CVCalendarPickerTableViewControllerDelegate, CVModalProtocol>

@property (nonatomic, nullable, weak  )          id <CVCalendarPickerViewControllerDelegate> delegate;
@property (nonatomic, strong)          CVCalendarPickerTableViewController                *calendarPickerController;
@property (nonatomic, nullable, weak  ) IBOutlet UIView                                             *eventCalendarBlock;
@property (nonatomic, nullable, weak  ) IBOutlet UITableView                                        *calendarsTableView;
@property (nonatomic, nullable, weak  ) IBOutlet UIScrollView                                       *scrollView;

- (void)adjustLayoutOfTableView;

@end




@protocol CVCalendarPickerViewControllerDelegate <NSObject>
@required
- (void)calendarPickerController:(CVCalendarPickerViewController *)controller didPickCalendar:(EKCalendar *)calendar;
@end

NS_ASSUME_NONNULL_END
