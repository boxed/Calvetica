//
//  CVRootTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootTableViewController.h"


@interface CVRootTableViewController () <UITableViewDelegate, UITableViewDataSource>
@end


@implementation CVRootTableViewController

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark - Public

- (void)setTableView:(UITableView *)newTableView 
{
    _tableView                  = newTableView;
    _tableView.delegate         = self;
    _tableView.dataSource       = self;
    _tableView.separatorColor   = RGB(214, 214, 214);
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;
}

- (void)reloadTableView 
{
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
}

- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index 
{
    return nil;
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    
}

- (void)scrollToCurrentHour 
{
    
}

- (void)scrollToDate:(NSDate *)date 
{
	
}




#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return nil;
}



#pragma mark - DELEGATE table view cell

- (void)cellHourTimeWasTapped:(CVEventCell *)cell
{
    [self.delegate rootTableViewController:self tappedHourOnCell:cell];
}

- (void)cellWasTapped:(CVEventCell *)cell
{
    [self.delegate rootTableViewController:self tappedCell:cell];
}

- (void)cellWasLongPressed:(CVEventCell *)cell
{
    [self.delegate rootTableViewController:self longPressedCell:cell];
}

- (void)cell:(CVEventCell *)cell wasSwipedInDirection:(CVEventCellSwipedDirection)direction
{
    [self.delegate rootTableViewController:self swipedCell:cell inDirection:direction];
}

- (void)cell:(CVCell *)cell alarmButtonWasTappedForCalendarItem:(EKCalendarItem *)calendarItem
{
    [self.delegate rootTableViewController:self tappedAlarmOnCell:(CVEventCell *)cell];
}

- (void)cellEventWasDeleted:(CVEventCell *)cell
{
    [self.delegate rootTableViewController:self tappedDeleteOnCell:cell];
}



@end
