//
//  CVAgendaReminderCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaReminderCell.h"


@implementation CVAgendaReminderCell

- (void)setIsEmpty:(BOOL)empty 
{
    super.isEmpty = empty;
    self.coloredDotView.hidden = YES;
    self.titleLabel.text = @"No Reminders";
}

- (void)setReminder:(EKReminder *)newReminder 
{
	_reminder = newReminder;
	
	self.titleLabel.text = _reminder.title;
	self.titleLabel.striked = _reminder.isCompleted;
	self.coloredDotView.color = [UIColor colorWithCGColor:_reminder.calendar.CGColor];
	
    // set the shape
    if (_reminder.priority > 1 && _reminder.priority < 5) {
		self.coloredDotView.shape = CVColoredShapeTriangle;
    }
    else if (_reminder.priority == 5) {
        self.coloredDotView.shape = CVColoredShapeCircle;
    }
    else if (_reminder.priority > 5) {
        self.coloredDotView.shape = CVColoredShapeRectangle;
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





@end
