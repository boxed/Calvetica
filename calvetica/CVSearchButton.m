//
//  CVSearchButton.m
//  calvetica
//
//  Created by Adam Kirk on 10/21/13.
//
//

#import "CVSearchButton.h"

@implementation CVSearchButton

- (void)setupPencil
{
    [super setupPencil];

    [[[_pencil config] delay:0.1] duration:0.5];

    CGRect frame = CGRectMake(0, 0, 19, 19);
    frame.origin.x = (self.width / 2) - (frame.size.width / 2);
    frame.origin.y = (self.height / 2) - (frame.size.height / 2);

    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 18.5, CGRectGetMinY(frame) + 18.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 12.5, CGRectGetMinY(frame) + 12.5)];
    [bezierPath appendPath:[UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 0.5, 14, 14)]];
    [[_pencil draw] path:bezierPath.CGPath];
}

@end
