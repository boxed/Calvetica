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
    self.textColor = patentedWhite;
}

- (void)setWhiteWithDarkShadow 
{
    self.textColor = patentedWhite;
}

- (void)setBlackWithLightShadow 
{
    self.textColor = patentedBlack;
}

- (void)setBlackWithDarkShadow 
{
    self.textColor = patentedBlack;
}

- (void)setDarkGrayWithLightShadow 
{
    self.textColor = patentedQuiteDarkGray;
}

- (void)setDarkGrayWithDarkShadow 
{
    self.textColor = patentedQuiteDarkGray;
}

- (void)setWhiteNoShadow 
{
    self.textColor = patentedWhite;
}

- (void)setBlackNoShadow 
{
    self.textColor = patentedBlack;
}

- (void)setDarkGrayNoShadow 
{
    self.textColor = patentedQuiteDarkGray;
}

@end