//
//  CVRootTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

@protocol CVRootTableViewControllerProtocol;




@interface CVRootTableViewController : CVViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak  ) NSObject <CVRootTableViewControllerProtocol> *tableControllerProtocol;
@property (nonatomic, strong) NSDate                                       *selectedDate;
@property (nonatomic, strong) UITableView                                  *tableView;

// this is necessary because the selected.date is set before the table is loaded
// and you can't scroll before the table is loaded
@property (nonatomic, assign) BOOL shouldScrollToCurrentHour;
@property (nonatomic, assign) BOOL shouldScrollToDate;

- (void)setDelegate:(id)delegate;
- (void)loadTableView;
- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index;
- (void)removeObjectAtIndexPath:(NSIndexPath *)index;
- (void)scrollToCurrentHour;
- (void)scrollToDate:(NSDate *)date;

@end




@protocol CVRootTableViewControllerProtocol <NSObject>
@optional
- (void)tableViewDidScrollToDay:(NSDate *)day;
@end