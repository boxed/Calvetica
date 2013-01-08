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


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id <CVCalendarPickerViewController_iPhoneDelegate> delegate;
@property (nonatomic) CVCalendarPickerMode mode;
@property (nonatomic, strong) CVCalendarPickerTableViewController *calendarPickerController;
@property (nonatomic, weak) IBOutlet UIView *eventCalendarBlock;
@property (nonatomic, weak) IBOutlet UITableView *calendarsTableView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

#pragma mark - Methods
- (void)adjustLayoutOfTableView;

#pragma mark - IBActions


#pragma mark - Notifications


@end




@protocol CVCalendarPickerViewController_iPhoneDelegate <NSObject>
@required
- (void)calendarPickerController:(CVCalendarPickerViewController_iPhone *)controller didPickCalendar:(EKCalendar *)calendar;
@end
