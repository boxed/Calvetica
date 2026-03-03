//
//  CVEventCell.m
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventCell.h"
#import "UILabel+Utilities.h"


@interface CVEventCell ()
@property (nonatomic, weak) IBOutlet UILabel     *noEventLabel;
@property (nonatomic, weak) IBOutlet UIView      *durationBarView;
@property (nonatomic, weak) IBOutlet UIView      *secondaryDurationBarView;
@property (nonatomic, weak) IBOutlet UILabel     *hourAndMinuteLabel;
@property (nonatomic, weak) IBOutlet UILabel     *AMPMLabel;
@property (nonatomic, weak) IBOutlet UILabel     *allDayLabel;
@property (nonatomic, weak) IBOutlet UIControl   *timeTextHitArea;
@property (nonatomic, weak) IBOutlet UIImageView *repeatTinyIcon;
@property (nonatomic, weak) IBOutlet UIImageView *notesTinyIcon;
@property (nonatomic, weak) IBOutlet UIImageView *locationTinyIcon;
@property (nonatomic, weak) IBOutlet UIImageView *attendeesTinyIcon;
@property (nonatomic, assign) float appliedFontScale;
@property (nonatomic, strong) NSDictionary *baseFonts;
@end


@implementation CVEventCell

- (void)applyFontScaleIfNeeded
{
    if (!IS_MAC) return;
    float scale = PREFS.macFontScale;
    if (self.appliedFontScale == scale) return;
    self.appliedFontScale = scale;
    if (!self.baseFonts) {
        self.baseFonts = @{
            @"title": self.titleLabel.font ?: [UIFont systemFontOfSize:14],
            @"subtitle": self.redSubtitleLabel.font ?: [UIFont systemFontOfSize:10],
            @"hour": _hourAndMinuteLabel.font ?: [UIFont systemFontOfSize:14],
            @"ampm": _AMPMLabel.font ?: [UIFont systemFontOfSize:10],
            @"allDay": _allDayLabel.font ?: [UIFont systemFontOfSize:10],
            @"noEvent": _noEventLabel.font ?: [UIFont systemFontOfSize:14],
        };
    }
    for (NSString *key in self.baseFonts) {
        UIFont *base = self.baseFonts[key];
        UIFont *scaled = [base fontWithSize:base.pointSize * scale];
        if ([key isEqualToString:@"title"]) self.titleLabel.font = scaled;
        else if ([key isEqualToString:@"subtitle"]) self.redSubtitleLabel.font = scaled;
        else if ([key isEqualToString:@"hour"]) _hourAndMinuteLabel.font = scaled;
        else if ([key isEqualToString:@"ampm"]) _AMPMLabel.font = scaled;
        else if ([key isEqualToString:@"allDay"]) _allDayLabel.font = scaled;
        else if ([key isEqualToString:@"noEvent"]) _noEventLabel.font = scaled;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self applyFontScaleIfNeeded];

    if (IS_MAC) {
        CGFloat scale = PREFS.macFontScale;
        CGFloat h = self.contentView.frame.size.height;
        CGFloat w = self.contentView.frame.size.width;

        // Nib base positions: hour x=5 w=36, ampm x=43 w=27, allDay x=9 w=50, dot x=76 w=10, title x=91, subtitle x=91
        CGFloat hourX = 5;
        CGFloat hourW = 36 * scale;
        CGFloat ampmX = hourX + hourW + 2;
        CGFloat ampmW = 27 * scale;
        CGFloat allDayW = (ampmX + ampmW) - 9;
        CGFloat dotX = ampmX + ampmW + 1;
        CGFloat dotSize = 10 * scale;
        CGFloat titleX = dotX + dotSize + 5 * scale;

        _hourAndMinuteLabel.frame = CGRectMake(hourX, 0, hourW, h);
        _AMPMLabel.frame = CGRectMake(ampmX, 0, ampmW, h);
        _allDayLabel.frame = CGRectMake(9, 1, allDayW, h - 1);
        self.coloredDotView.frame = CGRectMake(dotX, (h - dotSize) / 2, dotSize, dotSize);

        CGFloat accessoryW = self.cellAccessoryButton.frame.size.width;
        CGFloat titleW = w - titleX - accessoryW;
        self.titleLabel.frame = CGRectMake(titleX, 5 * scale, titleW, 18 * scale);
        self.redSubtitleLabel.frame = CGRectMake(titleX, 5 * scale + 18 * scale, titleW, 16 * scale);

        _timeTextHitArea.frame = CGRectMake(0, 0, dotX, h);
    }
}

