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
    return CGRectInset(bounds, 5, 5);
}

- (CGRect)textRectForBounds:(CGRect)bounds 
{
    return CGRectInset(bounds, 5, 5);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds 
{
    return CGRectInset(bounds, 5, 5);
}

@end