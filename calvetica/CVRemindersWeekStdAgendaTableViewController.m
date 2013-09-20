//
//  CVRemindersWeekStdAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRemindersWeekStdAgendaTableViewController.h"
#import "CVReminderCellDataHolder.h"
#import "EKReminder+Calvetica.h"


@implementation CVRemindersWeekStdAgendaTableViewController


- (UINib *)reminderCellNib 
{
    if (!_reminderCellNib) {
        _reminderCellNib = [CVReminderCell nib];
    }
    return _reminderCellNib;
}

- (UINib *)sectionHeaderNib 
{
    if (_sectionHeaderNib == nil) {
        _sectionHeaderNib = [CVTableSectionHeaderView nib];
    }
    return _sectionHeaderNib;    
}




#pragma mark - Methods

- (void)loadTableView 
{
    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];
    
    dispatch_async([CVOperationQueue backgroundQueue], ^{
        
        // get the days of the current week
        _daysOfWeekArray = [NSDate mt_datesCollectionFromDate:[dateCopy mt_startOfCurrentWeek] untilDate:[[dateCopy mt_endOfCurrentWeek] mt_oneDayNext]];
        NSMutableArray *tempCellArrays = [NSMutableArray array];
        
        // fetch events for each day of the daysOfWeekArray
        for (NSDate *weekDay in _daysOfWeekArray) {
            // fetch the reminders
			NSArray *reminders = [CVEventStore remindersFromDate:[weekDay mt_startOfCurrentDay] toDate:[weekDay mt_endOfCurrentDay] activeCalendars:YES];

			// create the data holders
			NSMutableArray *tempCellDataHolderArray = [NSMutableArray array];
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

				return [h1.reminder.preferredDate mt_isBefore:h1.reminder.preferredDate] ? NSOrderedAscending : NSOrderedDescending;
			}];

			[tempCellArrays addObject:tempCellDataHolderArray];

		}

		// update the table with our new event or cell
		dispatch_async(dispatch_get_main_queue(), ^{

			// replace the old data holder array with the one we just generated
			_cellDataHolderArray = tempCellArrays;

			[self.tableView reloadData];

			if (self.shouldScrollToDate) {
				[self scrollToDate:self.selectedDate];
				self.shouldScrollToDate = NO;
			}
		});
    });
}

- (void)scrollToDate:(NSDate *)date 
{
    for (NSInteger i = 0; i < _daysOfWeekArray.count; i++) {
        NSDate *d = [_daysOfWeekArray objectAtIndex:i];
        if ([d mt_isWithinSameDay:date]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:i];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            break;
        }
    }
}

- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index 
{
    NSArray *reminders = [_cellDataHolderArray objectAtIndex:index.section];
    return [reminders objectAtIndex:index.row];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    NSMutableArray *reminders = [_cellDataHolderArray objectAtIndex:index.section];
    [reminders removeObjectAtIndex:index.row];
}





#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return _daysOfWeekArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSArray *reminders = [_cellDataHolderArray objectAtIndex:section];
    return reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVReminderCell *cell = [CVReminderCell cellForTableView:tableView fromNib:self.reminderCellNib];
    NSArray *reminders = [_cellDataHolderArray objectAtIndex:indexPath.section];
    CVReminderCellDataHolder *holder = [reminders objectAtIndex:indexPath.row];;
    
    cell.isEmpty = NO;
    cell.reminder = holder.reminder;
    cell.delegate = _delegate;
	[cell resetAccessoryButton];
    holder.cell = cell;
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    [_delegate cellWasTapped:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    return 27;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    NSDate *day = [_daysOfWeekArray objectAtIndex:section];
    CVTableSectionHeaderView *sectionView = [CVTableSectionHeaderView viewFromNib:self.sectionHeaderNib];
    
    NSString *title = [day stringWithTitleOfCurrentWeekDayAndMonthDayAbbreviated:NO];
    sectionView.weekdayLabel.text = title;
    
    return sectionView;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
