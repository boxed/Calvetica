//
//  CVEventsWeekAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootWeekTableViewController.h"
#import "CVCalendarItemCellModel.h"
#import "CVAgendaDateCell.h"
#import "dimensions.h"
#import "CVAgendaEventCell.h"
#import "CVWeekNumberCell.h"
#import "NSString+Utilities.h"
#import "CVRootTableViewController_Protected.h"
#import "EKCalendarItem+Common.h"


@implementation CVRootWeekTableViewController


#pragma mark - Public

- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    void (^processCalendarItems)(NSMutableArray *) = ^(NSMutableArray *calendarItems) {

        NSMutableArray *tempArray = [NSMutableArray array];

        NSDate *today = [NSDate date];

        // for each day
        NSDate *startOfWeek = [dateCopy mt_startOfCurrentWeek];

        for (int i = 6; i >= 0; i--) {
            NSDate *day =  [startOfWeek mt_dateByAddingYears:0 months:0 weeks:0 days:i hours:0 minutes:0 seconds:0];

            // create a cell for the title of the day
            [tempArray addObject:day];

            // get todays events
            NSArray *todaysItems = [calendarItems filteredArrayUsingPredicate:
                                    [NSPredicate predicateWithBlock:^BOOL(EKCalendarItem *calendarItem,
                                                                          NSDictionary *bindings)
                                     {
                                         if (calendarItem.isEvent) {
                                             EKEvent *event = (EKEvent *)calendarItem;
                                             return [event occursAtAllBetweenDate:[day mt_startOfCurrentDay]
                                                                          andDate:[day mt_endOfCurrentDay]];
                                         }
                                         if (calendarItem.isReminder && [(EKReminder *)calendarItem isFloating]) {
                                             return [day mt_isWithinSameDay:today];
                                         }
                                         return [calendarItem.mys_date mt_isWithinSameDay:day];
                                     }]];


            for (EKCalendarItem *calendarItem in todaysItems) {

                // create data holder
                CVCalendarItemCellModel *cellModel = [CVCalendarItemCellModel new];

                // if the event is all day
                if (calendarItem.mys_isAllDay) {
                    cellModel.calendarItem              = calendarItem;
                    cellModel.date                      = day;
                    cellModel.isAllDay                  = YES;
                    cellModel.continuedFromPreviousDay  = NO;
                }

                // if event started before date
                else if (![calendarItem.mys_date mt_isWithinSameDay:day]) {

                    // if it spans the whole day, make it an all day event
                    if (calendarItem.isEvent && [(EKEvent *)calendarItem spansEntireDayOfDate:day]) {
                        cellModel.calendarItem              = calendarItem;
                        cellModel.date                      = day;
                        cellModel.isAllDay                  = YES;
                        cellModel.continuedFromPreviousDay  = NO;
                    }

                    // if it ends today but started on a previous day show it at the beginning
                    // with a start time of "..."
                    else {
                        cellModel.calendarItem              = calendarItem;
                        cellModel.date                      = day;
                        cellModel.isAllDay                  = NO;
                        cellModel.continuedFromPreviousDay  = calendarItem.isEvent;
                    }
                }

                else {
                    cellModel.calendarItem              = calendarItem;
                    cellModel.date                      = calendarItem.mys_date;
                    cellModel.isAllDay                  = NO;
                    cellModel.continuedFromPreviousDay  = NO;
                }

                [tempArray addObject:cellModel];
            }
        }

        // sort the data holders so that all day events are first, then events that started
        // previously, then events that start today
        [tempArray sortUsingComparator:^NSComparisonResult(CVCalendarItemCellModel *h1, CVCalendarItemCellModel *h2) {

            // The week number is first and the friendly phrase is last.
            if ([h1 isKindOfClass:[NSDate class]] && [h2 isKindOfClass:[NSDate class]]) {
                NSDate *d1 = (NSDate *)h1;
                NSDate *d2 = (NSDate *)h2;
                return [d1 compare:d2];
            }

            else if ([h1 isKindOfClass:[NSDate class]] && [h2 isKindOfClass:[CVCalendarItemCellModel class]]) {
                NSDate *d1 = (NSDate *)h1;
                NSDate *d2 = h2.date;
                return [d1 compare:d2];
            }

            else if ([h2 isKindOfClass:[NSDate class]] && [h1 isKindOfClass:[CVCalendarItemCellModel class]]) {
                NSDate *d1 = (NSDate *)h2;
                NSDate *d2 = h1.date;
                return [d2 compare:d1];
            }

            else if ([h1.calendarItem class] != [h2.calendarItem class]) {
                return h1.calendarItem.isEvent ? NSOrderedAscending : NSOrderedDescending;
            }

            else if (h1.calendarItem.mys_date == nil && h2.calendarItem.mys_date == nil) {
                return [h1.calendarItem.mys_title localizedCaseInsensitiveCompare:h2.calendarItem.mys_title];
            }

            else if (h1.calendarItem.mys_date == nil || h2.calendarItem.mys_date == nil) {
                return h2.calendarItem.mys_date == nil ? NSOrderedAscending : NSOrderedDescending;
            }

            else {
                return [h1.date compare:h2.date];
            }
        }];
        
        // update the table with our new event or cell
        [MTq main:^{
            // replace the old data holder array with the one we just generated
            self.cellModelArray = [tempArray mutableCopy];
            [self.tableView reloadData];
            if (completion) completion();
        }];
    };

    [MTq def:^{
        NSDate *startDate = [dateCopy mt_startOfCurrentWeek];
        NSDate *endDate = [dateCopy mt_endOfCurrentWeek];

        // fetch the events
        NSMutableArray *calendarItems = [[EKEventStore eventsFromDate:startDate
                                                               toDate:endDate
                                                   forActiveCalendars:YES] mutableCopy];

        if (PREFS.remindersEnabled) {
            // if reminders are cached, just do one completion call. Otherwise do two, one when events are done
            // and another when remindrs are done.
            [[EKEventStore sharedStore] remindersFromDate:startDate
                                                   toDate:endDate
                                                calendars:nil
                                                  options:0
                                               completion:^(NSArray *reminders)
             {
                 [calendarItems addObjectsFromArray:reminders];
                 processCalendarItems(calendarItems);
             }];
        }
        else {
            processCalendarItems(calendarItems);
        }
    }];
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    for (NSInteger i = 0; i < self.cellModelArray.count; i++) {
        CVCalendarItemCellModel *model = self.cellModelArray[i];
        if ([model isKindOfClass:[NSDate class]]) {
            NSDate *dayDate = (NSDate *)model;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            if ([date mt_isWithinSameDay:dayDate] &&
                [self.tableView numberOfSections] > indexPath.section &&
                [self.tableView numberOfRowsInSection:indexPath.section] > indexPath.row)
            {

                [self.tableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:animated];
                break;
            }
        }
    }
}




