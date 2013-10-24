//
//  CVRootTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootTableViewController.h"
#import "CVRootTableViewController_Protected.h"
#import "CVCalendarItemCellModel.h"
#import "CVReminderCell.h"


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
    _tableView.separatorColor   = RGBHex(0xF0F0F0);
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;
}

- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
}

- (void)scrollToCurrentHourAnimated:(BOOL)animated
{

}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];
    if (!model.isNull) {
        if (model.calendarItem.isReminder) {
            EKReminder *reminder = (EKReminder *)model.calendarItem;
            reminder.completed = !reminder.completed;
            [reminder saveWithError:nil];
            CVReminderCell *cell = (CVReminderCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell.titleLabel toggleStrikeThroughWithCompletion:^{
                [self.delegate rootTableViewController:self cell:cell updatedItem:reminder];
            }];
        }
    }
}



#pragma mark - DELEGATE table view cell

- (void)calendarItemCell:(UITableViewCell *)cell tappedTime:(NSDate *)date view:(UIView *)view
{
    [self.delegate rootTableViewController:self tappedCell:cell onTime:date view:view];
}

- (void)calendarItemCell:(UITableViewCell *)cell wasTappedForItem:(EKCalendarItem *)calendarItem
{
    if (calendarItem.isReminder) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[self.tableView indexPathForCell:cell]];
    }
    else {
        [self.delegate rootTableViewController:self tappedCell:cell calendarItem:calendarItem];
    }
}

- (void)calendarItemCell:(UITableViewCell *)cell wasLongPressedForItem:(EKCalendarItem *)calendarItem
{
    [self.delegate rootTableViewController:self longPressedCell:cell calendarItem:calendarItem];
}

- (void)calendarItemCell:(UITableViewCell *)cell
                 forItem:(EKCalendarItem *)calendarItem
    wasSwipedInDirection:(CVCalendarItemCellSwipedDirection)direction
{
    [self.delegate rootTableViewController:self swipedCell:cell forItem:calendarItem inDirection:direction];
}

- (void)calendarItemCell:(UITableViewCell *)cell tappedAlarmView:(UIView *)alarmView forItem:(EKCalendarItem *)calendarItem
{
    [self.delegate rootTableViewController:self tappedCell:cell alarmView:alarmView calendarItem:calendarItem];
}

- (void)calendarItemCell:(UITableViewCell *)cell tappedDeleteForItem:(EKCalendarItem *)calendarItem
{
    [self.delegate rootTableViewController:self tappedDeleteOnCell:cell calendarItem:calendarItem];
}

@end
