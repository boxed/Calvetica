//
//  CVEventsWeekStdAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootDetailedWeekTableViewController.h"
#import "CVCalendarItemCellModel.h"
#import "UIView+Nibs.h"
#import "CVTableSectionHeaderView.h"
#import "CVRootTableViewController_Protected.h"
#import "CVReminderCell.h"


@interface CVRootDetailedWeekTableViewController ()
@property (nonatomic, copy) NSArray *daysOfWeekArray;
@end


@implementation CVRootDetailedWeekTableViewController

#pragma mark - Public

- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];

    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }

    // date can't be null
    if (!self.selectedDate) return;
    
    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    void (^processCalendarItems)(NSMutableArray *, NSDate *, NSDate *) = ^(NSMutableArray *calendarItems,
                                                                           NSDate *startDate,
                                                                           NSDate *endDate)
    {
        // get the days of the current week
        self.daysOfWeekArray = [NSDate mt_datesCollectionFromDate:startDate
                                                        untilDate:[endDate mt_oneDayNext]];

        NSDate *today = [NSDate date];

        NSMutableArray *tempDaysArray = [NSMutableArray array];

        // fetch events for each day of the daysOfWeekArray
        for (NSDate *weekDay in self.daysOfWeekArray) {

            // create cell data holders
            NSMutableArray *tempArray = [NSMutableArray array];

            // get todays events
            NSArray *todaysItems = [calendarItems filteredArrayUsingPredicate:
                                    [NSPredicate predicateWithBlock:^BOOL(EKCalendarItem *calendarItem,
                                                                          NSDictionary *bindings)
                                     {
                                         if (calendarItem.isEvent) {
                                             EKEvent *event = (EKEvent *)calendarItem;
                                             return [event occursAtAllBetweenDate:[weekDay mt_startOfCurrentDay]
                                                                          andDate:[weekDay mt_endOfCurrentDay]];
                                         }
                                         if (calendarItem.isReminder && [(EKReminder *)calendarItem isFloating]) {
                                             return [weekDay mt_isWithinSameDay:today];
                                         }
                                         return [calendarItem.mys_date mt_isWithinSameDay:weekDay];
                                     }]];

            for (EKCalendarItem *calendarItem in todaysItems) {

                // create data holder
                CVCalendarItemCellModel *cellModel = [CVCalendarItemCellModel new];

                // if the event is all day
                if (calendarItem.mys_isAllDay) {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = calendarItem.mys_date;
                    cellModel.isAllDay     = YES;
                    [tempArray addObject:cellModel];
                }

                // if it spans the whole day, make it an all day event
                else if (calendarItem.isEvent && [(EKEvent *)calendarItem spansEntireDayOfDate:weekDay]) {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = calendarItem.mys_date;
                    cellModel.isAllDay     = YES;
                    [tempArray addObject:cellModel];
                }

                // if event started before date (but obviously cant end after it) show it at the beginning
                // with a start time of "..."
                else if (![calendarItem.mys_date mt_isWithinSameDay:weekDay]) {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = nil;
                    cellModel.isAllDay     = NO;
                    [tempArray addObject:cellModel];
                }

                else {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = calendarItem.mys_date;
                    cellModel.isAllDay     = NO;
                    [tempArray addObject:cellModel];
                }
            }

            // sort the data holders so that all day events are first, then events that started
            // previously, then events that start today
            [tempArray sortUsingComparator:^NSComparisonResult(CVCalendarItemCellModel *model1,
                                                               CVCalendarItemCellModel *model2)
             {
                 return [model1.calendarItem compareWithCalendarItem:model2.calendarItem];
             }];

            [tempDaysArray addObject:tempArray];
        }

        // update the table with our new event or cell
        [MTq main:^{
            // Only update if we're still the active controller for this tableView
            if (self.tableView.dataSource != self) return;

            self.cellModelArray = [tempDaysArray mutableCopy];
            [self.tableView reloadData];
            if (completion) completion();
        }];
    };

    [MTq def:^{

        NSDate *startDate   = [dateCopy mt_startOfCurrentWeek];
        NSDate *endDate     = [dateCopy mt_endOfCurrentWeek];

        // fetch the events
        NSMutableArray *calendarItems = [[EKEventStore eventsFromDate:startDate
                                                               toDate:[endDate mt_endOfCurrentDay]
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
                 processCalendarItems(calendarItems, startDate, endDate);
             }];
        }
        else {
            processCalendarItems(calendarItems, startDate, endDate);
        }
    }];
    
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    for (NSInteger i = 0; i < self.daysOfWeekArray.count; i++) {
        NSDate *d = [self.daysOfWeekArray objectAtIndex:i];
        if ([d mt_isWithinSameDay:date]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            if ([self.tableView numberOfSections] > indexPath.section &&
                [self.tableView numberOfRowsInSection:indexPath.section] > indexPath.row)
            {
                [self.tableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:animated];
            }
            break;
        }
    }
}

