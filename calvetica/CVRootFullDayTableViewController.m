//
//  CVEventsFullDayTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootFullDayTableViewController.h"
#import "CVCalendarItemCellModel.h"
#import "CVRootTableViewController_Protected.h"
#import "CVReminderCell.h"


@implementation CVRootFullDayTableViewController

#pragma mark - Public

- (void)reloadTableViewWithCompletion:(void (^)(void))completion
{
    [super reloadTableViewWithCompletion:completion];
    
    // date can't be null
    if (!self.selectedDate) return;

    // copy the date so that its copied into the operation and not tied to the ivar
    NSDate *dateCopy = [self.selectedDate copy];

    void (^processCalendarItems)(NSMutableArray *, NSMutableArray *) = ^(NSMutableArray *calendarItems, NSMutableArray *hours) {
        // sort the events backwards
        [calendarItems sortUsingComparator:^NSComparisonResult(EKCalendarItem *e1, EKCalendarItem *e2) {
            return [e1.mys_date compare:e2.mys_date] == NSOrderedAscending ? NSOrderedDescending : NSOrderedAscending;
        }];

        // zipper them together
        NSMutableArray *tempArray = [NSMutableArray array];

        for (;;) {

            // grab next objects
            EKCalendarItem *calendarItem    = [calendarItems lastObject];
            NSDate *hour                    = [hours lastObject];

            // create data holder
            CVCalendarItemCellModel *cellModel = [[CVCalendarItemCellModel alloc] init];


            // if the event is all day, doesn't need to be compared with an hour
            if (calendarItem && calendarItem.mys_isAllDay) {
                cellModel.calendarItem  = calendarItem;
                cellModel.date          = calendarItem.mys_date;
                cellModel.isAllDay      = YES;
                [calendarItems removeLastObject];

                // because it's an all day event, we want it at the beginning of the array
                [tempArray insertObject:cellModel atIndex:0];
                continue;


                // if event started before date
            } else if (calendarItem && ![calendarItem.mys_date mt_isWithinSameDay:dateCopy]) {

                // if it spans the whole day, make it an all day event
                if (calendarItem.isEvent && [(EKEvent *)calendarItem spansEntireDayOfDate:dateCopy]) {
                    cellModel.calendarItem  = calendarItem;
                    cellModel.date          = calendarItem.mys_date;
                    cellModel.isAllDay      = YES;

                    // because it's an all day event, we want it at the beginning of the array
                    [tempArray insertObject:cellModel atIndex:0];
                }

                // if it ends today but started on a previous day show it at the beginning
                // with a start time of "..."
                else {
                    cellModel.calendarItem  = calendarItem;
                    cellModel.date          = nil;
                    cellModel.isAllDay      = NO;

                    // because it started before today, we want it at the beginning of the array
                    [tempArray insertObject:cellModel atIndex:0];
                }

                [calendarItems removeLastObject];
                continue;


                // add the one that occurs first (or exists at all) to the table next.
            } else if (hour && calendarItem) {

                NSTimeInterval difference = [hour timeIntervalSinceDate:calendarItem.mys_date];

                // they both occur at the same time
                if (difference == 0) {
                    cellModel.calendarItem  = calendarItem;
                    cellModel.date          = calendarItem.mys_date;
                    cellModel.isAllDay      = NO;
                    [calendarItems removeLastObject];
                    [hours removeLastObject];

                    // the event happens before the hour
                } else if (difference > 0) {
                    cellModel.calendarItem  = calendarItem;
                    cellModel.date          = calendarItem.mys_date;
                    cellModel.isAllDay      = NO;
                    [calendarItems removeLastObject];

                    // the hour happens before the event
                } else {
                    cellModel.date      = hour;
                    cellModel.isAllDay  = NO;
                    [hours removeLastObject];
                }


                // if there are no more events
            } else if (hour) {
                cellModel.date      = hour;
                cellModel.isAllDay  = NO;
                [hours removeLastObject];


                // if there are no more hours
            } else if (calendarItem) {
                cellModel.calendarItem  = calendarItem;
                cellModel.date          = calendarItem.mys_date;
                cellModel.isAllDay      = NO;
                [calendarItems removeLastObject];


                // nothing left, we're done
            } else {
                break;
            }

            [tempArray addObject:cellModel];
        }
        
        // sort the data holders so that all day events are first, then events that started
        // previously, then events that start today
        [tempArray sortUsingComparator:^NSComparisonResult(CVCalendarItemCellModel *model1,
                                                           CVCalendarItemCellModel *model2)
         {
             if (!model1.calendarItem || model2.calendarItem) {
                 return [model1.date compare:model2.date];
             }
             return [model1.calendarItem compareWithCalendarItem:model2.calendarItem];
         }];

        // update the table with our new event or cell
        [MTq main:^{
            // Only update if we're still the active controller for this tableView
            if (self.tableView.dataSource != self) return;

            // replace the old data holder array with the one we just generated
            self.cellModelArray = [tempArray mutableCopy];

            [self calculateDurationBars];

            [self.tableView reloadData];

            if (completion) completion();
        }];
    };


    [MTq def:^{

        NSDate *startDate   = dateCopy;
        NSDate *endDate     = [dateCopy mt_endOfCurrentDay];
        BOOL isToday        = [dateCopy mt_isWithinSameDay:[NSDate date]];

        NSMutableArray *hours = [NSMutableArray array];

        // create a date for every hour if agenda view is off
        for (int i = 23; i >= 0; i--) {
            [hours addObject:[NSDate mt_dateFromYear:[startDate mt_year]
                                               month:[startDate mt_monthOfYear]
                                                 day:[startDate mt_dayOfMonth]
                                                hour:i
                                              minute:0]];
        }



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
                 reminders = [reminders filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKReminder *reminder, NSDictionary *bindings) {
                     return !reminder.isFloating || isToday;
                 }]];
                 [calendarItems addObjectsFromArray:reminders];
                 processCalendarItems(calendarItems, hours);
             }];
        }
        else {
            processCalendarItems(calendarItems, hours);
        }
    }];
}


