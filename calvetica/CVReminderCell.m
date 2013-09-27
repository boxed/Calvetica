//
//  CVReminderCell.m
//  calvetica
//
//  Created by Adam Kirk on 5/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderCell.h"
#import "EKReminder+Calvetica.h"



@interface CVReminderCell ()
@property (weak, nonatomic) IBOutlet CVCellAccessoryButton *checkButton;
@end



@implementation CVReminderCell

- (void)setIsEmpty:(BOOL)empty 
{
    super.isEmpty = empty;
    if (empty) {
        self.titleLabel.hidden = YES;
        self.titleLabel.striked = NO;
        self.coloredDotView.hidden = YES;
        self.redSubtitleLabel.hidden = YES;
        self.cellAccessoryButton.hidden = YES;
		self.checkButton.hidden = YES;

        self.noReminderLabel.hidden = NO;
    }
    else {
        self.titleLabel.hidden = NO;
        self.coloredDotView.hidden = NO;
        self.redSubtitleLabel.hidden = NO;
        self.cellAccessoryButton.hidden = NO;
		self.checkButton.hidden = NO;

        self.noReminderLabel.hidden = YES;
    }
}

- (void)setReminder:(EKReminder *)newReminder 
{
    _reminder = newReminder;
    
    self.titleLabel.text = _reminder.title;
	self.redSubtitleLabel.text = [_reminder subTitle];
    if (_reminder.priority == CVColoredShapeRectangle) {
        self.coloredDotView.shape = CVColoredShapeRectangle;
    }
    else if (_reminder.priority == CVColoredShapeCircle) {
        self.coloredDotView.shape = CVColoredShapeCircle;
    }
    else if (_reminder.priority == CVColoredShapeTriangle) {
        self.coloredDotView.shape = CVColoredShapeTriangle;
    }
    
    self.coloredDotView.color = [UIColor colorWithCGColor:_reminder.calendar.CGColor];
    _checkButton.defaultImage = [UIImage imageNamed:(_reminder.completed ? @"icon_bigcheck_red" : @"icon_bigcheck")];
	self.cellAccessoryButton.defaultImage = [UIImage imageNamed:(_reminder.alarms.count > 0 ? @"icon_alarm_red" : @"icon_alarm_lg")];
	self.cellAccessoryButton.deleteImage = [UIImage imageNamed:@"icon_trash_slider"];
    self.titleLabel.striked = _reminder.isCompleted;
}

- (IBAction)cellWasTapped:(id)sender 
{
    [_delegate cellWasTapped:self];
}

- (IBAction)cellWasLongPressed:(UILongPressGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    [_delegate cellWasLongPressed:self];
}

- (IBAction)cellWasSwiped:(id)sender 
{
    [self toggleAccessoryButton];       
}

- (IBAction)accessoryButtonWasTapped:(id)sender
{
    if (self.cellAccessoryButton.mode == CVCellAccessoryButtonModeDefault) {
        [_delegate cell:self alarmButtonWasTappedForCalendarItem:self.reminder];
    } else {
        [_delegate cellReminderWasDeleted:self];
        [self toggleAccessoryButton];
    }
}

- (IBAction)checkButtonWasTapped:(id)sender
{
	if (_reminder.isCompleted) {
		_reminder.completed = NO;
		self.titleLabel.striked = NO;
		_checkButton.defaultImage = [UIImage imageNamed:@"icon_bigcheck"];
	} else {
		_reminder.completionDate = [NSDate date];
		self.titleLabel.striked = YES;
		_checkButton.defaultImage = [UIImage imageNamed:@"icon_bigcheck_red"];
	}
	dispatch_async([CVOperationQueue backgroundQueue], ^{
		[_reminder save];
	});
	[_delegate cellReminderWasUncompleted:self]; 
}


@end
