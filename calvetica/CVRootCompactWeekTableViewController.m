//
//  CVRootCompactWeekTableViewController.m
//  calvetica
//
//  Compact week view with date/weekday column, showing week at a glance.
//

#import "CVRootCompactWeekTableViewController.h"
#import "CVCalendarItemCellModel.h"
#import "CVRootTableViewController_Protected.h"
#import "CVCompactWeekEventCell.h"
#import "CVCompactWeekReminderCell.h"


@interface CVRootCompactWeekTableViewController ()
@property (nonatomic, copy) NSArray *daysOfWeekArray;
@property (nonatomic, strong) UILabel *weekNumberLabel;
@end


@implementation CVRootCompactWeekTableViewController

#pragma mark - Public

- (void)viewDidDisappear:(BOOL)animated
{
    [self.weekNumberLabel removeFromSuperview];
}

- (void)updateAppearanceForTraitChange
{
    [super updateAppearanceForTraitChange];
    self.weekNumberLabel.textColor = patentedBlack();
}

- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];

    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }

    // Week number label at top right
    if (self.weekNumberLabel == nil) {
        CGRect frame = self.tableView.frame;
        frame.size.height = 25;
        frame.size.width -= 4;
        self.weekNumberLabel = [[UILabel alloc] initWithFrame:frame];
        self.weekNumberLabel.textAlignment = NSTextAlignmentRight;
        self.weekNumberLabel.textColor = patentedBlack();
        [self.tableView.superview addSubview:self.weekNumberLabel];
    }

    self.weekNumberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Week %1$i",
                                                                              @"The week number of a selected date. %1$i: the week number."),
                                  (int)[self.selectedDate mt_weekOfYear]];

    if (!self.selectedDate) return;

    NSDate *dateCopy = [self.selectedDate copy];

    void (^processCalendarItems)(NSMutableArray *, NSDate *, NSDate *) = ^(NSMutableArray *calendarItems,
                                                                            NSDate *startDate,
                                                                            NSDate *endDate)
    {
        self.daysOfWeekArray = [NSDate mt_datesCollectionFromDate:startDate
                                                        untilDate:[endDate mt_oneDayNext]];

        NSDate *today = [NSDate date];
        NSMutableArray *flatItems = [NSMutableArray array];

        for (NSDate *weekDay in self.daysOfWeekArray) {
            NSMutableArray *dayItems = [NSMutableArray array];

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
                CVCalendarItemCellModel *cellModel = [CVCalendarItemCellModel new];

                if (calendarItem.mys_isAllDay) {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = calendarItem.mys_date;
                    cellModel.isAllDay     = YES;
                    [dayItems addObject:cellModel];
                }
                else if (calendarItem.isEvent && [(EKEvent *)calendarItem spansEntireDayOfDate:weekDay]) {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = calendarItem.mys_date;
                    cellModel.isAllDay     = YES;
                    [dayItems addObject:cellModel];
                }
                else if (![calendarItem.mys_date mt_isWithinSameDay:weekDay]) {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = nil;
                    cellModel.isAllDay     = NO;
                    [dayItems addObject:cellModel];
                }
                else {
                    cellModel.calendarItem = calendarItem;
                    cellModel.date         = calendarItem.mys_date;
                    cellModel.isAllDay     = NO;
                    [dayItems addObject:cellModel];
                }
            }

            [dayItems sortUsingComparator:^NSComparisonResult(CVCalendarItemCellModel *model1,
                                                              CVCalendarItemCellModel *model2)
             {
                 return [model1.calendarItem compareWithCalendarItem:model2.calendarItem];
             }];

            // Mark first item of each day
            BOOL isFirstOfDay = YES;
            for (CVCalendarItemCellModel *model in dayItems) {
                model.isFirstOfDay = isFirstOfDay;
                model.dayDate = weekDay;  // Store the day for this item
                isFirstOfDay = NO;
                [flatItems addObject:model];
            }
        }

        [MTq main:^{
            self.cellModelArray = flatItems;
            [self.tableView reloadData];
            if (completion) completion();
        }];
    };

    [MTq def:^{
        NSDate *startDate   = [dateCopy mt_startOfCurrentWeek];
        NSDate *endDate     = [dateCopy mt_endOfCurrentWeek];

        NSMutableArray *calendarItems = [[EKEventStore eventsFromDate:startDate
                                                               toDate:[endDate mt_endOfCurrentDay]
                                                   forActiveCalendars:YES] mutableCopy];

        if (PREFS.remindersEnabled) {
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
    for (NSInteger i = 0; i < self.cellModelArray.count; i++) {
        CVCalendarItemCellModel *model = self.cellModelArray[i];
        if (model.isFirstOfDay && [model.dayDate mt_isWithinSameDay:date]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:animated];
            break;
        }
    }
}

- (void)removeCalendarItem:(EKCalendarItem *)calendarItem
{
    NSMutableArray *mutableArray = [self.cellModelArray mutableCopy];
    for (CVCalendarItemCellModel *model in [mutableArray copy]) {
        if ([model.calendarItem isEqualToCalendarItem:calendarItem]) {
            [mutableArray removeObject:model];
            break;
        }
    }
    self.cellModelArray = mutableArray;
}


#pragma mark - Helper

- (NSString *)dayLabelTextForDate:(NSDate *)date
{
    if (!date) return nil;
    NSString *weekday = [[date stringWithTitleOfCurrentWeekDayAbbreviated:YES] uppercaseString];
    return [NSString stringWithFormat:@"%@ %lu", weekday, (unsigned long)[date mt_dayOfMonth]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];
    EKCalendarItem *calendarItem = model.calendarItem;

    // Always set dayText (empty string for non-first rows) to ensure column alignment
    NSString *dayText = model.isFirstOfDay ? [self dayLabelTextForDate:model.dayDate] : @"";

    if (calendarItem.isEvent) {
        CVCompactWeekEventCell *cell = [CVCompactWeekEventCell cellForTableView:tableView];
        cell.event      = (EKEvent *)model.calendarItem;
        cell.date       = model.date;
        cell.isAllDay   = model.isAllDay;
        cell.delegate   = self;
        cell.dayLabelText = dayText;
        [cell resetAccessoryButton];
        return cell;
    }
    else if (calendarItem.isReminder) {
        EKReminder *reminder = (EKReminder *)calendarItem;

        CVCompactWeekReminderCell *cell = [CVCompactWeekReminderCell cellForTableView:tableView];
        if (reminder.completed && reminder.title) {
            NSAttributedString *attributedTitle =
            [[NSAttributedString alloc] initWithString:reminder.title
                                            attributes:@{ NSStrikethroughStyleAttributeName: @(YES) }];
            cell.titleLabel.attributedText = attributedTitle;
        }
        else {
            cell.titleLabel.text = reminder.title;
        }

        cell.dayLabelText = dayText;

        // Set time display based on model
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
                cell.AMPMLabel.hidden = YES;
            }
            else {
                cell.AMPMLabel.hidden = NO;
                cell.AMPMLabel.text   = [startDate mt_stringFromDateWithAMPMSymbol];
            }

            if (startDate && ![startDate mt_isStartOfAnHour]) {
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
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];
    EKCalendarItem *calendarItem = model.calendarItem;

    if (calendarItem.isReminder) {
        return CVRootTableViewReminderRowHeight;
    }

    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = self.cellModelArray[indexPath.row];
    EKCalendarItem *calendarItem = model.calendarItem;
    if (calendarItem.isReminder) {
        EKReminder *reminder = (EKReminder *)model.calendarItem;
        reminder.completed = !reminder.completed;
        [reminder saveWithError:nil];
        CVCompactWeekReminderCell *cell = (CVCompactWeekReminderCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.titleLabel toggleStrikeThroughWithCompletion:^{
            [self.delegate rootTableViewController:self cell:cell updatedItem:reminder];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

@end
