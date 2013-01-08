//
//  CVEventCell.m
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventCell.h"


@implementation CVEventCell

- (void)setIsEmpty:(BOOL)empty 
{
    super.isEmpty = empty;
    if (empty) {
        self.titleLabel.hidden = YES;
        self.coloredDotView.hidden = YES;
        self.redSubtitleLabel.hidden = YES;
        self.hourAndMinuteLabel.hidden = YES;
        self.AMPMLabel.hidden = YES;
        self.allDayLabel.hidden = YES;
        self.cellAccessoryButton.hidden = YES;
        self.repeatTinyIcon.hidden = YES;
        self.notesTinyIcon.hidden = YES;
        self.locationTinyIcon.hidden = YES;
        self.attendeesTinyIcon.hidden = YES;
        self.dividerLine.hidden = YES;
        self.noEventLabel.hidden = NO;
    }
    else {
        self.noEventLabel.hidden = YES;
        self.dividerLine.hidden = NO;
    }
}

#pragma mark - Methods




- (void)setDate:(NSDate *)newDate 
{
    _date = newDate;
    
    // set cell time labels
    if (_date != nil) {
        _hourAndMinuteLabel.alpha = 1;
        _AMPMLabel.alpha = 1;
        if (![_date isStartOfAnHour]) {
            _hourAndMinuteLabel.alpha = 0.6f;
            _AMPMLabel.alpha = 0.6f;
        }
        _hourAndMinuteLabel.text = [_date stringWithHourAndMinute];
        _AMPMLabel.text = [_date stringWithAMPM];
    } else {
        _hourAndMinuteLabel.text = @"...";
        _AMPMLabel.text = @"";
    }
}

- (void)setEvent:(EKEvent *)newEvent 
{
    _event = newEvent;
    
    _repeatTinyIcon.hidden = YES;
    _notesTinyIcon.hidden = YES;
    _locationTinyIcon.hidden = YES;
    _attendeesTinyIcon.hidden = YES;
    
    // show or hide elements depending on if cell has an event
    if (newEvent) {
        
        // make event elements visible
        self.redSubtitleLabel.hidden = NO;
        self.cellAccessoryButton.hidden = NO;
        self.titleLabel.hidden = NO;
        self.coloredDotView.hidden = NO;
        
        // update event elements with even details
        self.titleLabel.text = [_event readTitle];
        self.coloredDotView.color = [_event.calendar customColor];
        self.cellAccessoryButton.defaultImage = [UIImage imageNamed:(_event.alarms.count > 0 ? @"icon_alarm_red" : @"icon_alarm_lg")];
        self.cellAccessoryButton.deleteImage = [UIImage imageNamed:@"icon_trash_slider"];
        
        
        // figure out subtitle text
        NSString *subtitleText = @"";
        
        // rearrange detail blocks to match user preferences
        NSArray *subtitlePriorities = [CVSettings eventDetailsSubtitleTextOrderingArray];
        
        // if there are no preferences set, just return
        if (subtitlePriorities) {
            for (NSDictionary *dict in subtitlePriorities) {
                if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"End Time"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden) {
                        subtitleText = [_event stringWithRelativeEndTime];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"End Time + Repeat"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && [_event.recurrenceRules lastObject]) {
                        subtitleText = [_event stringWithRelativeEndTimeAndRepeat];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Repeat"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && [_event.recurrenceRules lastObject]) {
                        subtitleText = [_event stringWithRepeat];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"End Time (if not default)"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    BOOL isNotDefaultDuration = [_event eventDuration] != [CVSettings defaultDuration];
                    if (!hidden && isNotDefaultDuration) {
                        subtitleText = [_event stringWithRelativeEndTime];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Notes"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && _event.notes) {
                        subtitleText = [_event stringWithNotes];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Location"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && _event.location) {
                        subtitleText = [_event stringWithLocation];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"People"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && _event.attendees) {
                        subtitleText = [_event stringWithPeople];
                        break;
                    }
                }
            }
        }
        
        self.redSubtitleLabel.text = subtitleText;
        
        
        
        
        // place icons
        CGFloat currentX = self.redSubtitleLabel.frame.origin.x + [self.redSubtitleLabel sizeOfTextInLabel].width + 8.0f;
        
        if (!self.redSubtitleLabel.text || [self.redSubtitleLabel.text isEqualToString:@""]) {
            currentX = self.redSubtitleLabel.frame.origin.x;
        }
        
        if ([_event.recurrenceRules lastObject]) {
            _repeatTinyIcon.hidden = NO;
            CGRect f = _repeatTinyIcon.frame;
            f.origin.x = currentX;
            currentX += 12;
            [_repeatTinyIcon setFrame:f];
        }
        
        if (_event.notes && ![_event.notes isEqualToString:@""]) {
            _notesTinyIcon.hidden = NO;
            CGRect f = _notesTinyIcon.frame;
            f.origin.x = currentX;
            currentX += 12;
            [_notesTinyIcon setFrame:f];
        }
        
        if (_event.location && ![_event.location isEqualToString:@""]) {
            _locationTinyIcon.hidden = NO;
            CGRect f = _locationTinyIcon.frame;
            f.origin.x = currentX;
            currentX += 12;
            [_locationTinyIcon setFrame:f];
        }
        
        if (_event.attendees && _event.attendees.count > 0) {
            _attendeesTinyIcon.hidden = NO;
            CGRect f = _attendeesTinyIcon.frame;
            f.origin.x = currentX;
            [_attendeesTinyIcon setFrame:f];
        }
        
    } else {
        
        // make event elements hidden
        self.redSubtitleLabel.hidden = YES;
        self.cellAccessoryButton.hidden = YES;
        self.titleLabel.hidden = YES;
        self.coloredDotView.hidden = YES;
        
    }
}

