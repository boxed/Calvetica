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

- (void)setHighlighted:(BOOL)highlighted 
{
    super.highlighted = highlighted;
    if (self.highlighted) {
        [self.titleLabel setBlackWithLightShadow];
    } else {
        [self.titleLabel setWhiteWithDarkShadow];
    }
}

@end
