//
//  CVAgendaEventCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaEventCell.h"


@interface CVAgendaEventCell ()
@property (nonatomic, weak  ) IBOutlet CVLabel *timeLabel;
@property (nonatomic, assign)          BOOL    isAllDay;
@property (nonatomic, assign)          BOOL    continuedFromPreviousDay;

@end


@implementation CVAgendaEventCell

- (void)setIsEmpty:(BOOL)empty
{
    super.isEmpty               = empty;
    self.coloredDotView.hidden  = YES;
    self.timeLabel.hidden       = YES;
    self.titleLabel.text        = @"No Events";
}



#pragma mark - Methods

- (void)setEvent:(EKEvent *)newEvent continued:(BOOL)continued allDay:(BOOL)allDay 
{
    self.event = newEvent;
	
	self.continuedFromPreviousDay = continued;
	self.isAllDay = allDay;
        
	// update event elements with even details
	self.titleLabel.text = [_event readTitle];
	self.coloredDotView.color = [_event.calendar customColor];
	_timeLabel.textColor = patentedQuiteDarkGray;
	
	
	// set cell time labels
    if (self.continuedFromPreviousDay) {
        _timeLabel.text = @"...";
    } 
	else if (self.isAllDay) {
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
    [super cellWasTapped:sender];
    [_delegate cellWasTapped:(CVEventCell *)self];
}

- (IBAction)cellWasLongPressed:(UILongPressGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateBegan) return;
}

- (IBAction)accessoryButtonWasTapped:(id)sender 
{
    if (!self.isAllDay) {
        [_delegate cellHourTimeWasTapped:(CVEventCell *)self];
    }
}



@end