- (void)setIsAllDay:(BOOL)isAllDayBool 
{
    _isAllDay = isAllDayBool;
    
    if (_isAllDay) {
        _allDayLabel.hidden = NO;
        _AMPMLabel.hidden = YES;
        _hourAndMinuteLabel.hidden = YES;
    } else {    
        _allDayLabel.hidden = YES;
        _AMPMLabel.hidden = NO;
        _hourAndMinuteLabel.hidden = NO;
    }
}

- (void)drawDurationBarAnimated:(BOOL)animated 
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.20f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
    }
    
    _durationBarView.backgroundColor = self.durationBarColor;
	_secondaryDurationBarView.backgroundColor = self.secondaryDurationBarColor;
    
    CGRect r = _durationBarView.frame;
    r.size.height = self.frame.size.height * self.durationBarPercent;
    [_durationBarView setFrame:r];
	
	r = _secondaryDurationBarView.frame;
    r.size.height = self.frame.size.height * self.secondaryDurationBarPercent;
    [_secondaryDurationBarView setFrame:r];
    
    if (animated) [UIView commitAnimations];
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


- (IBAction)cellWasSwiped:(UISwipeGestureRecognizer *)gesture 
{
    if (self.event) {
        [self toggleAccessoryButton];        
    } else {
		if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
			[_delegate cell:self wasSwipedInDirection:CVEventCellSwipedDirectionLeft];
		}
		else {
			[_delegate cell:self wasSwipedInDirection:CVEventCellSwipedDirectionRight];
		}
	}
}

- (IBAction)accessoryButtonWasTapped:(id)sender 
{
    if (self.cellAccessoryButton.mode == CVCellAccessoryButtonModeDefault) {
        [_delegate cell:self alarmButtonWasTappedForCalendarItem:self.event];
    } else {
        [_delegate cellEventWasDeleted:self];
        [self toggleAccessoryButton];
    }
}

- (IBAction)hourTimeWasTapped:(id)sender 
{
    if (!self.isAllDay && self.date != nil) {
        [self.delegate cellHourTimeWasTapped:self];        
    }
}
@end
