//
//  CVCompactWeekEventCell.m
//  calvetica
//
//  Compact week view event cell with day column layout.
//

#import "CVCompactWeekEventCell.h"
#import "CVCellAccessoryButton.h"
#import "CVColoredDotView.h"

static NSString * const kCellIdentifier = @"CVCompactWeekEventCell";
static CGFloat const kDayLabelWidth = 45.0f;
static CGFloat const kDayLabelX = 8.0f;
static CGFloat const kTimeColumnX = 60.0f;
static CGFloat const kTimeColumnWidth = 54.0f;
static CGFloat const kAccessoryButtonWidth = 44.0f;
static CGFloat const kColoredDotSize = 8.0f;

@interface CVCompactWeekEventCell ()
@property (nonatomic, assign) float appliedFontScale;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *hourAndMinuteLabel;
@property (nonatomic, strong) UILabel *AMPMLabel;
@property (nonatomic, strong) UILabel *allDayLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *endAMPMLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CVColoredDotView *coloredDotView;
@property (nonatomic, strong) CVCellAccessoryButton *cellAccessoryButton;
@property (nonatomic, strong) UIView *daySeparatorLine;
@end

@implementation CVCompactWeekEventCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    CVCompactWeekEventCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CVCompactWeekEventCell alloc] initWithStyle:UITableViewCellStyleDefault
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

    // Day separator line (shown at top of first item of each day)
    self.daySeparatorLine = [[UIView alloc] init];
    self.daySeparatorLine.backgroundColor = UIColor.separatorColor;
    self.daySeparatorLine.hidden = YES;
    [self.contentView addSubview:self.daySeparatorLine];

    // Day label (left column)
    self.dayLabel = [[UILabel alloc] init];
    self.dayLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    self.dayLabel.textColor = UIColor.secondaryLabelColor;
    self.dayLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.dayLabel];

    // Time labels
    self.hourAndMinuteLabel = [[UILabel alloc] init];
    self.hourAndMinuteLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.hourAndMinuteLabel.textColor = UIColor.labelColor;
    self.hourAndMinuteLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.hourAndMinuteLabel];

    self.AMPMLabel = [[UILabel alloc] init];
    self.AMPMLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightRegular];
    self.AMPMLabel.textColor = UIColor.labelColor;
    self.AMPMLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.AMPMLabel];

    // End time labels (smaller, positioned below start time)
    self.endTimeLabel = [[UILabel alloc] init];
    self.endTimeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    self.endTimeLabel.textColor = UIColor.secondaryLabelColor;
    self.endTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.endTimeLabel];

    self.endAMPMLabel = [[UILabel alloc] init];
    self.endAMPMLabel.font = [UIFont systemFontOfSize:7 weight:UIFontWeightRegular];
    self.endAMPMLabel.textColor = UIColor.secondaryLabelColor;
    self.endAMPMLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.endAMPMLabel];

    // All day label
    self.allDayLabel = [[UILabel alloc] init];
    self.allDayLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
    self.allDayLabel.textColor = [UIColor redColor];
    self.allDayLabel.textAlignment = NSTextAlignmentRight;
    self.allDayLabel.text = NSLocalizedString(@"all-day", nil);
    self.allDayLabel.hidden = YES;
    [self.contentView addSubview:self.allDayLabel];

    // Colored dot
    self.coloredDotView = [[CVColoredDotView alloc] init];
    self.coloredDotView.shape = CVColoredShapeCircle;
    [self.contentView addSubview:self.coloredDotView];

    // Title label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.titleLabel.textColor = UIColor.labelColor;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.titleLabel];

    // Accessory button (alarm) - added to self, not contentView, to position flush right
    self.cellAccessoryButton = [[CVCellAccessoryButton alloc] init];
    [self.cellAccessoryButton addTarget:self
                                 action:@selector(accessoryButtonWasTapped:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cellAccessoryButton];

    // Add tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(cellWasTapped:)];
    [self.contentView addGestureRecognizer:tapGesture];

    // Add long press gesture
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(cellWasLongPressed:)];
    [self.contentView addGestureRecognizer:longPressGesture];

    // Add swipe gestures for delete
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(cellWasSwiped:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeftGesture];

    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(cellWasSwiped:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRightGesture];
}

