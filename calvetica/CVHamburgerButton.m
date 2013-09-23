//
//  CVHamburgerButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVHamburgerButton.h"

@implementation CVHamburgerButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    rect.size.width     = 17;
    rect.size.height    = 14;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(      CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(   CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [path moveToPoint:CGPointMake(      CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [path addLineToPoint:CGPointMake(   CGRectGetMaxX(rect), CGRectGetMidY(rect))];
    [path moveToPoint:CGPointMake(      CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [path addLineToPoint:CGPointMake(   CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [[self titleColorForState:self.state] set];
    [path stroke];
}

@end
