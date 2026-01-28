//
//  UILabel+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UILabel+Utilities.h"


@implementation UILabel (Utilities)

- (CGSize)sizeOfTextInLabel 
{
    CGSize s = [self.text sizeWithFont:self.font];
    if (s.width > self.frame.size.width) {
        s.width = self.frame.size.width;
    }
    else if (s.height > self.frame.size.height) {
        s.height = self.frame.size.height;
    }
    return s;
}

- (NSInteger)linesOfWordWrapTextInLabelWithConstraintWidth:(CGFloat)width 
{
    CGSize size = [self.text sizeWithFont:self.font];
    return floorf(size.width / width);
}

- (CGFloat)totalHeightOfWordWrapTextInLabelWithConstraintWidth:(CGFloat)width 
{
    CGSize size = [self.text sizeWithFont:self.font];
    NSInteger lines = floorf(size.width / width);
    return (size.height * lines);
}

- (void)setWhiteWithLightShadow 
{
    self.textColor = calBackgroundColor();
}

- (void)setWhiteWithDarkShadow 
{
    self.textColor = calBackgroundColor();
}

- (void)setBlackWithLightShadow 
{
    self.textColor = calTextColor();
}

- (void)setBlackWithDarkShadow 
{
    self.textColor = calTextColor();
}

- (void)setDarkGrayWithLightShadow 
{
    self.textColor = calQuaternaryText();
}

- (void)setDarkGrayWithDarkShadow 
{
    self.textColor = calQuaternaryText();
}

- (void)setWhiteNoShadow 
{
    self.textColor = calBackgroundColor();
}

- (void)setBlackNoShadow 
{
    self.textColor = calTextColor();
}

- (void)setDarkGrayNoShadow 
{
    self.textColor = calQuaternaryText();
}

@end
