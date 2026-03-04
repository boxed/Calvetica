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

    // Time label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 56, 15)];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.textColor = [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];

    // Colored dot
    self.coloredDotView = [[CVColoredDotView alloc] initWithFrame:CGRectMake(76, 6, 7, 7)];
    self.coloredDotView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.coloredDotView];

    // Title label
    self.calendarItemTitleLabel = [[CVStrikethroughLabel alloc] initWithFrame:CGRectMake(88, 0, 212, 19)];
    self.calendarItemTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.calendarItemTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.calendarItemTitleLabel.numberOfLines = 0;
    self.calendarItemTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.calendarItemTitleLabel];

    // Gesture hit area
    self.gestureHitArea = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 250, 20)];
    self.gestureHitArea.backgroundColor = [UIColor clearColor];
    self.gestureHitArea.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.gestureHitArea];

    // Hour time hit area (tapping time area triggers accessoryButtonWasTapped:)
    UIControl *hourHitArea = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 68, 19)];
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
