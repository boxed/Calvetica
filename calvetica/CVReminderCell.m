//
//  CVReminderCell.m
//  calvetica
//
//  Created by Adam Kirk on 10/15/13.
//
//

#import "CVReminderCell.h"

static NSString * const kCellIdentifier = @"CVReminderCell";

@interface CVReminderCell ()
@end

@implementation CVReminderCell

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    CVReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[CVReminderCell alloc] initWithStyle:UITableViewCellStyleDefault
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
    CGFloat cellH          = 20;
    CGFloat timeX          = 8;
    CGFloat timeW          = 59;
    CGFloat ampmGap        = 2;
    CGFloat ampmW          = 27;
    CGFloat ampmX          = timeX + timeW + ampmGap;
    CGFloat timeColumnEnd  = ampmX + ampmW;
    CGFloat dotMargin      = -3;
    CGFloat dotW           = 12;
    CGFloat dotH           = 10;
    CGFloat dotX           = timeColumnEnd + dotMargin;
    CGFloat titleMargin    = 3;
    CGFloat titleX         = dotX + dotW + titleMargin;

    // Time label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeX, 0, timeW, cellH)];
    self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.timeLabel.textColor = [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1.0];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.lineBreakMode = NSLineBreakByClipping;
    self.timeLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.timeLabel];

    // AM/PM label
    self.AMPMLabel = [[UILabel alloc] initWithFrame:CGRectMake(ampmX, 0, ampmW, cellH)];
    self.AMPMLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.AMPMLabel.textColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.0];
    self.AMPMLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.AMPMLabel];

    // All day label (hidden by default)
    self.allDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, timeColumnEnd - 9, cellH)];
    self.allDayLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.allDayLabel.textColor = [UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1.0];
    self.allDayLabel.textAlignment = NSTextAlignmentCenter;
    self.allDayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.allDayLabel.numberOfLines = 2;
    self.allDayLabel.text = @"ALL DAY";
    self.allDayLabel.hidden = YES;
    self.allDayLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.allDayLabel];

    // Colored dot
    self.coloredDotView = [[CVColoredDotView alloc] initWithFrame:CGRectMake(dotX, 5, dotW, dotH)];
    self.coloredDotView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.coloredDotView];

    // Title label
    self.titleLabel = [[CVStrikethroughLabel alloc] initWithFrame:CGRectMake(titleX, 0, 320 - titleX, cellH)];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.titleLabel];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.titleLabel.attributedText = nil;
    self.timeLabel.text = nil;
    self.timeLabel.hidden = NO;
    self.AMPMLabel.text = nil;
    self.AMPMLabel.hidden = NO;
    self.allDayLabel.hidden = YES;
    self.coloredDotView.color = nil;
}

- (void)applyFontScaleIfNeeded
{
    if (!IS_MAC) return;
    float scale = PREFS.macFontScale;
    CGFloat baseSize = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote].pointSize;
    CGFloat scaledSize = baseSize * scale;
    self.titleLabel.font  = [self.titleLabel.font fontWithSize:scaledSize];
    self.timeLabel.font   = [self.timeLabel.font fontWithSize:scaledSize];
    self.AMPMLabel.font   = [self.AMPMLabel.font fontWithSize:scaledSize];
    self.allDayLabel.font = [self.allDayLabel.font fontWithSize:scaledSize];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self applyFontScaleIfNeeded];

    CGFloat h = self.contentView.frame.size.height;
    CGFloat w = self.contentView.frame.size.width;
    CGFloat s = IS_MAC ? PREFS.macFontScale : 1.0f;

    CGFloat timeX          = 8;
    CGFloat timeW          = 59 * s;
    CGFloat ampmGap        = 2;
    CGFloat ampmW          = 27 * s;
    CGFloat ampmX          = timeX + timeW + ampmGap;
    CGFloat timeColumnEnd  = ampmX + ampmW;
    CGFloat dotMargin      = -3;
    CGFloat dotW           = 12 * s;
    CGFloat dotH           = 10 * s;
    CGFloat dotX           = timeColumnEnd + dotMargin;
    CGFloat titleMargin    = 3;
    CGFloat titleX         = dotX + dotW + titleMargin;

    self.timeLabel.frame = CGRectMake(timeX, 0, timeW, h);
    self.AMPMLabel.frame = CGRectMake(ampmX, 0, ampmW, h);
    self.allDayLabel.frame = CGRectMake(9, 0, timeColumnEnd - 9, h);
    self.coloredDotView.frame = CGRectMake(dotX, (h - dotH) / 2, dotW, dotH);
    self.titleLabel.frame = CGRectMake(titleX, 0, w - titleX, h);
}

@end
