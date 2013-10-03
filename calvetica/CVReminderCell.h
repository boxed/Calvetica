//
//  CVReminderCell.h
//  calvetica
//
//  Created by Adam Kirk on 5/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"
#import "CVEventStore.h"
#import "CVCell.h"


@protocol CVReminderCellDelegate;

@interface CVReminderCell : CVCell

@property (nonatomic, weak  )          id<CVReminderCellDelegate> delegate;
@property (nonatomic, strong)          EKReminder                 *reminder;
@property (nonatomic, weak  ) IBOutlet UILabel                    *noReminderLabel;

@end




@protocol CVReminderCellDelegate <NSObject>
@required
- (void)cellWasTapped:(CVReminderCell *)cell;
- (void)cellWasLongPressed:(CVReminderCell *)cell;
- (void)cellReminderWasCompleted:(CVReminderCell *)cell;
- (void)cellReminderWasUncompleted:(CVReminderCell *)cell;
- (void)cellReminderWasDeleted:(CVReminderCell *)cell;
- (void)cell:(CVCell *)cell alarmButtonWasTappedForCalendarItem:(EKCalendarItem *)calendarItem;
@end