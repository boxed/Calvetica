//
//  CVEventsFullDayTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventsFullDayTableViewController.h"
#import "CVEventCellDataHolder.h"
#import "NSMutableArray+Utilities.h"


@interface CVEventsFullDayTableViewController ()
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@end


@implementation CVEventsFullDayTableViewController



- (void)reloadTableView 
{
    [super reloadTableView];
    
    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    [MTq def:^{

        NSMutableArray *hours = [NSMutableArray array];
        
        // create a date for every hour if agenda view is off
        for (int i = 23; i >= 0; i--) {
            [hours addObject:[NSDate mt_dateFromYear:[dateCopy mt_year]
                                               month:[dateCopy mt_monthOfYear]
                                                 day:[dateCopy mt_dayOfMonth]
                                                hour:i
                                              minute:0]];
        }



        // fetch the events
        NSMutableArray *events = [NSMutableArray arrayWithArray:[CVEventStore eventsFromDate:dateCopy 
                                                                                      toDate:[dateCopy mt_endOfCurrentDay]
                                                                          forActiveCalendars:YES]];
        
        // sort the events backwards
        [events sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            EKEvent *e1 = obj1;
            EKEvent *e2 = obj2;
            return [e1 compareStartDateWithEvent:e2] == NSOrderedAscending ? NSOrderedDescending : NSOrderedAscending;
        }];
        
        
        
        // zipper them together
        NSMutableArray *tempCellDataHolderArray = [NSMutableArray array];
        for (;;) {

            // grab next objects
            EKEvent *event = [events lastObject];
            NSDate *hour = [hours lastObject];

            // create data holder
            CVEventCellDataHolder *cellDataHolder = [[CVEventCellDataHolder alloc] init];


            // if the event is all day, doesn't need to be compared with an hour
            if (event && event.allDay) {
                cellDataHolder.event = event;
                cellDataHolder.date = event.startingDate;
                cellDataHolder.isAllDay = YES;
                [events removeLastObject];    

                // because it's an all day event, we want it at the beginning of the array
                [tempCellDataHolderArray insertObject:cellDataHolder atIndex:0];
                continue;


			// if event started before date
            } else if (event && ![event.startingDate mt_isWithinSameDay:dateCopy]) {
                
                // if it spans the whole day, make it an all day event
                if ([event spansEntireDayOfDate:dateCopy]) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = YES;
                    
                    // because it's an all day event, we want it at the beginning of the array                    
                    [tempCellDataHolderArray insertObject:cellDataHolder atIndex:0];                    
                } 
                
                // if it ends today but started on a previous day show it at the beginning
                // with a start time of "..."
                else {
                    cellDataHolder.event = event;
                    cellDataHolder.date = nil;
                    cellDataHolder.isAllDay = NO;
                    
                    // because it started before today, we want it at the beginning of the array                    
                    [tempCellDataHolderArray insertObject:cellDataHolder atIndex:0];
                }
                
                [events removeLastObject];                     
                continue;
                
                
                // add the one that occurs first (or exists at all) to the table next.
            } else if (hour && event) {
                
                NSTimeInterval difference = [hour timeIntervalSinceDate:event.startingDate];
                
                // they both occur at the same time
                if (difference == 0) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = NO;
                    [events removeLastObject];
                    [hours removeLastObject];
                    
                    // the event happens before the hour
                } else if (difference > 0) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = NO;
                    [events removeLastObject];
                    
                    // the hour happens before the event
                } else {
                    cellDataHolder.date = hour;
                    cellDataHolder.isAllDay = NO;
                    [hours removeLastObject];
                }
                
                
                // if there are no more events
            } else if (hour) {
                cellDataHolder.date = hour;
                cellDataHolder.isAllDay = NO;
                [hours removeLastObject];
                
                
                // if there are no more hours
            } else if (event) {
                cellDataHolder.event = event;
                cellDataHolder.date = event.startingDate;
                cellDataHolder.isAllDay = NO;
                [events removeLastObject];
                
                
                // nothing left, we're done
            } else {
                break;
            }
            
            [tempCellDataHolderArray addObject:cellDataHolder];
        }
        
        // sort the data holders so that all day events are first, then events that started
        // previously, then events that start today
        [tempCellDataHolderArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
            
            else if (h1.event != nil && h2.event != nil) {
				return [h1.event.startingDate mt_isBefore:h2.event.startingDate] ? NSOrderedAscending : NSOrderedDescending;
            }


            else {
                return NSOrderedAscending;
            }
        }];
        
        
        // update the table with our new event or cell
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // replace the old data holder array with the one we just generated
            self.cellDataHolderArray = [tempCellDataHolderArray mutableCopy];
            
            [self calculateDurationBars];    
            
            [self.tableView reloadData];
            
            if (self.shouldScrollToCurrentHour && [self.selectedDate mt_isWithinSameDay:[NSDate date]]) {
                [self scrollToCurrentHour];
                self.shouldScrollToCurrentHour = NO;
            }
            
        });
    }];
}

