//
//  CVEventsWeekAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventsWeekAgendaTableViewController.h"
#import "CVEventCellDataHolder.h"
#import "CVAgendaDateCell.h"
#import "dimensions.h"
#import "CVAgendaEventCell.h"
#import "CVWeekNumberCell.h"
#import "NSString+Utilities.h"


@interface CVEventsWeekAgendaTableViewController ()
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@end


@implementation CVEventsWeekAgendaTableViewController


- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    [MTq def:^{

        NSMutableArray *tempCellDataHolderArray = [NSMutableArray array];
		
        NSInteger weekOfYear = [self.selectedDate mt_weekOfYear];
        [tempCellDataHolderArray addObject:@(weekOfYear)];
        
        // for each day
		NSDate *startOfWeek = [dateCopy mt_startOfCurrentWeek];
        for (int i = 6; i >= 0; i--) {
            NSDate *day =  [startOfWeek mt_dateByAddingYears:0 months:0 weeks:0 days:i hours:0 minutes:0 seconds:0];
			
			// create a cell for the title of the day
            CVEventCellDataHolder *dayTitleRow = [[CVEventCellDataHolder alloc] init];
			dayTitleRow.event = nil;
			dayTitleRow.date = day;
			dayTitleRow.isAllDay = NO;
			dayTitleRow.continuedFromPreviousDay = NO;
			[tempCellDataHolderArray addObject:dayTitleRow];
			
			// fetch the events
			NSMutableArray *events = [NSMutableArray arrayWithArray:[EKEventStore eventsFromDate:day toDate:[day mt_endOfCurrentDay] forActiveCalendars:YES]];
            
            // sort the events
            [events sortUsingComparator:(NSComparator)^(id obj1, id obj2){
                EKEvent *e1 = obj1;
                EKEvent *e2 = obj2;
                return [e1 compareStartDateWithEvent:e2];
            }];			
            
            
            for (EKEvent *event in events) {
                
                // create data holder
                CVEventCellDataHolder *cellDataHolder = [[CVEventCellDataHolder alloc] init];
                
                // if the event is all day
                if (event.allDay) {
                    cellDataHolder.event = event;
                    cellDataHolder.date = day;
                    cellDataHolder.isAllDay = YES;
                    cellDataHolder.continuedFromPreviousDay = NO;
                }
                
                // if event started before date
                else if (![event.startingDate mt_isWithinSameDay:day]) {
                    
                    // if it spans the whole day, make it an all day event
                    if ([event spansEntireDayOfDate:day]) {
                        cellDataHolder.event = event;
                        cellDataHolder.date = day;
                        cellDataHolder.isAllDay = YES;
                        cellDataHolder.continuedFromPreviousDay = NO;
                    } 
                    
                    // if it ends today but started on a previous day show it at the beginning
                    // with a start time of "..."
                    else {
                        cellDataHolder.event = event;
                        cellDataHolder.date = day;
                        cellDataHolder.isAllDay = NO;
                        cellDataHolder.continuedFromPreviousDay = YES;
                    }
                }
                
                else {
                    cellDataHolder.event = event;
                    cellDataHolder.date = event.startingDate;
                    cellDataHolder.isAllDay = NO;
                    cellDataHolder.continuedFromPreviousDay = NO;
                }
                
                [tempCellDataHolderArray addObject:cellDataHolder];
            }
        }
		
        // sort the data holders so that all day events are first, then events that started
        // previously, then events that start today
        [tempCellDataHolderArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CVEventCellDataHolder *h1 = obj1;
            CVEventCellDataHolder *h2 = obj2;

            // The week number is first and the friendly phrase is last.
            if ([h1 isKindOfClass:[NSNumber class]] || [h2 isKindOfClass:[NSNumber class]]) {
                return NSOrderedAscending;
            }
            else {

                // if the dates are not equal, order them in chrono order
                if (![h1.date isEqualToDate:h2.date]) {
					return [h1.date mt_isBefore:h2.date] ? NSOrderedAscending : NSOrderedDescending;
                }
                
                // if one doesn't have an event, its a title and should go before all other cells for that date
                else if ((h1.event == nil) != (h2.event == nil)) {
                    return h1.event == nil ? NSOrderedAscending : NSOrderedDescending;
                }
                
                // events continuing from a previous date should go before all day and regular events
                else if (h1.continuedFromPreviousDay != h2.continuedFromPreviousDay) {
                    return h1.continuedFromPreviousDay ? NSOrderedAscending : NSOrderedDescending;
                }
                
                // all day events should be next
                else if (h1.isAllDay != h2.isAllDay) {
                    return h1.isAllDay ? NSOrderedAscending : NSOrderedDescending;
                }

                else if (h1.isAllDay && h2.isAllDay) {
                    return [h1.event.title localizedCaseInsensitiveCompare:h2.event.title];
                }

                // finally, sort regular events by start time
                else {
					return [h1.event.startingDate mt_isBefore:h2.event.startingDate] ? NSOrderedAscending : NSOrderedDescending;
                }
            }
        }];
        
        // update the table with our new event or cell
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // replace the old data holder array with the one we just generated
            self.cellDataHolderArray = [tempCellDataHolderArray mutableCopy];

            [self.tableView reloadData];

            if (completion) completion();
            
        });
    }];
}