- (void)applyFontScaleIfNeeded
{
    if (!IS_MAC) return;
    float scale = PREFS.macFontScale;
    if (self.appliedFontScale == scale) return;
    self.appliedFontScale = scale;
    self.dayLabel.font          = [UIFont systemFontOfSize:10 * scale weight:UIFontWeightMedium];
    self.hourAndMinuteLabel.font = [UIFont systemFontOfSize:12 * scale weight:UIFontWeightRegular];
    self.AMPMLabel.font         = [UIFont systemFontOfSize:8 * scale weight:UIFontWeightRegular];
    self.endTimeLabel.font      = [UIFont systemFontOfSize:10 * scale weight:UIFontWeightRegular];
    self.endAMPMLabel.font      = [UIFont systemFontOfSize:7 * scale weight:UIFontWeightRegular];
    self.allDayLabel.font       = [UIFont systemFontOfSize:9 * scale weight:UIFontWeightMedium];
    self.titleLabel.font        = [UIFont systemFontOfSize:14 * scale weight:UIFontWeightRegular];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self applyFontScaleIfNeeded];

    CGFloat contentHeight = self.contentView.bounds.size.height;
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat scale = IS_MAC ? PREFS.macFontScale : 1.0f;

    // Day separator line at top (spans full width)
    self.daySeparatorLine.frame = CGRectMake(0, 0, contentWidth, 1.0 / UIScreen.mainScreen.scale);

    // Scaled column positions
    CGFloat dayLabelX = kDayLabelX;
    CGFloat dayLabelW = kDayLabelWidth * scale;
    CGFloat timeColumnX = dayLabelX + dayLabelW + 7;
    CGFloat timeHourW = 38 * scale;
    CGFloat timeAmpmW = 16 * scale;
    CGFloat timeColumnW = timeHourW + timeAmpmW;
    CGFloat dotSize = kColoredDotSize * scale;

    // Day label
    self.dayLabel.frame = CGRectMake(dayLabelX, 0, dayLabelW, contentHeight);

    // Time column
    CGFloat timeH = 15 * scale;
    CGFloat endTimeH = 13 * scale;
    CGFloat timeY;
    CGFloat verticalCenter;

    if (self.endTimeLabel.hidden) {
        // No end time: center everything at cell midpoint
        timeY = (contentHeight - timeH) / 2;
        verticalCenter = contentHeight / 2;
    } else {
        // End time shown: center the time block, align dot/title with start time
        CGFloat totalTimeH = timeH + endTimeH;
        timeY = (contentHeight - totalTimeH) / 2;
        verticalCenter = timeY + timeH / 2;
    }

    self.hourAndMinuteLabel.frame = CGRectMake(timeColumnX, timeY, timeHourW, timeH);
    self.AMPMLabel.frame = CGRectMake(timeColumnX + timeHourW, timeY + 2, timeAmpmW, 11 * scale);

    // End time labels (below start time)
    CGFloat endTimeY = timeY + timeH;
    self.endTimeLabel.frame = CGRectMake(timeColumnX, endTimeY, timeHourW, endTimeH);
    self.endAMPMLabel.frame = CGRectMake(timeColumnX + timeHourW, endTimeY + 1, timeAmpmW, 11 * scale);

    // All day label (right-aligned in time column area)
    self.allDayLabel.frame = CGRectMake(timeColumnX - 15, (contentHeight - 14 * scale) / 2, timeColumnW, 14 * scale);

    // Accessory button (right side, flush to cell edge)
    CGFloat accessoryWidth = 44;
    CGFloat cellWidth = self.bounds.size.width;
    CGFloat cellHeight = self.bounds.size.height;
    CGFloat accessoryX = cellWidth - accessoryWidth;
    self.cellAccessoryButton.frame = CGRectMake(accessoryX, 0, accessoryWidth, cellHeight);
    self.cellAccessoryButton.mode = self.cellAccessoryButton.mode;

    // Colored dot and title — aligned with start time center
    CGFloat dotGap = 5 * scale;
    CGFloat dotX = timeColumnX + timeColumnW - dotGap;
    CGFloat titleLabelX = dotX + dotSize + dotGap;
    CGFloat titleWidth = accessoryX - titleLabelX - 8;
    CGFloat titleH = 20 * scale;

    self.coloredDotView.frame = CGRectMake(dotX, verticalCenter - dotSize / 2, dotSize, dotSize);
    self.titleLabel.frame = CGRectMake(titleLabelX, verticalCenter - titleH / 2, titleWidth, titleH);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dayLabel.text = nil;
    self.hourAndMinuteLabel.text = nil;
    self.AMPMLabel.text = nil;
    self.endTimeLabel.text = nil;
    self.endAMPMLabel.text = nil;
    self.titleLabel.text = nil;
    self.allDayLabel.hidden = YES;
    self.hourAndMinuteLabel.hidden = NO;
    self.AMPMLabel.hidden = NO;
    self.endTimeLabel.hidden = YES;
    self.endAMPMLabel.hidden = YES;
    self.daySeparatorLine.hidden = YES;
    self.coloredDotView.color = nil;
    self.cellAccessoryButton.defaultImage = nil;
    _event = nil;
    _date = nil;
    _isToday = NO;
}

#pragma mark - Properties

- (void)setDayLabelText:(NSString *)dayLabelText
{
    _dayLabelText = [dayLabelText copy];
    self.dayLabel.text = _dayLabelText;
    // Show separator line when this is the first item of a day (has day text)
    self.daySeparatorLine.hidden = (_dayLabelText.length == 0);
}

