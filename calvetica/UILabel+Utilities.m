//
//  UILabel+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UILabel+Utilities.h"


@implementation UILabel (UILabel_Utilities)

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
    return ceilf(size.width / width);
}

- (CGFloat)totalHeightOfWordWrapTextInLabelWithConstraintWidth:(CGFloat)width 
{
    CGSize size = [self.text sizeWithFont:self.font];
    NSInteger lines = ceilf(size.width / width);
    return (size.height * lines);
}

- (void)setWhiteWithLightShadow 
{
    self.textColor = patentedWhite;
    self.shadowOffset = CGSizeMake(0,1);
    self.shadowColor = patentedBlackLightShadow;
}

- (void)setWhiteWithDarkShadow 
{
    self.textColor = patentedWhite;
    self.shadowOffset = CGSizeMake(0,1);
    self.shadowColor = patentedBlackDarkShadow;
}

- (void)setBlackWithLightShadow 
{
    self.textColor = patentedBlack;
    self.shadowOffset = CGSizeMake(0,1);
    self.shadowColor = patentedWhiteLightShadow;
}

- (void)setBlackWithDarkShadow 
{
    self.textColor = patentedBlack;
    self.shadowOffset = CGSizeMake(0,1);
    self.shadowColor = patentedWhiteDarkShadow;
}

- (void)setDarkGrayWithLightShadow 
{
    self.textColor = patentedDarkGray;
    self.shadowOffset = CGSizeMake(0,1);
    self.shadowColor = patentedWhiteLightShadow;
}

- (void)setDarkGrayWithDarkShadow 
{
    self.textColor = patentedDarkGray;
    self.shadowOffset = CGSizeMake(0,1);
    self.shadowColor = patentedWhiteDarkShadow;
}

- (void)setWhiteNoShadow 
{
    self.textColor = patentedWhite;
    self.shadowOffset = CGSizeMake(0,0);
    self.shadowColor = nil;
}

- (void)setBlackNoShadow 
{
    self.textColor = patentedBlack;
    self.shadowOffset = CGSizeMake(0,0);
    self.shadowColor = nil;
}

- (void)setDarkGrayNoShadow 
{
    self.textColor = patentedDarkGray;
    self.shadowOffset = CGSizeMake(0,0);
    self.shadowColor = nil;
}

@end