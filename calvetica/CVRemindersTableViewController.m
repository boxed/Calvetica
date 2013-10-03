//
//  CVRemindersTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRemindersTableViewController.h"
#import "CVReminderCellDataHolder.h"
#import "EKReminder+Calvetica.h"



@implementation CVRemindersTableViewController


- (UINib *)reminderCellNib 
{
    if (!_reminderCellNib) {
        self.reminderCellNib = [CVReminderCell nib];
    }
    return _reminderCellNib;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Methods

- (void)loadTableView 
{
    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];
    
    dispatch_async([CVOperationQueue backgroundQueue], ^{

		
		// fetch the reminders
		NSArray *reminders = [CVEventStore remindersFromDate:[dateCopy mt_startOfCurrentDay] toDate:[dateCopy mt_endOfCurrentDay] activeCalendars:YES];

		// create the data holders
		NSMutableArray *tempCellDataHolderArray = [NSMutableArray array];
		if (reminders.count == 0) {
			CVReminderCellDataHolder *cellDataHolder = [[CVReminderCellDataHolder alloc] init];
			[tempCellDataHolderArray addObject:cellDataHolder];
		}
		else {
			for (EKReminder *reminder in reminders) {
				// create data holder
				CVReminderCellDataHolder *cellDataHolder = [[CVReminderCellDataHolder alloc] init];
				cellDataHolder.reminder = reminder;
				[tempCellDataHolderArray addObject:cellDataHolder];
			}

			[tempCellDataHolderArray sortUsingComparator:(NSComparator)^(id obj1, id obj2){
				CVReminderCellDataHolder *h1 = obj1;
				CVReminderCellDataHolder *h2 = obj2;

				// if their completed attribute differes
				if (h1.reminder.isCompleted != h2.reminder.isCompleted) {
					return h1.reminder.isCompleted ? NSOrderedDescending : NSOrderedAscending;
				}

				// if their priorty attributes differ
				else if (h1.reminder.priority != h2.reminder.priority) {
					return h1.reminder.priority > h2.reminder.priority ? NSOrderedDescending : NSOrderedAscending;
				}
				
				return [h1.reminder.preferredDate mt_isBefore:h2.reminder.preferredDate] ? NSOrderedAscending : NSOrderedDescending;
			}];
		}

		// update the table with our new event or cell
		dispatch_async(dispatch_get_main_queue(), ^{

			// replace the old data holder array with the one we just generated
			self.cellDataHolderArray = [tempCellDataHolderArray mutableCopy];

			[self.tableView reloadData];

			if (self.shouldScrollToCurrentHour) {
				[self scrollToCurrentHour];
				self.shouldScrollToCurrentHour = NO;
			}
		});
    });

}

- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index 
{
    return [_cellDataHolderArray objectAtIndex:index.row];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    [_cellDataHolderArray removeObjectAtIndex:index.row];
}

- (void)scrollToCurrentHour 
{
    // scroll to current hour
    NSInteger currentHour = [[NSDate date] mt_hourOfDay];
    for (NSInteger i = 0; i < self.cellDataHolderArray.count; i++) {
        CVReminderCellDataHolder *holder = [_cellDataHolderArray objectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if ([holder.date mt_hourOfDay] == currentHour &&
            [self.tableView numberOfSections] > indexPath.section &&
            [self.tableView numberOfRowsInSection:indexPath.section] > indexPath.row)
        {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            break;
        }
    }
}



#pragma mark - IBActions




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _cellDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVReminderCell *cell = [CVReminderCell cellForTableView:tableView fromNib:self.reminderCellNib];
    CVReminderCellDataHolder *holder = [_cellDataHolderArray objectAtIndex:indexPath.row];
    
    if (holder.reminder) {
        cell.isEmpty = NO;
        cell.reminder = holder.reminder;
    }
    else {
        cell.isEmpty = YES;
    }
    
    cell.delegate = self.delegate;
	[cell resetAccessoryButton];
    holder.cell = cell;
    
    return cell;
}


@end
