//
//  CVEventCell.m
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventCell.h"
#import "UILabel+Utilities.h"

static NSString * const kCellIdentifier = @"CVEventCell";

@interface CVEventCell ()
@property (nonatomic, strong) UILabel     *noEventLabel;
@property (nonatomic, strong) UIView      *durationBarView;
@property (nonatomic, strong) UIView      *secondaryDurationBarView;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIControl   *timeTextHitArea;
@property (nonatomic, strong) UIImageView *repeatTinyIcon;
@property (nonatomic, strong) UIImageView *notesTinyIcon;
@property (nonatomic, strong) UIImageView *locationTinyIcon;
@property (nonatomic, strong) UIImageView *attendeesTinyIcon;
@end


@implementation CVEventCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    CVEventCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CVEventCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:kCellIdentifier];
    }
    cell.contentView.backgroundColor = calBackgroundColor();
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);

    // Layout constants
    CGFloat cellH          = 42;
    CGFloat barW           = 4;
    CGFloat timeX          = 8;
    CGFloat timeW          = 51;
    CGFloat timeColumnEnd  = timeX + timeW;
    CGFloat contentY       = 5;
    CGFloat contentH       = 18;
    CGFloat dotMargin      = 8;
    CGFloat dotSize        = 10;
    CGFloat dotX           = timeColumnEnd + dotMargin;
    CGFloat titleMargin    = 8;
    CGFloat titleX         = dotX + dotSize + titleMargin;
    CGFloat accessoryW     = 49;

    // Duration bars (left edge)
    self.durationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barW, cellH)];
    self.durationBarView.opaque = NO;
    [self.contentView addSubview:self.durationBarView];

    self.secondaryDurationBarView = [[UIView alloc] initWithFrame:CGRectMake(barW, 0, barW, cellH)];
    self.secondaryDurationBarView.opaque = NO;
    [self.contentView addSubview:self.secondaryDurationBarView];

    // No event label (hidden by default)
    self.noEventLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, cellH)];
    self.noEventLabel.font = [UIFont systemFontOfSize:17];
    self.noEventLabel.textColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.0];
    self.noEventLabel.textAlignment = NSTextAlignmentCenter;
    self.noEventLabel.text = @"No Events";
    self.noEventLabel.hidden = YES;
    self.noEventLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.noEventLabel];

    // Time label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, contentY, timeW, contentH)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.lineBreakMode = NSLineBreakByClipping;
    [self.contentView addSubview:self.timeLabel];

    // Colored dot
    self.coloredDotView = [[CVColoredDotView alloc] initWithFrame:CGRectMake(dotX, contentY + (contentH - dotSize) / 2, dotSize, dotSize)];
    self.coloredDotView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.coloredDotView];

    // Title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, contentY, 320 - titleX - accessoryW, contentH)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.titleLabel];

    // Subtitle label
    self.redSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 22, 320 - titleX - accessoryW, 16)];
    self.redSubtitleLabel.font = [UIFont systemFontOfSize:11];
    self.redSubtitleLabel.textColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.0];
    self.redSubtitleLabel.lineBreakMode = NSLineBreakByClipping;
    self.redSubtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.redSubtitleLabel];

    // Tiny icons (repositioned in layoutTinyIcons)
    self.repeatTinyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 10, 10)];
    self.repeatTinyIcon.image = [UIImage imageNamed:@"tinyicon_repeat"];
    self.repeatTinyIcon.hidden = YES;
    [self.contentView addSubview:self.repeatTinyIcon];

    self.notesTinyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 10, 10)];
    self.notesTinyIcon.image = [UIImage imageNamed:@"tinyicon_note"];
    self.notesTinyIcon.hidden = YES;
    [self.contentView addSubview:self.notesTinyIcon];

    self.locationTinyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 10, 10)];
    self.locationTinyIcon.image = [UIImage imageNamed:@"tinyicon_location"];
    self.locationTinyIcon.hidden = YES;
    [self.contentView addSubview:self.locationTinyIcon];

    self.attendeesTinyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 10, 10)];
    self.attendeesTinyIcon.image = [UIImage imageNamed:@"tinyicon_person"];
    self.attendeesTinyIcon.hidden = YES;
    [self.contentView addSubview:self.attendeesTinyIcon];

    // Accessory button (alarm/delete)
    self.cellAccessoryButton = [[CVCellAccessoryButton alloc] initWithFrame:CGRectMake(320 - accessoryW, 0, accessoryW, cellH)];
    self.cellAccessoryButton.backgroundColor = [UIColor clearColor];
    self.cellAccessoryButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.cellAccessoryButton addTarget:self
                                 action:@selector(accessoryButtonWasTapped:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cellAccessoryButton];

    // Gesture hit area (between time column and accessory button)
    self.gestureHitArea = [[UIView alloc] initWithFrame:CGRectMake(timeColumnEnd - 5, -2, 320 - timeColumnEnd + 5, cellH - 1)];
    self.gestureHitArea.backgroundColor = [UIColor clearColor];
    self.gestureHitArea.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.gestureHitArea];

    // Hour time hit area
    self.timeTextHitArea = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, timeColumnEnd, cellH - 1)];
    self.timeTextHitArea.backgroundColor = [UIColor clearColor];
    self.timeTextHitArea.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.timeTextHitArea addTarget:self
                             action:@selector(hourTimeWasTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.timeTextHitArea];

    // Set up gestures (tap, long press, swipe)
    [self setupGestures];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.redSubtitleLabel.text = nil;
    self.timeLabel.text = nil;
    self.timeLabel.hidden = NO;
    self.timeLabel.textColor = [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1.0];
    self.noEventLabel.hidden = YES;
    self.repeatTinyIcon.hidden = YES;
    self.notesTinyIcon.hidden = YES;
    self.locationTinyIcon.hidden = YES;
    self.attendeesTinyIcon.hidden = YES;
    self.coloredDotView.color = nil;
    self.cellAccessoryButton.defaultImage = nil;
    self.cellAccessoryButton.alpha = 1;
    self.durationBarView.frame = CGRectMake(0, 0, 4, 0);
    self.secondaryDurationBarView.frame = CGRectMake(4, 0, 4, 0);
    _event = nil;
    _date = nil;
    _isAllDay = NO;
}

