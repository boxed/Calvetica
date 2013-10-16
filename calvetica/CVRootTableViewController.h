//
//  CVRootTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVEventCell.h"


@protocol CVRootTableViewControllerDelegate;


@interface CVRootTableViewController : CVViewController <CVEventCellDelegate>

@property (nonatomic, weak  ) NSObject <CVRootTableViewControllerDelegate> *delegate;
@property (nonatomic, strong) NSDate                                       *selectedDate;
@property (nonatomic, strong) UITableView                                  *tableView;

- (void)reloadTableViewWithCompletion:(void (^)(void))completion;
- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index;
- (void)removeObjectAtIndexPath:(NSIndexPath *)index;
- (void)scrollToCurrentHour;
- (void)scrollToDate:(NSDate *)date;

@end




@protocol CVRootTableViewControllerDelegate <NSObject>
- (void)rootTableViewController:(CVRootTableViewController *)controller didScrollToDay:(NSDate *)day;
- (void)rootTableViewController:(CVRootTableViewController *)controller tappedCell:(CVEventCell *)cell;
- (void)rootTableViewController:(CVRootTableViewController *)controller tappedHourOnCell:(CVEventCell *)cell;
- (void)rootTableViewController:(CVRootTableViewController *)controller longPressedCell:(CVEventCell *)cell;
- (void)rootTableViewController:(CVRootTableViewController *)controller
                     swipedCell:(CVEventCell *)cell
                    inDirection:(CVEventCellSwipedDirection)direction;
- (void)rootTableViewController:(CVRootTableViewController *)controller tappedAlarmOnCell:(CVEventCell *)cell;
- (void)rootTableViewController:(CVRootTableViewController *)controller tappedDeleteOnCell:(CVEventCell *)cell;
@end