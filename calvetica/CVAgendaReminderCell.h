//
//  CVAgendaReminderCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"


@protocol CVAgendaReminderCellDelegate;

@interface CVAgendaReminderCell : CVCell {
}


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVAgendaReminderCellDelegate> delegate;
@property (nonatomic, strong) EKReminder *reminder;


#pragma mark - Methods

#pragma mark - IBActions


@end




@protocol CVAgendaReminderCellDelegate <NSObject>
@optional
- (void)cellWasTapped:(CVAgendaReminderCell *)cell;
- (void)cellWasLongPressed:(CVAgendaReminderCell *)cell;
@end