- (void)applyFontScaleIfNeeded
{
    if (!IS_MAC) return;
    float scale = PREFS.macFontScale;
    self.titleLabel.font        = [UIFont systemFontOfSize:14 * scale];
    self.redSubtitleLabel.font  = [UIFont systemFontOfSize:11 * scale];
    _timeLabel.font             = [UIFont systemFontOfSize:12 * scale];
    _noEventLabel.font          = [UIFont systemFontOfSize:17 * scale];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self applyFontScaleIfNeeded];

    if (IS_MAC) {
        CGFloat scale = PREFS.macFontScale;
        CGFloat h = self.contentView.frame.size.height;
        CGFloat w = self.contentView.frame.size.width;

        CGFloat timeX = 5;
        CGFloat timeW = 58 * scale;
        CGFloat dotX = timeX + timeW + 1;
        CGFloat dotSize = 10 * scale;
        CGFloat titleX = dotX + dotSize + 5 * scale;

        _timeLabel.frame = CGRectMake(timeX, 0, timeW, h);
        CGFloat accessoryW = self.cellAccessoryButton.frame.size.width;
        CGFloat titleW = w - titleX - accessoryW;
        CGFloat titleY = 5 * scale;
        CGFloat titleH = 18 * scale;
        self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
        self.coloredDotView.frame = CGRectMake(dotX, titleY + (titleH - dotSize) / 2, dotSize, dotSize);
        self.redSubtitleLabel.frame = CGRectMake(titleX, 5 * scale + 18 * scale, titleW, 16 * scale);

        _timeTextHitArea.frame = CGRectMake(0, 0, dotX, h);
    }

    [self layoutTinyIcons];
}

- (void)layoutTinyIcons
{
    CGFloat subtitleY = self.redSubtitleLabel.frame.origin.y;
    CGFloat subtitleH = self.redSubtitleLabel.frame.size.height;
    CGFloat iconY = subtitleY + (subtitleH - 10) / 2;

    CGFloat currentX = self.redSubtitleLabel.frame.origin.x + [self.redSubtitleLabel sizeOfTextInLabel].width + 8.0f;

    if (!self.redSubtitleLabel.text || [self.redSubtitleLabel.text isEqualToString:@""]) {
        currentX = self.redSubtitleLabel.frame.origin.x;
    }

    NSArray *icons = @[_repeatTinyIcon, _notesTinyIcon, _locationTinyIcon, _attendeesTinyIcon];
    for (UIImageView *icon in icons) {
        if (!icon.hidden) {
            icon.frame = CGRectMake(currentX, iconY, 10, 10);
            currentX += 12;
        }
    }
}

- (void)setIsEmpty:(BOOL)empty
{
    super.isEmpty = empty;
    if (empty) {
        self.titleLabel.hidden          = YES;
        self.coloredDotView.hidden      = YES;
        self.redSubtitleLabel.hidden    = YES;
        self.timeLabel.hidden           = YES;
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

    // set cell time label
    if (_date != nil) {
        _timeLabel.alpha = [_date mt_isStartOfAnHour] ? 1.0f : 0.8f;
        _timeLabel.text = [_date stringWithHourMinuteAndLowercaseAMPM];
    } else {
        _timeLabel.text = @"...";
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

        // mark which icons should be visible
        _repeatTinyIcon.hidden = ![_event.recurrenceRules lastObject];
        _notesTinyIcon.hidden = !(_event.notes && ![_event.notes isEqualToString:@""]);
        _locationTinyIcon.hidden = !(_event.location && ![_event.location isEqualToString:@""]);
        _attendeesTinyIcon.hidden = !(_event.attendees && _event.attendees.count > 0);

        [self layoutTinyIcons];

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
        _timeLabel.text = @"ALL DAY";
        _timeLabel.textColor = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
    } else {
        _timeLabel.textColor = [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1.0];
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
    CGRect timeFrame = _timeLabel.frame;
    timeFrame.origin.y = 0;
    timeFrame.size.height = self.contentView.bounds.size.height;
    _timeLabel.frame = timeFrame;
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
