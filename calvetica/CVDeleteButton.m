//
//  CVDeleteButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/25/13.
//
//

#import "CVDeleteButton.h"

@implementation CVDeleteButton

- (void)setupPencil
{
    [super setupPencil];
    
    CGRect frame = CGRectMake(0, 0, 15, 17);
    frame.origin.x = (self.width / 2) - (frame.size.width / 2);
    frame.origin.y = (self.height / 2) - (frame.size.height / 2);

    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 1.5, CGRectGetMinY(frame) + 2.5)];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1.5, CGRectGetMinY(frame) + 14.5)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.1, CGRectGetMinY(frame) + 16.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1.5, CGRectGetMinY(frame) + 14.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.17, CGRectGetMinY(frame) + 16.46)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 11.91, CGRectGetMinY(frame) + 16.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 4.03, CGRectGetMinY(frame) + 16.54) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 11.91, CGRectGetMinY(frame) + 16.5)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 13.51, CGRectGetMinY(frame) + 14.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 11.91, CGRectGetMinY(frame) + 16.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 13.41, CGRectGetMinY(frame) + 15.51)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 13.51, CGRectGetMinY(frame) + 2.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 13.61, CGRectGetMinY(frame) + 13.49) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 13.51, CGRectGetMinY(frame) + 2.5)];
    [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 5.5, CGRectGetMinY(frame) + 2.5)];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5.5, CGRectGetMinY(frame) + 1.5)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.3, CGRectGetMinY(frame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 5.5, CGRectGetMinY(frame) + 1.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 5.9, CGRectGetMinY(frame) + 0.58)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 8.7, CGRectGetMinY(frame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 6.7, CGRectGetMinY(frame) + 0.42) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 8.7, CGRectGetMinY(frame) + 0.5)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 9.5, CGRectGetMinY(frame) + 1.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 8.7, CGRectGetMinY(frame) + 0.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 9.51, CGRectGetMinY(frame) + 1.07)];
    [path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 9.5, CGRectGetMinY(frame) + 2.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 9.49, CGRectGetMinY(frame) + 1.93) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 9.5, CGRectGetMinY(frame) + 2.5)];
    [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 2.5)];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.5, CGRectGetMinY(frame) + 2.5)];
    [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.5, CGRectGetMinY(frame) + 4.5)];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 10.5, CGRectGetMinY(frame) + 14.5)];
    [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 7.5, CGRectGetMinY(frame) + 4.5)];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 7.5, CGRectGetMinY(frame) + 14.5)];
    [path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 4.5, CGRectGetMinY(frame) + 4.5)];
    [path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 4.5, CGRectGetMinY(frame) + 14.5)];


    [[[_pencil config] delay:0.15] duration:0.5];
    [[_pencil move] to:CGPointMake(0, 6)];
    [[_pencil draw] path:path.CGPath];
}

@end
