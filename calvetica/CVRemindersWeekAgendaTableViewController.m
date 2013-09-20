//
//  CVRemindersWeekAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRemindersWeekAgendaTableViewController.h"
#import "CVReminderCellDataHolder.h"
#import "CVAgendaDateCell.h"
#import "CVFriendlyCell.h"
#import "EKReminder+Calvetica.h"
#import "dimensions.h"




@implementation CVRemindersWeekAgendaTableViewController


- (UINib *)reminderCellNib 
{
    if (!_reminderCellNib) {
        self.reminderCellNib = [CVAgendaReminderCell nib];
    }
    return _reminderCellNib;
}

- (UINib *)dayTitleCellNib 
{
    if (!_dayTitleCellNib) {
        self.dayTitleCellNib = [CVAgendaDateCell nib];
    }
    return _dayTitleCellNib;
}

- (UINib *)friendlyCellNib 
{
    if (!_friendlyCellNib) {
        self.friendlyCellNib = [CVFriendlyCell nib];
    }
    return _friendlyCellNib;
}

- (UINib *)weekNumberCellNib 
{
    if (!_weekNumberCellNib) {
        self.weekNumberCellNib = [CVWeekNumberCell nib];
    }
    return _weekNumberCellNib;
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
        
        NSMutableArray *tempCellDataHolderArray = [NSMutableArray array];
		
        // Add week number.
        CVWeekNumberHolder *weekNumberRow = [[CVWeekNumberHolder alloc] init];
        weekNumberRow.weekNumber = [self.selectedDate mt_weekOfYear];
        [tempCellDataHolderArray addObject:weekNumberRow];
        
        // for each day
		NSDate *startOfWeek = [dateCopy mt_startOfCurrentWeek];
        for (int i = 6; i >= 0; i--) {
            NSDate *day =  [startOfWeek mt_dateByAddingYears:0 months:0 weeks:0 days:i hours:0 minutes:0 seconds:0];
			
			// create a cell for the title of the day
            CVReminderCellDataHolder *dayTitleRow = [[CVReminderCellDataHolder alloc] init];
			dayTitleRow.reminder = nil;
			dayTitleRow.date = day;
			[tempCellDataHolderArray addObject:dayTitleRow];
			
			
			// fetch the reminders for this day
			NSArray *reminders = [CVEventStore remindersFromDate:[day mt_startOfCurrentDay] toDate:[day mt_endOfCurrentDay] activeCalendars:YES];

			for (EKReminder *reminder in reminders) {
				// create data holder
				CVReminderCellDataHolder *cellDataHolder = [[CVReminderCellDataHolder alloc] init];
				cellDataHolder.reminder = reminder;
				cellDataHolder.date = day;
				[tempCellDataHolderArray addObject:cellDataHolder];
			}
		}

		// create a holder for the friendly phrase
		CVFriendlyCellDataHolder *friendlyPhraseRow = [[CVFriendlyCellDataHolder alloc] init];
		[tempCellDataHolderArray addObject:friendlyPhraseRow];


		// sort the events so they appear correctly
		[tempCellDataHolderArray sortUsingComparator:(NSComparator)^(id obj1, id obj2){
			CVDataHolder *dataHolder1 = obj1;
			CVDataHolder *dataHolder2 = obj2;

			// The week number is first and the friendly phrase is last.
			if ([dataHolder1 isKindOfClass:[CVWeekNumberHolder class]] || [dataHolder2 isKindOfClass:[CVWeekNumberHolder class]]) {
				return NSOrderedAscending;
			} else if ([dataHolder1 isKindOfClass:[CVFriendlyCellDataHolder class]] || [dataHolder2 isKindOfClass:[CVFriendlyCellDataHolder class]]) {
				return [dataHolder1 isKindOfClass:[CVFriendlyCellDataHolder class]] ? NSOrderedDescending : NSOrderedAscending;
			} else {
				CVReminderCellDataHolder *h1 = obj1;
				CVReminderCellDataHolder *h2 = obj2;

				// if the dates are not equal, order them in chrono order
				if (![h1.date isEqualToDate:h2.date]) {
					return [h1.date mt_isBefore:h2.date] ? NSOrderedAscending : NSOrderedDescending;
				}

				// if one doesn't have a reminder, its a title and should go before all other cells for that date
				else if ((h1.reminder == nil) != (h2.reminder == nil)) {
					return h1.reminder == nil ? NSOrderedAscending : NSOrderedDescending;
				}

				// if their completed attribute differes
				else if (h1.reminder.isCompleted != h2.reminder.isCompleted) {
					return h1.reminder.isCompleted ? NSOrderedDescending : NSOrderedAscending;
				}

				// if their priorty attributes differ
				else if (h1.reminder.priority != h2.reminder.priority) {
					return h1.reminder.priority > h2.reminder.priority ? NSOrderedDescending : NSOrderedAscending;
				}

				// finally, sort by due date
				else {
					return [h1.reminder.preferredDate mt_isBefore:h1.reminder.preferredDate] ? NSOrderedAscending : NSOrderedDescending;
				}
			}
		}];

		// update the table with our new event or cell
		dispatch_async(dispatch_get_main_queue(), ^{

			// replace the old data holder array with the one we just generated
			self.cellDataHolderArray = [tempCellDataHolderArray mutableCopy];

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
    for (NSInteger i = 0; i < self.cellDataHolderArray.count; i++) {
        CVDataHolder *holder = [self.cellDataHolderArray objectAtIndex:i];

        if ([holder isKindOfClass:[CVReminderCellDataHolder class]]) {
            CVReminderCellDataHolder *eventHolder = (CVReminderCellDataHolder *)holder;

            if (!eventHolder.reminder   &&
                eventHolder.date        &&
                [eventHolder.date mt_isWithinSameDay:self.selectedDate] &&
                i < [self.tableView numberOfRowsInSection:0]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                break;
            }
        }
    }
}



#pragma mark - IBActions




#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _cellDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    CVDataHolder *holder = [_cellDataHolderArray objectAtIndex:indexPath.row];
    
	UITableViewCell *returnCell = nil;
	
    if ([holder isKindOfClass:[CVReminderCellDataHolder class]]) {
        CVReminderCellDataHolder *reminderHolder = (CVReminderCellDataHolder *)holder;
        
        if (reminderHolder.reminder) {
            CVAgendaReminderCell *cell = [CVAgendaReminderCell cellForTableView:tableView fromNib:self.reminderCellNib];
            cell.reminder = reminderHolder.reminder;
            reminderHolder.cell = cell;
            cell.delegate = self.delegate;

            
            // call the NSString category method to set the number of lines for the textLabel
            CGFloat width;
            if (PAD) {
                width = TABLE_ROW_REMINDER_WIDTH_IPAD;
            }
            else {
                width = TABLE_ROW_REMINDER_WIDTH_IPHONE;
            }
            cell.titleLabel.numberOfLines = [cell.titleLabel.text linesOfWordWrapTextWithFont:[UIFont systemFontOfSize:13] constraintWidth:width];
            
            returnCell = cell;
        }
        
        // if it has no event, but a date, then its a title of day cell
        else if (reminderHolder.date) {
            CVAgendaDateCell *cell = [CVAgendaDateCell cellForTableView:tableView fromNib:self.dayTitleCellNib];
            cell.date = reminderHolder.date;
            reminderHolder.cell = cell;	
            returnCell = cell;
        }
        
    } else if ([holder isKindOfClass:[CVWeekNumberHolder class]]) {
        returnCell = [CVWeekNumberCell cellForTableView:tableView fromNib:self.weekNumberCellNib];
        ((CVWeekNumberCell *)returnCell).weekNumberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Week %1$i", @"The week number of a selected date. %1$i: the week number."), ((CVWeekNumberHolder *)holder).weekNumber];
    } else if ([holder isKindOfClass:[CVFriendlyCellDataHolder class]]) {
        returnCell = [CVFriendlyCell cellForTableView:tableView fromNib:self.friendlyCellNib];
        ((CVFriendlyCell *)returnCell).friendlyPhraseLabel.text = ((CVFriendlyCellDataHolder *)holder).friendlyText;
    }
	
    return returnCell;
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	CVDataHolder *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];
    
    if ([holder isKindOfClass:[CVWeekNumberHolder class]]) {
        return WEEK_NUM_CELL_HEIGHT;
    } else if ([holder isKindOfClass:[CVFriendlyCellDataHolder class]]) {
        return FRIENDLY_CELL_HEIGHT;
    }
    
    CVReminderCellDataHolder *reminderHolder = (CVReminderCellDataHolder *)holder;
    
    // call the NSString category method to set the cell height of the regular cells
    // add a little padding to keep padding consistent
    CGFloat width;
    if (PAD) {
        width = TABLE_ROW_REMINDER_WIDTH_IPAD;
    }
    else {
        width = TABLE_ROW_REMINDER_WIDTH_IPHONE;
    }
    CGFloat height = [reminderHolder.reminder.title totalHeightOfWordWrapTextWithFont:[UIFont systemFontOfSize:13] constraintWidth:width] + 3;
    
	return reminderHolder.reminder == nil ? TABLE_ROW_DAY_TITLE_HEIGHT : height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	id cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[CVAgendaReminderCell class]]) {
		CVAgendaReminderCell *theCell = (CVAgendaReminderCell *)cell;
		[_delegate cellWasTapped:theCell];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];		
	}
	else if ([cell isKindOfClass:[CVAgendaDateCell class]]) {
		CVAgendaDateCell *theCell = (CVAgendaDateCell *)cell;
		[self.tableControllerProtocol tableViewDidScrollToDay:theCell.date];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


@end
