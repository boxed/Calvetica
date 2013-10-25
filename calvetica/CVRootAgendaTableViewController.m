//
//  CVEventsAgendaTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootAgendaTableViewController.h"
#import "CVReminderCell.h"
#import "CVCalendarItemCellModel.h"
#import "EKCalendarItem+Common.h"
#import "CVRootTableViewController_Protected.h"


@implementation CVRootAgendaTableViewController


#pragma mark - Public

- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];
    
    // date can't be null
    if (!self.selectedDate) return;

    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    void (^processCalendarItems)(NSMutableArray *) = ^(NSMutableArray *calendarItems) {
        // create cell data holders
        NSMutableArray *tempArray = [NSMutableArray array];
        for (EKCalendarItem *calendarItem in calendarItems) {

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
            else if (calendarItem.isEvent && [(EKEvent *)calendarItem spansEntireDayOfDate:dateCopy]) {
                cellModel.calendarItem = calendarItem;
                cellModel.date         = calendarItem.mys_date;
                cellModel.isAllDay     = YES;
                [tempArray addObject:cellModel];
            }

            // if event started before date (but obviously cant end after it) show it at the beginning
            // with a start time of "..."
            else if (![calendarItem.mys_date mt_isWithinSameDay:dateCopy]) {
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

        [tempArray sortUsingComparator:^NSComparisonResult(CVCalendarItemCellModel *model1,
                                                           CVCalendarItemCellModel *model2)
         {
             return [model1.calendarItem compareWithCalendarItem:model2.calendarItem];
         }];

        [MTq main:^{
            // replace the old data holder array with the one we just generated
            self.cellModelArray = [tempArray mutableCopy];
            // add a "No Events" placeholder
            if ([self.cellModelArray count] == 0) {
                [self.cellModelArray addObject:[NSNull null]];
            }
            [self.tableView reloadData];
            if (completion) completion();
        }];
    };

    [MTq def:^{
        NSDate *startDate = dateCopy;
        NSDate *endDate = [dateCopy mt_endOfCurrentDay];
        BOOL isToday = [dateCopy mt_isWithinSameDay:[NSDate date]];

        // fetch the events
        NSMutableArray *calendarItems = [[EKEventStore eventsFromDate:startDate
                                                               toDate:endDate
                                                   forActiveCalendars:YES] mutableCopy];

        if (PREFS.showReminders) {
            // if reminders are cached, just do one completion call. Otherwise do two, one when events are done
            // and another when remindrs are done.
            [[EKEventStore sharedStore] remindersFromDate:startDate
                                                   toDate:endDate
                                                calendars:nil
                                                  options:0
                                               completion:^(NSArray *reminders)
             {
                 reminders = [reminders filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKReminder *reminder, NSDictionary *bindings) {
                     return !reminder.isFloating || isToday;
                 }]];
                 [calendarItems addObjectsFromArray:reminders];
                 processCalendarItems(calendarItems);
             }];

        }
        else {
            processCalendarItems(calendarItems);
        }
    }];
}




#pragma mark - DELEGATE table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellModelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];

    if (!model.isNull) {
        EKCalendarItem *calendarItem = model.calendarItem;
        if (calendarItem.isEvent) {
            EKEvent *event                  = (EKEvent *)calendarItem;

            CVEventCell *cell               = [CVEventCell cellForTableView:tableView];
            cell.isEmpty                    = NO;
            cell.event                      = event;
            cell.date                       = model.date;
            cell.isAllDay                   = model.isAllDay;

            cell.durationBarPercent         = 0;
            cell.durationBarColor           = [UIColor clearColor];
            cell.secondaryDurationBarColor  = [UIColor clearColor];
            cell.delegate                   = self;

            [cell resetAccessoryButton];
            [cell drawDurationBarAnimated:NO];

            return cell;
        }
        else {
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

                if ([CVSettings isTwentyFourHourFormat]) {
                    cell.timeLabel.text = [startDate mt_stringFromDateWithFormat:@"H:mm" localized:NO];
                }
                else {
                    cell.timeLabel.text = [startDate mt_stringFromDateWithFormat:@"h:mm" localized:NO];
                }

                if ([CVSettings isTwentyFourHourFormat]) {
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

            UIColor *calendarColor      = [UIColor colorWithCGColor:reminder.calendar.CGColor];
            cell.coloredDotView.color   = calendarColor;
            cell.coloredDotView.shape   = CVColoredShapeCheck;
            cell.backgroundColor        = [calendarColor colorWithAlphaComponent:0.1];

            return cell;
        }
    }
    else {
        CVEventCell *cell = [CVEventCell cellForTableView:tableView];
        cell.isEmpty = YES;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];
    if (!model.isNull) {
        EKCalendarItem *calendarItem = model.calendarItem;
        if (calendarItem.isReminder) {
            return CVRootTableViewReminderRowHeight;
        }
    }
    return CVRootTableViewEventRowHeight;
}




#pragma mark - DELEGATE cell view

- (void)calendarItemCell:(UITableViewCell *)cell tappedDeleteForItem:(EKCalendarItem *)calendarItem
{
    for (CVCalendarItemCellModel *model in [self.cellModelArray copy]) {
        if ([model.calendarItem isEqualToCalendarItem:calendarItem]) {
            [self.cellModelArray removeObject:model];
        }
    }
    [super calendarItemCell:cell tappedDeleteForItem:calendarItem];
}


@end