#pragma mark - DELEGATE table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.cellModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];

	if ([model isKindOfClass:[CVCalendarItemCellModel class]] && model.calendarItem) {

        CVAgendaEventCell *cell = [CVAgendaEventCell cellForTableView:tableView];
        [cell setCalendarItem:model.calendarItem
                    continued:model.continuedFromPreviousDay
                       allDay:model.isAllDay];
        cell.delegate = self;
        cell.titleLabel.numberOfLines = 0;
        return cell;
    }

    else if ([model isKindOfClass:[NSDate class]]) {
        CVAgendaDateCell *cell  = [CVAgendaDateCell cellForTableView:tableView];
        cell.date               = (NSDate *)model;
        return cell;
	}

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = [self.cellModelArray objectAtIndex:indexPath.row];

    if ([model isKindOfClass:[NSDate class]]) {
        return TABLE_ROW_DAY_TITLE_HEIGHT;
    }

    UIFont *footnoteFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    CGFloat height = [model.calendarItem.mys_title boundingRectWithSize:CGSizeMake(212, FLT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{ NSFontAttributeName : footnoteFont }
                                                                context:NULL].size.height + 6;

	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = [self.cellModelArray objectAtIndex:indexPath.row];
	if ([model isKindOfClass:[NSDate class]]) {
        NSDate *date = (NSDate *)model;
        [self.delegate rootTableViewController:self didScrollToDay:date];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];
        if (model.calendarItem.isReminder) {
            EKReminder *reminder = (EKReminder *)model.calendarItem;
            reminder.completed = !reminder.completed;
            [reminder saveWithError:nil];
            CVAgendaEventCell *cell = (CVAgendaEventCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell.calendarItemTitleLabel toggleStrikeThroughWithCompletion:^{
                [self.delegate rootTableViewController:self cell:cell updatedItem:reminder];
            }];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger weekOfYear        = [self.selectedDate mt_weekOfYear];
    CVWeekNumberCell *cell      = [CVWeekNumberCell cellForTableView:tableView];
    cell.weekNumberLabel.text   = 
    [NSString stringWithFormat:NSLocalizedString(@"Week %1$i",
                                                 @"The week number of a selected date. %1$i: the week number."),
     weekOfYear];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WEEK_NUM_CELL_HEIGHT;
}


@end