- (void)setIsEmpty:(BOOL)empty
{
    super.isEmpty = empty;
    if (empty) {
        self.titleLabel.hidden          = YES;
        self.coloredDotView.hidden      = YES;
        self.redSubtitleLabel.hidden    = YES;
        self.hourAndMinuteLabel.hidden  = YES;
        self.AMPMLabel.hidden           = YES;
        self.allDayLabel.hidden         = YES;
        self.cellAccessoryButton.hidden = YES;
        self.repeatTinyIcon.hidden      = YES;
        self.notesTinyIcon.hidden       = YES;
        self.locationTinyIcon.hidden    = YES;
        self.attendeesTinyIcon.hidden   = YES;
        self.noEventLabel.hidden        = NO;
    }
    else {
        self.noEventLabel.hidden = YES;
    }
}

#pragma mark - Methods




- (void)setDate:(NSDate *)newDate 
{
    _date = newDate;
    
    // set cell time labels
    if (_date != nil) {
        if (![_date mt_isStartOfAnHour]) {
            _hourAndMinuteLabel.alpha   = 0.8f;
            _AMPMLabel.alpha            = 0.8f;
        }
        else {
            _hourAndMinuteLabel.alpha   = 1;
            _AMPMLabel.alpha            = 1;
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
        self.titleLabel.text = [_event mys_title];
        self.coloredDotView.color = [_event.calendar customColor];
        self.cellAccessoryButton.defaultImage = [UIImage imageNamed:(_event.alarms.count > 0 ? @"icon_alarm_selected" : @"icon_alarm")];

        if (!newEvent.calendar.allowsContentModifications) {
            self.cellAccessoryButton.alpha = 0.3;
        }
        else {
            self.cellAccessoryButton.alpha = 1;
        }

        
        // figure out subtitle text
        NSString *subtitleText = @"";
        
        // rearrange detail blocks to match user preferences
        NSArray *subtitlePriorities = PREFS.eventDetailsSubtitleTextPriority;
        
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
                    BOOL isNotDefaultDuration = [_event eventDuration] != PREFS.defaultDuration;
                    if (!hidden && isNotDefaultDuration) {
                        subtitleText = [_event stringWithRelativeEndTime];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Notes"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && [_event.notes length] > 0) {
                        subtitleText = [_event stringWithNotes];
                        break;
                    }
                }
                
                
                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Location"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && [_event.location length] > 0) {
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

                else if ([[dict objectForKey:@"TitleKey"] isEqualToString:@"Video Link"]) {
                    BOOL hidden = [[dict objectForKey:@"HiddenKey"] boolValue];
                    if (!hidden && [_event videoConferenceURL] != nil) {
                        subtitleText = [_event stringWithVideoLink];
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

- (void)centerTimeLabelsVertically
{
    CGRect hourFrame = _hourAndMinuteLabel.frame;
    hourFrame.origin.y = 0;
    hourFrame.size.height = self.contentView.bounds.size.height;
    _hourAndMinuteLabel.frame = hourFrame;

    CGRect ampmFrame = _AMPMLabel.frame;
    ampmFrame.origin.y = 0;
    ampmFrame.size.height = self.contentView.bounds.size.height;
    _AMPMLabel.frame = ampmFrame;
}




#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender 
{
    [super cellWasTapped:sender];
    [self.delegate calendarItemCell:self wasTappedForItem:self.event];
}

- (IBAction)cellWasLongPressed:(UILongPressGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    [self.delegate calendarItemCell:self wasLongPressedForItem:self.event];
}


- (IBAction)cellWasSwiped:(UISwipeGestureRecognizer *)gesture 
{
    if (self.event) {
        [self toggleAccessoryButton];        
    } else {
		if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self.delegate calendarItemCell:self forItem:self.event wasSwipedInDirection:CVCalendarItemCellSwipedDirectionLeft];
		}
		else {
            [self.delegate calendarItemCell:self forItem:self.event wasSwipedInDirection:CVCalendarItemCellSwipedDirectionRight];
		}
	}
}

- (IBAction)accessoryButtonWasTapped:(id)sender 
{
    if (self.cellAccessoryButton.mode == CVCellAccessoryButtonModeDefault) {
        [self.delegate calendarItemCell:self tappedAlarmView:self.cellAccessoryButton forItem:self.event];
    } else {
        [self.delegate calendarItemCell:self tappedDeleteForItem:self.event];
        [self toggleAccessoryButton];
    }
}

- (IBAction)hourTimeWasTapped:(id)sender 
{
    if (!self.isAllDay && self.date != nil) {
        [self.delegate calendarItemCell:self tappedTime:self.date view:self.timeTextHitArea];
    }
}

@end
