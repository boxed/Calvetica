//
//  CVTextToggleButton.m
//  calvetica
//
//  Created by Adam Kirk on 5/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTextToggleButton.h"
#import "UILabel+Utilities.h"
#import "colors.h"


@implementation CVTextToggleButton

- (void)setup 
{
    [super setup];
    self.selectable = YES;
    self.backgroundColorHighlighted = patentedClear;
    self.backgroundColorNormal = patentedClear;
    self.backgroundColorSelected = patentedClear;
}

- (void)setSelected:(BOOL)s 
{
    super.selected = s;
    if (self.selected) {
        [self.titleLabel setBlackWithLightShadow];
    } else {
        [self.titleLabel setWhiteWithDarkShadow];
    }
}

@end