- (void)setDate:(NSDate *)date
{
    _date = date;

    if (_date != nil) {
        if (![_date mt_isStartOfAnHour]) {
            self.hourAndMinuteLabel.alpha = 0.8f;
            self.AMPMLabel.alpha = 0.8f;
        } else {
            self.hourAndMinuteLabel.alpha = 1;
            self.AMPMLabel.alpha = 1;
        }
        self.hourAndMinuteLabel.text = [_date stringWithHourAndMinute];
        self.AMPMLabel.text = [_date stringWithAMPM];
    } else {
        self.hourAndMinuteLabel.text = @"...";
        self.AMPMLabel.text = @"";
    }
}

- (void)setEvent:(EKEvent *)event
{
    _event = event;

    if (event) {
        self.titleLabel.text = [event mys_title];
        self.coloredDotView.color = [event.calendar customColor];
        self.cellAccessoryButton.defaultImage = [UIImage imageNamed:(event.alarms.count > 0 ? @"icon_alarm_selected" : @"icon_alarm")];

        if (!event.calendar.allowsContentModifications) {
            self.cellAccessoryButton.alpha = 0.3;
        } else {
            self.cellAccessoryButton.alpha = 1;
        }

        // Set background color (respects isToday)
        [self updateBackgroundColor];

        // Set end time display (only if not all-day and end time differs from start)
        [self updateEndTimeDisplay];

        self.titleLabel.hidden = NO;
        self.coloredDotView.hidden = NO;
        self.cellAccessoryButton.hidden = NO;
    } else {
        self.titleLabel.hidden = YES;
        self.coloredDotView.hidden = YES;
        self.cellAccessoryButton.hidden = YES;
    }
}

- (void)setIsAllDay:(BOOL)isAllDay
{
    _isAllDay = isAllDay;

    if (_isAllDay) {
        self.allDayLabel.hidden = NO;
        self.AMPMLabel.hidden = YES;
        self.hourAndMinuteLabel.hidden = YES;
        self.endTimeLabel.hidden = YES;
        self.endAMPMLabel.hidden = YES;
    } else {
        self.allDayLabel.hidden = YES;
        self.AMPMLabel.hidden = NO;
        self.hourAndMinuteLabel.hidden = NO;
        [self updateEndTimeDisplay];
    }
}

- (void)updateEndTimeDisplay
{
    // Don't show end time for all-day events
    if (_isAllDay) {
        self.endTimeLabel.hidden = YES;
        self.endAMPMLabel.hidden = YES;
        return;
    }

    // Don't show end time if we don't have an event or start date
    if (!_event || !_date) {
        self.endTimeLabel.hidden = YES;
        self.endAMPMLabel.hidden = YES;
        return;
    }

    NSDate *endDate = _event.endDate;

    // Don't show if end time equals start time
    if (!endDate || [endDate timeIntervalSinceDate:_date] <= 0) {
        self.endTimeLabel.hidden = YES;
        self.endAMPMLabel.hidden = YES;
        return;
    }

    // Show end time
    self.endTimeLabel.hidden = NO;
    self.endAMPMLabel.hidden = NO;

    self.endTimeLabel.text = [endDate stringWithHourAndMinute];
    self.endAMPMLabel.text = [endDate stringWithAMPM];
}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    [self updateBackgroundColor];
}

- (void)updateBackgroundColor
{
    if (_isToday) {
        // Use a light gray in light mode, dark gray in dark mode
        self.backgroundColor = calBorderColorLight();
        self.contentView.backgroundColor = calBorderColorLight();
    } else {
        self.backgroundColor = calBackgroundColor();
        self.contentView.backgroundColor = calBackgroundColor();
    }
}

- (void)resetAccessoryButton
{
    self.cellAccessoryButton.mode = CVCellAccessoryButtonModeDefault;
}

- (void)toggleAccessoryButton
{
    [UIView mt_animateWithDuration:0.20
                    timingFunction:kMTEaseInBack
                           options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                        animations:^
     {
         self.cellAccessoryButton.x += self.cellAccessoryButton.width;
     } completion:^{
         [self.cellAccessoryButton toggleMode];
         [UIView mt_animateWithDuration:0.20
                         timingFunction:kMTEaseOutBack
                                options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                             animations:^
          {
              self.cellAccessoryButton.x -= self.cellAccessoryButton.width;
          } completion:^{
          }];
    }];
}

#pragma mark - Actions

- (void)cellWasTapped:(UITapGestureRecognizer *)gesture
{
    [self.delegate calendarItemCell:self wasTappedForItem:self.event];
}

- (void)cellWasLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    [self.delegate calendarItemCell:self wasLongPressedForItem:self.event];
}

- (void)cellWasSwiped:(UISwipeGestureRecognizer *)gesture
{
    if (self.event) {
        [self toggleAccessoryButton];
    }
}

- (void)accessoryButtonWasTapped:(id)sender
{
    if (self.cellAccessoryButton.mode == CVCellAccessoryButtonModeDefault) {
        [self.delegate calendarItemCell:self tappedAlarmView:self.cellAccessoryButton forItem:self.event];
    } else {
        [self.delegate calendarItemCell:self tappedDeleteForItem:self.event];
        [self resetAccessoryButton];
    }
}

@end
