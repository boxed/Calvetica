//
//  CVEventsAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventsAgendaTableViewController.h"
#import "CVEventCellDataHolder.h"


@interface CVEventsAgendaTableViewController ()
@property (nonatomic, strong) NSMutableArray *calendarItems;
@end


@implementation CVEventsAgendaTableViewController



- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];
    
    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    [MTq def:^{

        // fetch the events
        NSMutableArray *events = [NSMutableArray arrayWithArray:[EKEventStore eventsFromDate:dateCopy 
                                                                                      toDate:[dateCopy mt_endOfCurrentDay]
                                                                          forActiveCalendars:YES]];
        
        // create cell data holders
        NSMutableArray *tempArray = [NSMutableArray array];
        if (events.count == 0) {
            // create data holder
            CVEventCellDataHolder *cellDataHolder = [[CVEventCellDataHolder alloc] init];
            [tempArray addObject:cellDataHolder];
        }
        else {
            for (EKEvent *event in events) {
                
                // create data holder
                CVEventCellDataHolder *cellDataHolder = [[CVEventCellDataHolder alloc] init];
                
                // if the event is all day
                if (event.allDay) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = YES;
                    
                    [tempArray addObject:cellDataHolder];
                }
                
                // if it spans the whole day, make it an all day event
                else if ([event spansEntireDayOfDate:dateCopy]) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = YES;
                    
                    [tempArray addObject:cellDataHolder];
                }
                
                // if event started before date (but obviously cant end after it) show it at the beginning
                // with a start time of "..."
                else if (![event.startingDate mt_isWithinSameDay:dateCopy]) {
                    
                    cellDataHolder.event = event;
                    cellDataHolder.date = nil;
                    cellDataHolder.isAllDay = NO;
                    
                    [tempArray addObject:cellDataHolder];
                }
                
                else {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = NO;
                    
                    [tempArray addObject:cellDataHolder];
                }
            }

            // sort the data holders so that all day events are first, then events that started
            // previously, then events that start today
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                CVEventCellDataHolder *h1 = obj1;
                CVEventCellDataHolder *h2 = obj2;
                
                if ((h1.date == nil) != (h2.date == nil)) {
                    return h1.date == nil ? NSOrderedAscending : NSOrderedDescending;
                }
                
                else if (h1.isAllDay != h2.isAllDay) {
                    return h1.isAllDay ? NSOrderedAscending : NSOrderedDescending;
                }

                else if (h1.isAllDay && h2.isAllDay) {
                    return [h1.event.title localizedCaseInsensitiveCompare:h2.event.title];
                }

                else {
                    return [h1.event.startingDate mt_isBefore:h2.event.startingDate] ? NSOrderedAscending : NSOrderedDescending;
                }
            }];
        }

        // update the table with our new event or cell
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // replace the old data holder array with the one we just generated
            self.calendarItems = [tempArray mutableCopy];
            
            [self.tableView reloadData];

            if (completion) completion();
        });
    }];
    
}

- (void)scrollToCurrentHour 
{
    // scroll to current hour
    [self.tableView reloadData];
    NSInteger currentHour = [[NSDate date] mt_hourOfDay];
    for (NSInteger i = 0; i < self.calendarItems.count; i++) {
        CVEventCellDataHolder *holder = [_calendarItems objectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if ([holder.date mt_hourOfDay] == currentHour &&
            [self.tableView numberOfSections] > indexPath.section &&
            [self.tableView numberOfRowsInSection:indexPath.section] > indexPath.row)
        {
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
            break;
        }
    }
}

- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index 
{
    return [_calendarItems objectAtIndex:index.row];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    [_calendarItems removeObjectAtIndex:index.row];
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.calendarItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
    
    CVEventCell *cell = [CVEventCell cellForTableView:tableView];
    CVEventCellDataHolder *holder = [_calendarItems objectAtIndex:indexPath.row];
    
    if (holder.event) {
        cell.isEmpty = NO;
        cell.event = holder.event;
        cell.date = holder.date;
        cell.isAllDay = holder.isAllDay;
    }
    else {
        cell.isEmpty = YES;
    }
    
    cell.durationBarPercent = 0;
    cell.durationBarColor = [UIColor clearColor];
	cell.secondaryDurationBarColor = [UIColor clearColor];
    cell.delegate = self;
	[cell resetAccessoryButton];
    
    [cell drawDurationBarAnimated:NO];
    
    return cell;
}




@end
