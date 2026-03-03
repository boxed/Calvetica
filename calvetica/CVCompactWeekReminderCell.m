//
//  CVCompactWeekReminderCell.m
//  calvetica
//
//  Compact week view reminder cell with day column layout.
//

#import "CVCompactWeekReminderCell.h"

static NSString * const kCellIdentifier = @"CVCompactWeekReminderCell";
static CGFloat const kDayLabelWidth = 45.0f;
static CGFloat const kDayLabelX = 8.0f;
static CGFloat const kTimeColumnX = 61.0f;
static CGFloat const kTimeColumnWidth = 50.0f;
static CGFloat const kColoredDotSize = 14.0f;

@interface CVCompactWeekReminderCell ()
@property (nonatomic, assign) float appliedFontScale;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *daySeparatorLine;
@end

@implementation CVCompactWeekReminderCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    CVCompactWeekReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CVCompactWeekReminderCell alloc] initWithStyle:UITableViewCellStyleDefault
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

    // Time label
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _timeLabel.textColor = UIColor.labelColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];

    // AM/PM label
    _AMPMLabel = [[UILabel alloc] init];
    _AMPMLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    _AMPMLabel.textColor = UIColor.labelColor;
    _AMPMLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_AMPMLabel];

    // All day label
    _allDayLabel = [[UILabel alloc] init];
    _allDayLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightMedium];
    _allDayLabel.textColor = UIColor.labelColor;
    _allDayLabel.text = NSLocalizedString(@"all-day", nil);
    _allDayLabel.hidden = YES;
    [self.contentView addSubview:_allDayLabel];

    // Colored dot (checkmark shape for reminders)
    _coloredDotView = [[CVColoredDotView alloc] init];
    _coloredDotView.shape = CVColoredShapeCheck;
    [self.contentView addSubview:_coloredDotView];

    // Title label
    _titleLabel = [[CVStrikethroughLabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _titleLabel.textColor = UIColor.labelColor;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
}

- (void)applyFontScaleIfNeeded
{
    if (!IS_MAC) return;
    float scale = PREFS.macFontScale;
    if (self.appliedFontScale == scale) return;
    self.appliedFontScale = scale;
    self.dayLabel.font   = [UIFont systemFontOfSize:10 * scale weight:UIFontWeightMedium];
    _timeLabel.font      = [UIFont systemFontOfSize:14 * scale weight:UIFontWeightRegular];
    _AMPMLabel.font      = [UIFont systemFontOfSize:9 * scale weight:UIFontWeightRegular];
    _allDayLabel.font    = [UIFont systemFontOfSize:9 * scale weight:UIFontWeightMedium];
    _titleLabel.font     = [UIFont systemFontOfSize:14 * scale weight:UIFontWeightRegular];
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
    CGFloat dayLabelW = kDayLabelWidth * scale;
    CGFloat timeColumnX = kDayLabelX + dayLabelW + 7;
    CGFloat timeHourW = 35 * scale;
    CGFloat timeAmpmW = 20 * scale;
    CGFloat timeColumnW = timeHourW + timeAmpmW;
    CGFloat dotSize = kColoredDotSize * scale;

    // Day label (left column)
    self.dayLabel.frame = CGRectMake(kDayLabelX, 0, dayLabelW, contentHeight);

    // Time column
    CGFloat timeH = 18 * scale;
    CGFloat timeY = (contentHeight - timeH) / 2;
    _timeLabel.frame = CGRectMake(timeColumnX, timeY, timeHourW, timeH);
    _AMPMLabel.frame = CGRectMake(timeColumnX + timeHourW + 1, timeY + 3, timeAmpmW, 14 * scale);

    // All day label (centered in time column area)
    _allDayLabel.frame = CGRectMake(timeColumnX, (contentHeight - 14 * scale) / 2, timeColumnW, 14 * scale);

    // Colored dot and title
    CGFloat titleX = timeColumnX + timeColumnW + 4;
    CGFloat titleWidth = contentWidth - titleX - 16;

    _coloredDotView.frame = CGRectMake(titleX, (contentHeight - dotSize) / 2, dotSize, dotSize);
    CGFloat titleLabelX = titleX + dotSize + 4 * scale;
    _titleLabel.frame = CGRectMake(titleLabelX, (contentHeight - 20 * scale) / 2, titleWidth - dotSize - 4 * scale, 20 * scale);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dayLabel.text = nil;
    _timeLabel.text = nil;
    _timeLabel.hidden = NO;
    _AMPMLabel.text = nil;
    _AMPMLabel.hidden = NO;
    _AMPMLabel.alpha = 1.0;
    _allDayLabel.hidden = YES;
    _titleLabel.text = nil;
    _titleLabel.attributedText = nil;
    _titleLabel.alpha = 1.0;
    _coloredDotView.color = nil;
    self.daySeparatorLine.hidden = YES;
    self.backgroundColor = nil;
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

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
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

@end
