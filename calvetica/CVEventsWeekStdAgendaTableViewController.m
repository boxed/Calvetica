//
//  CVEventsWeekStdAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventsWeekStdAgendaTableViewController.h"
#import "CVEventCellDataHolder.h"



@implementation CVEventsWeekStdAgendaTableViewController



- (UINib *)eventCellNib 
{
    if (!_eventCellNib) {
        self.eventCellNib = [CVEventCell nib];
    }
    return _eventCellNib;    
}

- (UINib *)sectionHeaderNib 
{
    if (_sectionHeaderNib == nil) {
        self.sectionHeaderNib = [CVTableSectionHeaderView nib];
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
        self.daysOfWeekArray = [NSDate mt_datesCollectionFromDate:[dateCopy mt_startOfCurrentWeek] untilDate:[[dateCopy mt_endOfCurrentWeek] mt_oneDayNext]];
        NSMutableArray *tempCellArrays = [NSMutableArray array];
        
        // fetch events for each day of the daysOfWeekArray
        for (NSDate *weekDay in self.daysOfWeekArray) {
            // fetch the events
            NSMutableArray *events = [NSMutableArray arrayWithArray:[CVEventStore eventsFromDate:weekDay 
                                                                                          toDate:[weekDay mt_endOfCurrentDay]
                                                                              forActiveCalendars:YES]];
            
            // create cell data holders
            NSMutableArray *tempCellDataHolderArray = [NSMutableArray array];
            for (EKEvent *event in events) {
                
                // create data holder
                CVEventCellDataHolder *cellDataHolder = [[CVEventCellDataHolder alloc] init];
                
                // if the event is all day
                if (event.allDay) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = YES;
                    
                    [tempCellDataHolderArray addObject:cellDataHolder];
                }
                
                // if it spans the whole day, make it an all day event
                else if ([event spansEntireDayOfDate:weekDay]) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = YES;
                    
                    [tempCellDataHolderArray addObject:cellDataHolder];
                }
                
                // if event started before date (but obviously cant end after it) show it at the beginning
                // with a start time of "..."
                else if (![event.startingDate mt_isWithinSameDay:weekDay]) {
                    
                    cellDataHolder.event = event;
                    cellDataHolder.date = nil;
                    cellDataHolder.isAllDay = NO;
                    
                    [tempCellDataHolderArray addObject:cellDataHolder];
                }
                
                else {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = NO;
                    
                    [tempCellDataHolderArray addObject:cellDataHolder];
                }
            }
            
            
            // sort the data holders so that all day events are first, then events that started
            // previously, then events that start today
            [tempCellDataHolderArray sortUsingComparator:(NSComparator)^(id obj1, id obj2){
                CVEventCellDataHolder *h1 = obj1;
                CVEventCellDataHolder *h2 = obj2;
                
                if ((h1.date == nil) != (h2.date == nil)) {
                    return h1.date == nil ? NSOrderedAscending : NSOrderedDescending;
                }
                
                else if (h1.isAllDay != h2.isAllDay) {
                    return h1.isAllDay ? NSOrderedAscending : NSOrderedDescending;
                }
                
                else {
					return [h1.event.startingDate mt_isBefore:h2.event.startingDate] ? NSOrderedAscending : NSOrderedDescending;
                }
            }];
            
            [tempCellArrays addObject:tempCellDataHolderArray];
        }
        
        
        
        
        // update the table with our new event or cell
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // replace the old data holder array with the one we just generated
            self.cellDataHolderArray = [tempCellArrays mutableCopy];
            
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
    for (NSInteger i = 0; i < self.daysOfWeekArray.count; i++) {
        NSDate *d = [self.daysOfWeekArray objectAtIndex:i];
        if ([d mt_isWithinSameDay:date]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:i];
            if ([self.tableView numberOfRowsInSection:0] > indexPath.row) {
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            break;
        }
    }
}

- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index 
{
    NSArray *events = [self.cellDataHolderArray objectAtIndex:index.section];
    return [events objectAtIndex:index.row];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    NSMutableArray *events = [self.cellDataHolderArray objectAtIndex:index.section];
    [events removeObjectAtIndex:index.row];
}

#pragma mark - IBActions




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return self.daysOfWeekArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSArray *events = [self.cellDataHolderArray objectAtIndex:section];
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVEventCell *cell = [CVEventCell cellForTableView:tableView fromNib:self.eventCellNib];

    NSArray *events = [self.cellDataHolderArray objectAtIndex:indexPath.section];
    CVEventCellDataHolder *holder = [events objectAtIndex:indexPath.row];
    
    cell.isEmpty = NO;
    cell.event = holder.event;
    cell.date = holder.date;
    cell.isAllDay = holder.isAllDay;
    cell.durationBarPercent = 0;
    cell.durationBarColor = [UIColor clearColor];
	cell.secondaryDurationBarColor = [UIColor clearColor];
    cell.delegate = self.delegate;
	[cell resetAccessoryButton];
    holder.cell = cell;
    
    [cell drawDurationBarAnimated:NO];
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    NSDate *day = [self.daysOfWeekArray objectAtIndex:section];
    CVTableSectionHeaderView *sectionView = [CVTableSectionHeaderView viewFromNib:self.sectionHeaderNib];
    
    NSString *title = [day stringWithTitleOfCurrentWeekDayAndMonthDayAbbreviated:NO];
    sectionView.weekdayLabel.text = title;
    
    return sectionView;
}

@end
