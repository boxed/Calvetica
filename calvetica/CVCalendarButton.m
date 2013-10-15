//
//  CVCheckmarkButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVCalendarButton.h"


@implementation CVCalendarButton

- (void)setupPencil
{
    [super setupPencil];

    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[_pencil config] delay:0.5] duration:0.2];
    CGFloat y           = CGRectGetHeight(rect) * (1/3.0);
    UIBezierPath *path  = [UIBezierPath bezierPathWithRect:rect];
    [[_pencil draw] path:path.CGPath];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + y)];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + y)];
}

@end
