//
//  CVEventBarWithTitle_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventBarWithTitle_iPad.h"


@implementation CVEventBarWithTitle_iPad

@synthesize coloredDot;
@synthesize titleLabel;


- (void)awakeFromNib {
    coloredDot.delegate = self;
    [super awakeFromNib];
}

- (void)coloredDot:(CVColoredDotView *)coloredDot didChangeColor:(UIColor *)color {
    
    // if nil or black, make white
    if (!color) {
        [titleLabel setWhiteNoShadow];
        return;
    }
    
    if ([color shouldUseLightText]) {
        [titleLabel setWhiteNoShadow];
    }
    else {
        [titleLabel setBlackNoShadow];
    }
}

@end
