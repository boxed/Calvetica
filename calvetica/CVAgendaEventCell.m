//
//  CVAgendaEventCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaEventCell.h"
#import "colors.h"

static NSString * const kCellIdentifier = @"CVAgendaEventCell";

@interface CVAgendaEventCell ()
@property (nonatomic, strong)          UILabel              *timeLabel;
@property (nonatomic, assign)          BOOL                 isAllDay;
@property (nonatomic, assign)          BOOL                 continuedFromPreviousDay;
@end


@implementation CVAgendaEventCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    CVAgendaEventCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CVAgendaEventCell alloc] initWithStyle:UITableViewCellStyleDefault
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
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);

    // Layout constants
    CGFloat cellH       = 19;
    CGFloat timeX       = 14;
    CGFloat timeW       = 80;
    CGFloat dotMargin   = 6;
    CGFloat dotSize     = 7;
    CGFloat dotX        = timeX + timeW + dotMargin;
    CGFloat titleMargin = 5;
    CGFloat titleX      = dotX + dotSize + titleMargin;

    // Time label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, 2, timeW, cellH - 4)];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.textColor = [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.lineBreakMode = NSLineBreakByClipping;
    [self.contentView addSubview:self.timeLabel];

    // Colored dot
    self.coloredDotView = [[CVColoredDotView alloc] initWithFrame:CGRectMake(dotX, 6, dotSize, dotSize)];
    self.coloredDotView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.coloredDotView];

    // Title label
    self.calendarItemTitleLabel = [[CVStrikethroughLabel alloc] initWithFrame:CGRectMake(titleX, 0, 320 - titleX, cellH)];
    self.calendarItemTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.calendarItemTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.calendarItemTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.calendarItemTitleLabel];

    // Gesture hit area
    self.gestureHitArea = [[UIView alloc] initWithFrame:CGRectMake(dotX - 6, 0, 320 - dotX + 6, cellH)];
    self.gestureHitArea.backgroundColor = [UIColor clearColor];
    self.gestureHitArea.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.gestureHitArea];

    // Hour time hit area (tapping time area triggers accessoryButtonWasTapped:)
    UIControl *hourHitArea = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, timeX + timeW - 2, cellH)];
    hourHitArea.backgroundColor = [UIColor clearColor];
    [hourHitArea addTarget:self
                    action:@selector(accessoryButtonWasTapped:)
          forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:hourHitArea];

    // Set up gestures (tap, long press, swipe)
    [self setupGestures];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.calendarItemTitleLabel.text = nil;
    self.calendarItemTitleLabel.attributedText = nil;
    self.timeLabel.text = nil;
    self.timeLabel.hidden = NO;
    self.coloredDotView.hidden = NO;
    self.coloredDotView.color = nil;
    self.backgroundColor = calBackgroundColor();
    _calendarItem = nil;
    _isAllDay = NO;
    _continuedFromPreviousDay = NO;
}

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

    CGFloat h = self.contentView.frame.size.height;
    CGFloat w = self.contentView.frame.size.width;
    CGFloat s = IS_MAC ? PREFS.macFontScale : 1.0f;

    CGFloat timeX       = 14;
    CGFloat timeW       = 80 * s;
    CGFloat dotMargin   = 6;
    CGFloat dotSize     = 7 * s;
    CGFloat titleMargin = 5;

    CGFloat dotX   = timeX + timeW + dotMargin;
    CGFloat titleX = dotX + dotSize + titleMargin;

    // Align time label and dot with the first line of the title
    CGFloat lineH = self.calendarItemTitleLabel.font.lineHeight;
    CGFloat firstLineCenter = lineH / 2 + 3; // 3pt top padding from cell height calc

    _timeLabel.frame = CGRectMake(timeX, firstLineCenter - lineH / 2, timeW, lineH);
    self.coloredDotView.frame = CGRectMake(dotX, firstLineCenter - dotSize / 2, dotSize, dotSize);
    self.calendarItemTitleLabel.frame = CGRectMake(titleX, 0, w - titleX, h);
}

- (void)applyFontScale
{
    CGFloat baseSize = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote].pointSize;
    CGFloat scaledSize = baseSize * PREFS.macFontScale;
    self.calendarItemTitleLabel.font = [self.calendarItemTitleLabel.font fontWithSize:scaledSize];
    _timeLabel.font = [_timeLabel.font fontWithSize:scaledSize];
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
