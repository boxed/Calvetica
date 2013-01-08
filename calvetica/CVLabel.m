//
//  CVLabel.m
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVLabel.h"


@implementation CVLabel

- (void)setStriked:(BOOL)newStriked 
{
    _striked = newStriked;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    
    if (_striked) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGSize textSize = [self sizeOfTextInLabel];
        NSInteger lines = [self linesOfWordWrapTextInLabelWithConstraintWidth:self.bounds.size.width];
        
        if (lines > 1 && self.numberOfLines > 1) {
            CGFloat length = [self.text sizeWithFont:self.font].width;
            for (NSInteger i = lines; i >= 1; i--) {
                
                CGFloat currentRowLength = length - (textSize.width * (i - 1));
                if (currentRowLength > self.bounds.size.width) {
                    currentRowLength = self.bounds.size.width - 25;
                }
                else {
                    currentRowLength += 25;
                }
                
                CGContextFillRect(context,CGRectMake(0, (textSize.height / 2) + (textSize.height * (i - 1)), currentRowLength, 1));
            }
        }
        else {
           CGContextFillRect(context,CGRectMake(0, rect.size.height / 2.0, textSize.width, 1)); 
        }
    }
}

@end
