//
//  CVCustomButton.m
//  calvetica
//
//  Created by James Schultz on 4/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVButton.h"
#import "colors.h"

@implementation CVButton


- (void)setup 
{
    self.textColorNormal = calQuaternaryText();
    self.textColorHighlighted = calBackgroundColor();
    self.textColorSelected = calBackgroundColor();
    self.backgroundColorSelected = patentedRed;
    self.backgroundColorHighlighted = calTextColor();
    self.backgroundColorNormal = patentedClear;
    self.selectable = NO;
}

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];    
        self.selected = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];

    self.textColorNormal = self.titleLabel.textColor;
    self.backgroundColorNormal = self.backgroundColor;

    // Buttons that baked in the old "patented red" now follow the configurable
    // theme color, with legible (black/white) text on light or dark themes.
    if (calColorIsLegacyPatentedRed(self.backgroundColorNormal)) {
        // Preserve the old two-tone look (e.g. darker keypad keys on a lighter
        // panel): map darker baked reds to a darker shade of the theme color.
        CGFloat r, g, b, a;
        [self.backgroundColorNormal getRed:&r green:&g blue:&b alpha:&a];
        UIColor *normalBg   = (r < 0.72f) ? calThemeColorDark() : calThemeColor();
        UIColor *selectedBg = calThemeColorDarker();

        self.backgroundColorNormal   = normalBg;
        self.backgroundColorSelected = selectedBg;
        self.textColorNormal         = calLegibleForegroundForColor(normalBg);
        self.textColorSelected       = calLegibleForegroundForColor(selectedBg);

        // Native UIButton titles are driven by per-state colors, so update those
        // too (view-based CVViewButtons don't use them, so this is harmless there).
        [self setTitleColor:self.textColorNormal   forState:UIControlStateNormal];
        [self setTitleColor:self.textColorSelected forState:UIControlStateSelected];
    }

    self.selected = NO;

    [super awakeFromNib];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled 
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (userInteractionEnabled) {
        self.alpha = 1;
    } else {
        self.alpha = 0.3;
    }
}

- (void)setSelected:(BOOL)selected 
{
    super.selected = selected;
    if (selected) {
        self.backgroundColor = self.backgroundColorSelected;
        self.titleLabel.textColor = self.textColorSelected;
    } else {
        self.backgroundColor = self.backgroundColorNormal;
        self.titleLabel.textColor = self.textColorNormal;
    }
}

- (void)setHighlighted:(BOOL)highlighted 
{
    if (_selectable) return;
    
    super.highlighted = highlighted;
    if (highlighted) {
        self.backgroundColor = self.backgroundColorHighlighted;
        self.titleLabel.textColor = self.textColorHighlighted;
    } else {
        if (self.selected) {
            self.backgroundColor = self.backgroundColorSelected;
            self.titleLabel.textColor = self.textColorSelected;
        }
        else {
            self.backgroundColor = self.backgroundColorNormal;
            self.titleLabel.textColor = self.textColorNormal;            
        }
    }
}

- (void)setEnabled:(BOOL)enabled 
{
    super.enabled = enabled;
    self.userInteractionEnabled = enabled;
}



#pragma mark - Actions
/*
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if (!selectable) {
        self.highlighted = YES;
        return [super beginTrackingWithTouch:touch withEvent:event];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if (!selectable) {
        self.highlighted = NO;       
    }
    
    [super endTrackingWithTouch:touch withEvent:event];
}
 */

@end
