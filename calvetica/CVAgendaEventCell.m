//
//  CVAgendaEventCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaEventCell.h"
#import "colors.h"


@interface CVAgendaEventCell ()
@property (nonatomic, weak  ) IBOutlet UILabel              *timeLabel;
@property (nonatomic, assign)          BOOL                 isAllDay;
@property (nonatomic, assign)          BOOL                 continuedFromPreviousDay;
@property (nonatomic, strong)          UIFont               *baseTitleFont;
@property (nonatomic, strong)          UIFont               *baseTimeFont;
@end


@implementation CVAgendaEventCell

- (void)setIsEmpty:(BOOL)empty
{
    super.isEmpty                       = empty;
    self.coloredDotView.hidden          = YES;
    self.timeLabel.hidden               = YES;
    self.calendarItemTitleLabel.text    = @"No Events";
}



#pragma mark - Methods

- (void)setCalendarItem:(EKCalendarItem *)newCalendarItem continued:(BOOL)continued allDay:(BOOL)isAllDay
{
    self.calendarItem = newCalendarItem;
	
	self.continuedFromPreviousDay = continued;
	self.isAllDay = isAllDay;
        
	// update event elements with even details
	self.coloredDotView.color = [self.calendarItem.calendar customColor];
	_timeLabel.textColor = calQuaternaryText();

    if (newCalendarItem.isReminder) {
        if ([(EKReminder *)newCalendarItem isCompleted]) {
            NSAttributedString *attributedTitle =
            [[NSAttributedString alloc] initWithString:newCalendarItem.mys_title
                                            attributes:@{ NSStrikethroughStyleAttributeName : @(YES) }];
            self.calendarItemTitleLabel.attributedText = attributedTitle;
        }
        else {
            self.calendarItemTitleLabel.text = self.calendarItem.mys_title;
        }
        self.backgroundColor        = [self.coloredDotView.color colorWithAlphaComponent:0.1];
        self.coloredDotView.shape   = CVColoredShapeCheck;
    }
    else {
        self.calendarItemTitleLabel.text    = self.calendarItem.mys_title;
        self.backgroundColor                = calBackgroundColor();
        self.coloredDotView.shape           = CVColoredShapeCircle;
    }

	// set cell time labels
    if (self.continuedFromPreviousDay) {
        _timeLabel.text = @"...";
    } 
	else if (self.isAllDay) {
		_timeLabel.text = @"ALL DAY";
		_timeLabel.textColor = patentedRed;
	}
	else {
		_timeLabel.text = [newCalendarItem.mys_date stringWithHourMinuteAndLowercaseAMPM];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.height  = self.height - 6;
    self.titleLabel.y       = 3;

    if (IS_MAC) {
        CGFloat scale = PREFS.macFontScale;
        CGFloat h = self.contentView.frame.size.height;
        CGFloat w = self.contentView.frame.size.width;

        // Scale time label
        CGFloat timeX = 2;
        CGFloat timeW = 70 * scale;
        _timeLabel.frame = CGRectMake(timeX, 0, timeW, h);

        // Scale dot
        CGFloat dotSize = 7.0f * scale;
        CGFloat dotX = timeX + timeW + 2;
        self.coloredDotView.frame = CGRectMake(dotX, (h - dotSize) / 2.0f, dotSize, dotSize);

        // Reposition title after dot
        CGFloat titleX = dotX + dotSize + 3 * scale;
        self.calendarItemTitleLabel.frame = CGRectMake(titleX, 0, w - titleX, h);
    }
}

- (void)applyFontScale
{
    if (!self.baseTitleFont) self.baseTitleFont = self.calendarItemTitleLabel.font;
    if (!self.baseTimeFont) self.baseTimeFont = _timeLabel.font;
    CGFloat scale = PREFS.macFontScale;
    self.calendarItemTitleLabel.font = [self.baseTitleFont fontWithSize:self.baseTitleFont.pointSize * scale];
    _timeLabel.font = [self.baseTimeFont fontWithSize:self.baseTimeFont.pointSize * scale];
}

#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender
{
    if (self.calendarItem.isEvent) {
        [super cellWasTapped:sender];
    }
    [self.delegate calendarItemCell:self wasTappedForItem:self.calendarItem];
}

- (IBAction)cellWasLongPressed:(UILongPressGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateBegan) return;
}

- (IBAction)accessoryButtonWasTapped:(id)sender 
{
    if (!self.isAllDay) {
        [self.delegate calendarItemCell:self
                             tappedTime:[self.calendarItem.mys_date mt_startOfCurrentHour]
                                   view:self.timeLabel];
    }
}

@end