- (void)scrollToDate:(NSDate *)date 
{
    for (NSInteger i = 0; i < self.cellDataHolderArray.count; i++) {
        CVEventCellDataHolder *eventHolder = [self.cellDataHolderArray objectAtIndex:i];

        if ([eventHolder isKindOfClass:[CVEventCellDataHolder class]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            if (!eventHolder.event  &&
                eventHolder.date    &&
                [eventHolder.date mt_isWithinSameDay:self.selectedDate] &&
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
}




#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.cellDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVEventCellDataHolder *eventHolder = [self.cellDataHolderArray objectAtIndex:indexPath.row];
    
	CVCell *returnCell = nil;
	
	if ([eventHolder isKindOfClass:[CVEventCellDataHolder class]]) {

        if (eventHolder.event) {
            CVAgendaEventCell *cell = [CVAgendaEventCell cellForTableView:tableView];
            [cell setEvent:eventHolder.event continued:eventHolder.continuedFromPreviousDay allDay:eventHolder.isAllDay];
            cell.delegate = self;
            
            
            // call the NSString category method to set the number of lines for the textLabel
            CGFloat width;
            if (PAD) {
                width = TABLE_ROW_EVENT_WIDTH_IPAD;
            }
            else {
                width = TABLE_ROW_EVENT_WIDTH_IPHONE;
            }
            cell.titleLabel.numberOfLines = [cell.titleLabel.text linesOfWordWrapTextWithFont:[UIFont systemFontOfSize:13] constraintWidth:width];
            
            returnCell = cell;
        } else if (eventHolder.date) {
            CVAgendaDateCell *cell = [CVAgendaDateCell cellForTableView:tableView];
            cell.date = eventHolder.date;
            returnCell = cell;	
        }
	} else if ([eventHolder isKindOfClass:[NSNumber class]]) {
        returnCell = [CVWeekNumberCell cellForTableView:tableView];
        NSInteger weekOfYearNumber = [(NSNumber *)eventHolder integerValue];
        ((CVWeekNumberCell *)returnCell).weekNumberLabel.text =
        [NSString stringWithFormat:NSLocalizedString(@"Week %1$i",
                                                     @"The week number of a selected date. %1$i: the week number."),
         weekOfYearNumber];
    }
	
    return returnCell;
}




#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVEventCellDataHolder *eventHolder = [self.cellDataHolderArray objectAtIndex:indexPath.row];

    if ([eventHolder isKindOfClass:[NSNumber class]]) {
        return WEEK_NUM_CELL_HEIGHT;
    }

    // call the NSString category method to set the cell height of the regular cells
    // add a little padding to keep padding consistent
    CGFloat width;
    if (PAD) {
        width = TABLE_ROW_EVENT_WIDTH_IPAD;
    }
    else {
        width = TABLE_ROW_EVENT_WIDTH_IPHONE;
    }
    CGFloat height = [eventHolder.event.title totalHeightOfWordWrapTextWithFont:[UIFont systemFontOfSize:13] constraintWidth:width] + 3;
    
	return eventHolder.event == nil ? TABLE_ROW_DAY_TITLE_HEIGHT : height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	id cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[CVAgendaEventCell class]]) {
        [self.delegate rootTableViewController:self tappedCell:(CVEventCell *)cell];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	else if ([cell isKindOfClass:[CVAgendaDateCell class]]) {
		CVAgendaDateCell *theCell = (CVAgendaDateCell *)cell;
        [self.delegate rootTableViewController:self didScrollToDay:theCell.date];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


@end