- (void)calculateDurationBars 
{
    
	UIColor *primaryBarColor = [UIColor clearColor];
	UIColor *secondaryBarColor = [UIColor clearColor];	
	
	NSInteger primarySecondsLeft = 0;
	NSInteger secondarySecondsLeft = 0;
	
	for (CVEventCellDataHolder *c in _cellDataHolderArray) {
		
		// all day events just clobber the usefulness of the duration bar, so we ignore them.
		if (c.isAllDay) continue;
		
		
		// figure out if this event should show a duration bar
		BOOL shouldShowDurationBar = [CVSettings showDurationOnReadOnlyEvents] || c.event.calendar.allowsContentModifications || c.event.calendar.type == EKCalendarTypeExchange;
		
		if (c.event != nil && shouldShowDurationBar) {
			
			if (primarySecondsLeft == 0) {
				primarySecondsLeft = [c.event durationBarSecondsForDate:self.selectedDate];
				primaryBarColor = [c.event.calendar customColor];
			}
			
			else if (secondarySecondsLeft == 0) {
				secondarySecondsLeft = [c.event durationBarSecondsForDate:self.selectedDate];
				secondaryBarColor = [c.event.calendar customColor];				
			}
		}
		
        c.durationBarColor = primaryBarColor;
		c.secondaryDurationBarColor = secondaryBarColor;
        
		
		
		NSInteger cellIndex = [_cellDataHolderArray indexOfObject:c];
		NSTimeInterval cellDuration = 60*60;
		
		if (cellIndex < [_cellDataHolderArray count] - 1) {
			CVEventCellDataHolder *cplus1 = [_cellDataHolderArray objectAtIndex:cellIndex + 1];
			cellDuration = c.date ? [cplus1.date timeIntervalSinceDate:c.date] : 0;
		}
        
		
		
		if (cellDuration == 0) {
            c.durationBarPercent = 1;
			c.secondaryDurationBarPercent = 1;
			
		} 
		
		else {
			
			if (cellDuration > primarySecondsLeft) {
            	c.durationBarPercent = ( primarySecondsLeft / cellDuration );
				primarySecondsLeft = 0;
			}
			else {
				c.durationBarPercent = 1;
				primarySecondsLeft -= cellDuration;
			}
			
			if (cellDuration > secondarySecondsLeft) {
            	c.secondaryDurationBarPercent = ( secondarySecondsLeft / cellDuration );
				secondarySecondsLeft = 0;
			}
			else {
				c.secondaryDurationBarPercent = 1;
				secondarySecondsLeft -= cellDuration;
			}
			
		}
	}
}

- (void)scrollToCurrentHour 
{
    // scroll to current hour
    NSInteger currentHour = [[NSDate date] mt_hourOfDay];
    for (NSInteger i = 0; i < self.cellDataHolderArray.count; i++) {
        CVEventCellDataHolder *holder = [_cellDataHolderArray objectAtIndex:i];
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
    return [_cellDataHolderArray objectAtIndex:index.row];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    [_cellDataHolderArray removeObjectAtIndex:index.row];
}





#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _cellDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
    
    CVEventCell *cell               = [CVEventCell cellForTableView:tableView];
    CVEventCellDataHolder *holder   = [_cellDataHolderArray objectAtIndex:indexPath.row];

    cell.isEmpty = NO;
    cell.event = holder.event;
    cell.date = holder.date;
    cell.isAllDay = holder.isAllDay;
    cell.durationBarPercent = holder.durationBarPercent;
	cell.secondaryDurationBarPercent = holder.secondaryDurationBarPercent;
    cell.durationBarColor = holder.durationBarColor;
	cell.secondaryDurationBarColor = holder.secondaryDurationBarColor;
    cell.delegate = self;
	[cell resetAccessoryButton];
    holder.cell = cell;
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVEventCell *c = (CVEventCell *)cell;
    [c drawDurationBarAnimated:NO];
    
    if (([c.date mt_hourOfDay] < [CVSettings dayStartHour] || [c.date mt_hourOfDay] >= [CVSettings dayEndHour]) || c.event.allDay) {
        c.backgroundColor = RGBHex(0xF6F6F6);
    }
    else {
        c.backgroundColor = RGBHex(0xFFFFFF);
    }
}




@end
