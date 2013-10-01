//
//  CVAgendaReminderCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "EKEvent+Utilities.h"

@protocol CVAgendaEventCellDelegate;

@interface CVAgendaEventCell : CVCell {
    BOOL isAllDay;
	BOOL continuedFromPreviousDay;
}


#pragma mark - Properties
@property (nonatomic, weak) id<CVAgendaEventCellDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, weak) IBOutlet CVLabel *timeLabel;


#pragma mark - Methods
- (void)setEvent:(EKEvent *)newEvent continued:(BOOL)continued allDay:(BOOL)isAllDay;

#pragma mark - IBActions


@end




@protocol CVAgendaEventCellDelegate <NSObject>
@optional
- (void)cellWasTapped:(CVAgendaEventCell *)cell;
- (void)cellWasLongPressed:(CVAgendaEventCell *)cell;
- (void)cellHourTimeWasTapped:(CVAgendaEventCell *)cell;
@end