- (void)removeCalendarItem:(EKCalendarItem *)calendarItem
{
    for (NSMutableArray *models in self.cellModelArray) {
        for (CVCalendarItemCellModel *model in [models copy]) {
            if ([model.calendarItem isEqualToCalendarItem:calendarItem]) {
                [models removeObject:model];
                break;
            }
        }
    }
}




#pragma mark - DELEGATE table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return self.daysOfWeekArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSArray *calendarItems = [self.cellModelArray objectAtIndex:section];
    return [calendarItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSArray *models                 = self.cellModelArray[indexPath.section];
    CVCalendarItemCellModel *model  = models[indexPath.row];
    EKCalendarItem *calendarItem    = model.calendarItem;

    if (calendarItem.isEvent) {
        CVEventCell *cell               = [CVEventCell cellForTableView:tableView];
        cell.isEmpty                    = NO;
        cell.event                      = (EKEvent *)model.calendarItem;
        cell.date                       = model.date;
        cell.isAllDay                   = model.isAllDay;
        cell.durationBarPercent         = 0;
        cell.durationBarColor           = patentedClear;
        cell.secondaryDurationBarColor  = patentedClear;
        cell.delegate                   = self;
        [cell resetAccessoryButton];
        [cell drawDurationBarAnimated:NO];
        return cell;
    }
    else if (calendarItem.isReminder) {
        EKReminder *reminder = (EKReminder *)calendarItem;

        CVReminderCell *cell = [CVReminderCell cellForTableView:tableView];
        if (reminder.completed && reminder.title) {
            NSAttributedString *attributedTitle =
            [[NSAttributedString alloc] initWithString:reminder.title
                                            attributes:@{ NSStrikethroughStyleAttributeName: @(YES) }];
            cell.titleLabel.attributedText = attributedTitle;
        }
        else {
            cell.titleLabel.text = reminder.title;
        }

        if (model.isAllDay) {
            cell.timeLabel.hidden   = YES;
            cell.AMPMLabel.hidden   = YES;
            cell.allDayLabel.hidden = NO;
        }
        else {
            cell.timeLabel.hidden   = NO;
            cell.AMPMLabel.hidden   = NO;
            cell.allDayLabel.hidden = YES;

            NSDate *startDate = model.date;

            if (PREFS.twentyFourHourFormat) {
                cell.timeLabel.text = [startDate mt_stringFromDateWithFormat:@"H:mm" localized:NO];
            }
            else {
                cell.timeLabel.text = [startDate mt_stringFromDateWithFormat:@"h:mm" localized:NO];
            }

            if (PREFS.twentyFourHourFormat) {
                cell.AMPMLabel.hidden   = YES;
            }
            else {
                cell.AMPMLabel.hidden   = NO;
                cell.AMPMLabel.text     = [startDate mt_stringFromDateWithAMPMSymbol];
            }

            if (![startDate mt_isStartOfAnHour]) {
                cell.AMPMLabel.alpha    = 0.8f;
                cell.titleLabel.alpha   = 0.8f;
            }
            else {
                cell.AMPMLabel.alpha    = 1;
                cell.titleLabel.alpha   = 1;
            }
        }

        UIColor *calendarColor      = reminder.calendar.customColor;
        cell.coloredDotView.color   = calendarColor;
        cell.coloredDotView.shape   = CVColoredShapeCheck;
        cell.backgroundColor        = [calendarColor colorWithAlphaComponent:0.1];

        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *models                 = self.cellModelArray[indexPath.section];
    CVCalendarItemCellModel *model  = models[indexPath.row];
    EKCalendarItem *calendarItem    = model.calendarItem;

    if (calendarItem.isReminder) {
        return CVRootTableViewReminderRowHeight;
    }
    return CVRootTableViewEventRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSArray *models                 = self.cellModelArray[indexPath.section];
    CVCalendarItemCellModel *model  = models[indexPath.row];
    EKCalendarItem *calendarItem    = model.calendarItem;
    if (calendarItem.isReminder) {
        EKReminder *reminder = (EKReminder *)model.calendarItem;
        reminder.completed = !reminder.completed;
        [reminder saveWithError:nil];
        CVReminderCell *cell = (CVReminderCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.titleLabel toggleStrikeThroughWithCompletion:^{
            [self.delegate rootTableViewController:self cell:cell updatedItem:reminder];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    NSDate *day                             = [self.daysOfWeekArray objectAtIndex:section];
    CVTableSectionHeaderView *sectionView   = [CVTableSectionHeaderView fromNibOfSameName];
    NSString *title                         = [[day stringWithTitleOfCurrentWeekDayAndMonthDayAbbreviated:NO] lowercaseString];
    sectionView.weekdayLabel.text           = title;
    sectionView.backgroundColor             = [day mt_isWithinSameDay:[NSDate date]] ? patentedRed : patentedDarkGrayWeekdayHeader();

    return sectionView;
}


@end
