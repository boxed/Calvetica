//
//  CVTwoBarButton.m
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

#import "CVTwoBarButton.h"

@implementation CVTwoBarButton

- (void)setupPencil
{
    [super setupPencil];

    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[_pencil config] delay:CVStackedBarButtonDuration] duration:CVStackedBarButtonDuration];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) - CVStackedBarButtonSpacing)];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect) - CVStackedBarButtonSpacing)];
}

@end
