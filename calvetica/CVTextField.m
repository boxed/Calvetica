//
//  CVTextField.m
//  calvetica
//
//  Created by Adam Kirk on 5/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTextField.h"


@implementation CVTextField

- (CGRect)editingRectForBounds:(CGRect)bounds 
{
    CGFloat inset = 7;
    CGRect f = bounds;
    f.origin.x = inset;
    f.origin.y = 0;
    f.size.width -= inset * 2;
    return f;
}

- (CGRect)textRectForBounds:(CGRect)bounds 
{
    CGFloat inset = 7;
    CGRect f = bounds;
    f.origin.x = inset;
    f.origin.y = 0;
    f.size.width -= inset * 2;
    return f;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds 
{
    CGFloat inset = 12;
    CGRect f = bounds;
    f.origin.x = inset;
    f.origin.y = 0;
    f.size.width -= inset * 2;
    return f;
}

@end