- (void)scrollToCurrentHourAnimated:(BOOL)animated
{
    // scroll to current hour
    NSInteger currentHour = [[NSDate date] mt_hourOfDay];
    for (NSInteger i = 0; i < self.cellModelArray.count; i++) {
        CVCalendarItemCellModel *holder = [self.cellModelArray objectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if ([holder.date mt_hourOfDay] == currentHour &&
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

- (void)removeCalendarItem:(EKCalendarItem *)calendarItem
{
    for (CVCalendarItemCellModel *model in [self.cellModelArray copy]) {
        if ([model.calendarItem isEqualToCalendarItem:calendarItem]) {
            if (![model.date mt_isStartOfAnHour] || calendarItem.mys_isAllDay) {
                [self.cellModelArray removeObject:model];
            }
            else {
                model.calendarItem = nil;
            }
            break;
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
    CVCalendarItemCellModel *model = [self.cellModelArray objectAtIndex:indexPath.row];

    if (!model.calendarItem.isReminder) {
        CVEventCell *cell   = [CVEventCell cellForTableView:tableView];
        cell.isEmpty                        = NO;
        cell.event                          = (EKEvent *)model.calendarItem;
        cell.date                           = model.date;
        cell.isAllDay                       = model.isAllDay;
        cell.durationBarPercent             = model.durationBarPercent;
        cell.secondaryDurationBarPercent    = model.secondaryDurationBarPercent;
        cell.durationBarColor               = model.durationBarColor;
        cell.secondaryDurationBarColor      = model.secondaryDurationBarColor;
        cell.delegate                       = self;
        [cell resetAccessoryButton];

        return cell;
    }
    else {
        EKReminder *reminder = (EKReminder *)model.calendarItem;
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


        if (reminder.isAllDay) {
            cell.timeLabel.hidden   = YES;
            cell.AMPMLabel.hidden   = YES;
            cell.allDayLabel.hidden = NO;
        }
        else {
            cell.timeLabel.hidden   = NO;
            cell.AMPMLabel.hidden   = NO;
            cell.allDayLabel.hidden = YES;

            NSDate *startDate = [reminder dateRelativeToDate:self.selectedDate];

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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = [self.cellModelArray objectAtIndex:indexPath.row];
    if (model.calendarItem.isReminder) {
        return CVRootTableViewReminderRowHeight;
    }
    return CVRootTableViewEventRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVCalendarItemCellModel *model = [self.cellModelArray objectAtIndex:indexPath.row];

    if (!model.calendarItem.isReminder) {
        [(CVEventCell *)cell drawDurationBarAnimated:NO];
    }

    BOOL isBeforeWorkingHours   = [model.date mt_hourOfDay] < PREFS.dayStartHour;
    BOOL isAfterWorkingHours    = [model.date mt_hourOfDay] >= PREFS.dayEndHour;
    BOOL isOutsideWorkingHours  = isBeforeWorkingHours || isAfterWorkingHours;
    BOOL isAllDay               = model.isAllDay;
    BOOL isAnHour               = model.calendarItem == nil;
    BOOL isAnEvent              = model.calendarItem.isEvent;
    BOOL isEligibleCell         = isAnHour || isAnEvent;

    // if its just an hour
    if (isEligibleCell && (isOutsideWorkingHours || isAllDay)) {
        cell.backgroundColor = calGridLineColor();
    }
    else if (isEligibleCell) {
        cell.backgroundColor = calBackgroundColor();
    }
}




#pragma mark - Private

- (void)calculateDurationBars
{
	UIColor *primaryBarColor = patentedClear;
	UIColor *secondaryBarColor = patentedClear;

	NSInteger primarySecondsLeft = 0;
	NSInteger secondarySecondsLeft = 0;

	for (CVCalendarItemCellModel *c in self.cellModelArray) {

        if (c.calendarItem.isReminder) {
            c.durationBarPercent            = 1;
            c.durationBarColor              = primaryBarColor;
            c.secondaryDurationBarPercent   = 1;
            c.secondaryDurationBarColor     = secondaryBarColor;
            continue;
        }

		// all day events just clobber the usefulness of the duration bar, so we ignore them.
		if (c.isAllDay) continue;


		// figure out if this event should show a duration bar
		BOOL shouldShowDurationBar = (PREFS.showDurationOnReadOnlyEvents ||
                                      c.calendarItem.calendar.allowsContentModifications ||
                                      c.calendarItem.calendar.type == EKCalendarTypeExchange);

		if (c.calendarItem != nil && shouldShowDurationBar) {

			if (primarySecondsLeft == 0) {
                if (c.calendarItem.isEvent) {
                    EKEvent *event = (EKEvent *)c.calendarItem;
                    primarySecondsLeft = [event durationForDate:self.selectedDate];
                }
				primaryBarColor = [c.calendarItem.calendar customColor];
			}

			else if (secondarySecondsLeft == 0) {
                if (c.calendarItem.isEvent) {
                    EKEvent *event = (EKEvent *)c.calendarItem;
                    secondarySecondsLeft = [event durationForDate:self.selectedDate];
                }
				secondaryBarColor = [c.calendarItem.calendar customColor];
			}
		}

        c.durationBarColor = primaryBarColor;
		c.secondaryDurationBarColor = secondaryBarColor;



		NSInteger cellIndex = [self.cellModelArray indexOfObject:c];
		NSTimeInterval cellDuration = 60*60;

		if (cellIndex < [self.cellModelArray count] - 1) {
			CVCalendarItemCellModel *cplus1 = self.cellModelArray[cellIndex + 1];
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


@end
