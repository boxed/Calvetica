//
//  CVAgendaReminderCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaEventCell.h"




@implementation CVAgendaEventCell




#pragma mark - Properties

- (void)setIsEmpty:(BOOL)empty 
{
    super.isEmpty = empty;
    self.coloredDotView.hidden = YES;
    self.timeLabel.hidden = YES;
    self.titleLabel.text = @"No Events";
}

#pragma mark - Constructor




#pragma mark - Memory Management





#pragma mark - View lifecycle

- (void)awakeFromNib 
{
	[super awakeFromNib];
}




#pragma mark - Methods

- (void)setEvent:(EKEvent *)newEvent continued:(BOOL)continued allDay:(BOOL)allDay 
{
    self.event = newEvent;
	
	continuedFromPreviousDay = continued;
	isAllDay = allDay;
        
	// update event elements with even details
	self.titleLabel.text = [_event readTitle];
	self.coloredDotView.color = [_event.calendar customColor];
	_timeLabel.textColor = patentedGray;
	
	
	// set cell time labels
    if (continuedFromPreviousDay) {
        _timeLabel.text = @"...";
    } 
	else if (isAllDay) {
		_timeLabel.text = @"ALL DAY";
		_timeLabel.textColor = patentedRed;
	}
	else {
		_timeLabel.text = [_event.startingDate stringWithHourMinuteAndLowercaseAMPM];
    }
	
}

#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender 
{
    [_delegate cellWasTapped:self];
}

- (IBAction)cellWasLongPressed:(UILongPressGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    [_delegate cellWasLongPressed:self];
}

- (IBAction)accessoryButtonWasTapped:(id)sender 
{
    if (!isAllDay) {
        [_delegate cellHourTimeWasTapped:self];
    }
}



@end
