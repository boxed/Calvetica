//
//  CVReminderCell.m
//  calvetica
//
//  Created by Adam Kirk on 10/15/13.
//
//

#import "CVReminderCell.h"


@interface CVReminderCell ()
@property (nonatomic, assign) float appliedFontScale;
@property (nonatomic, strong) NSDictionary *baseFonts;
@end

@implementation CVReminderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)applyFontScaleIfNeeded
{
    if (!IS_MAC) return;
    float scale = PREFS.macFontScale;
    if (self.appliedFontScale == scale) return;
    self.appliedFontScale = scale;
    if (!self.baseFonts) {
        self.baseFonts = @{
            @"title": self.titleLabel.font ?: [UIFont systemFontOfSize:14],
            @"time": self.timeLabel.font ?: [UIFont systemFontOfSize:14],
            @"ampm": self.AMPMLabel.font ?: [UIFont systemFontOfSize:10],
            @"allDay": self.allDayLabel.font ?: [UIFont systemFontOfSize:10],
        };
    }
    for (NSString *key in self.baseFonts) {
        UIFont *base = self.baseFonts[key];
        UIFont *scaled = [base fontWithSize:base.pointSize * scale];
        if ([key isEqualToString:@"title"]) self.titleLabel.font = scaled;
        else if ([key isEqualToString:@"time"]) self.timeLabel.font = scaled;
        else if ([key isEqualToString:@"ampm"]) self.AMPMLabel.font = scaled;
        else if ([key isEqualToString:@"allDay"]) self.allDayLabel.font = scaled;
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

        // Nib base: time x=0 w=41, ampm x=43 w=27, allDay x=9 w=50, dot x=67 w=12, title x=82
        CGFloat timeX = 0;
        CGFloat timeW = 41 * scale;
        CGFloat ampmX = timeX + timeW + 2;
        CGFloat ampmW = 27 * scale;
        CGFloat allDayW = (ampmX + ampmW) - 9;
        CGFloat dotX = ampmX + ampmW + 1;
        CGFloat dotSize = 12 * scale;
        CGFloat titleX = dotX + dotSize + 5 * scale;

        self.timeLabel.frame = CGRectMake(timeX, 0, timeW, h);
        self.AMPMLabel.frame = CGRectMake(ampmX, 0, ampmW, h);
        self.allDayLabel.frame = CGRectMake(9, 0, allDayW, h);
        self.coloredDotView.frame = CGRectMake(dotX, (h - dotSize) / 2, dotSize, dotSize);
        self.titleLabel.frame = CGRectMake(titleX, 0, w - titleX, h);
    }
}

@end
