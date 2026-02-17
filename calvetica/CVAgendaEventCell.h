//
//  CVAgendaEventCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "CVCalendarItemCellDelegate.h"
#import "CVStrikethroughLabel.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVAgendaEventCell : CVCell

@property (nonatomic, nullable, weak  )          id<CVCalendarItemCellDelegate> delegate;
@property (nonatomic, strong)          EKCalendarItem                 *calendarItem;
@property (nonatomic, nullable, weak  ) IBOutlet CVStrikethroughLabel           *calendarItemTitleLabel;

- (void)setCalendarItem:(EKCalendarItem *)newCalendarItem continued:(BOOL)continued allDay:(BOOL)isAllDay;

@end

NS_ASSUME_NONNULL_END
