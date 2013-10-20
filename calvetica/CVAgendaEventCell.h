//
//  CVAgendaEventCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "CVCalendarItemCellDelegate.h"

@interface CVAgendaEventCell : CVCell

@property (nonatomic, weak  ) id<CVCalendarItemCellDelegate> delegate;
@property (nonatomic, strong) EKCalendarItem                 *calendarItem;

- (void)setCalendarItem:(EKCalendarItem *)newCalendarItem continued:(BOOL)continued allDay:(BOOL)isAllDay;

@end
