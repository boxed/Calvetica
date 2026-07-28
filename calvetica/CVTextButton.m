//
//  CVTextButton.m
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CVTextButton.h"
#import "UILabel+Utilities.h"
#import "colors.h"


@implementation CVTextButton

- (void)setup
{
    [super setup];
    self.backgroundColorHighlighted = patentedClear;
    self.backgroundColorNormal = patentedClear;
    self.backgroundColorSelected = patentedClear;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Sits on a theme-colored bar, so pick a label color legible on that theme
    // (fixed white would be unreadable on a light theme color).
    [self setHighlighted:NO];
}

- (void)setHighlighted:(BOOL)highlighted
{
    super.highlighted = highlighted;
    // Normal: legible foreground for the theme color. Highlighted: invert it so
    // the tap still gives visible feedback on any theme.
    BOOL themeIsLight = calColorIsLight(calThemeColor());
    BOOL useDarkText  = self.highlighted ? !themeIsLight : themeIsLight;
    self.titleLabel.textColor = useDarkText ? [UIColor blackColor] : [UIColor whiteColor];
}

@end
