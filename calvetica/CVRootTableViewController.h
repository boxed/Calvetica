//
//  CVRootTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVEventCell.h"


static CGFloat const CVRootTableViewEventRowHeight      = 44;
static CGFloat const CVRootTableViewReminderRowHeight   = 20;


@protocol CVRootTableViewControllerDelegate;


@interface CVRootTableViewController : CVViewController <CVCalendarItemCellDelegate,
                                                         UITableViewDelegate,
                                                         UITableViewDataSource>

@property (nonatomic, weak  ) NSObject <CVRootTableViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSDate                                       *selectedDate;
@property (nonatomic, strong) UITableView                                  *tableView;

- (void)reloadTableViewWithCompletion:(void (^)(void))completion;
- (void)scrollToCurrentHourAnimated:(BOOL)animated;
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;

@end




@protocol CVRootTableViewControllerDelegate <NSObject>

- (void)rootTableViewController:(CVRootTableViewController *)controller
                 didScrollToDay:(NSDate *)day;

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     tappedCell:(UITableViewCell *)cell
                   calendarItem:(EKCalendarItem *)calendarItem;

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     tappedCell:(UITableViewCell *)cell
                         onTime:(NSDate *)time
                           view:(UIView *)view;

- (void)rootTableViewController:(CVRootTableViewController *)controller
                longPressedCell:(UITableViewCell *)cell
                   calendarItem:(EKCalendarItem *)calendarItem;

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     swipedCell:(UITableViewCell *)cell
                        forItem:(EKCalendarItem *)calendarItem
                    inDirection:(CVCalendarItemCellSwipedDirection)direction;

- (void)rootTableViewController:(CVRootTableViewController *)controller
                     tappedCell:(UITableViewCell *)cell
                      alarmView:(UIView *)alarmView
                   calendarItem:(EKCalendarItem *)calendarItem;

- (void)rootTableViewController:(CVRootTableViewController *)controller
             tappedDeleteOnCell:(UITableViewCell *)cell
                   calendarItem:(EKCalendarItem *)calendarItem;
@end