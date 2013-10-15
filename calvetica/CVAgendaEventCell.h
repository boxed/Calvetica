//
//  CVAgendaEventCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "EKEvent+Utilities.h"
#import "CVEventCell.h"

@interface CVAgendaEventCell : CVCell {
}

@property (nonatomic, weak) id<CVEventCellDelegate> delegate;
@property (nonatomic, strong) EKEvent *event;

- (void)setEvent:(EKEvent *)newEvent continued:(BOOL)continued allDay:(BOOL)isAllDay;


@end
