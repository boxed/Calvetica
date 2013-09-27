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
    //// App Code
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(14.03, 8.16)];
    [path addLineToPoint: CGPointMake(14.03, 6.35)];
    [path addCurveToPoint: CGPointMake(14.94, 5.45) controlPoint1: CGPointMake(14.03, 6.35) controlPoint2: CGPointMake(14.32, 5.56)];
    [path addCurveToPoint: CGPointMake(19.06, 5.45) controlPoint1: CGPointMake(15.57, 5.34) controlPoint2: CGPointMake(19.06, 5.45)];
    [path addCurveToPoint: CGPointMake(19.97, 6.35) controlPoint1: CGPointMake(19.06, 5.45) controlPoint2: CGPointMake(19.99, 5.77)];
    [path addCurveToPoint: CGPointMake(19.97, 8.16) controlPoint1: CGPointMake(19.95, 6.94) controlPoint2: CGPointMake(19.97, 8.16)];
    [path moveToPoint: CGPointMake(19.97, 10.86)];
    [path addLineToPoint: CGPointMake(19.51, 25.29)];
    [path moveToPoint: CGPointMake(16.77, 10.86)];
    [path addLineToPoint: CGPointMake(16.77, 25.29)];
    [path moveToPoint: CGPointMake(13.57, 10.86)];
    [path addLineToPoint: CGPointMake(14.03, 25.29)];
    [path moveToPoint: CGPointMake(9, 8.61)];
    [path addLineToPoint: CGPointMake(25, 8.61)];
    [path moveToPoint: CGPointMake(10.37, 8.61)];
    [path addLineToPoint: CGPointMake(11.29, 26.2)];
    [path addCurveToPoint: CGPointMake(12.66, 27.55) controlPoint1: CGPointMake(11.29, 26.2) controlPoint2: CGPointMake(11.63, 27.49)];
    [path addCurveToPoint: CGPointMake(20.89, 27.55) controlPoint1: CGPointMake(13.69, 27.61) controlPoint2: CGPointMake(20.89, 27.55)];
    [path addCurveToPoint: CGPointMake(22.71, 26.2) controlPoint1: CGPointMake(20.89, 27.55) controlPoint2: CGPointMake(22.6, 27.56)];
    [path addCurveToPoint: CGPointMake(23.63, 8.16) controlPoint1: CGPointMake(22.82, 24.84) controlPoint2: CGPointMake(23.63, 8.16)];

    [[[[[_pencil move] delay:0.1] color:[UIColor whiteColor]] width:1] duration:0.5];
    [[_pencil move] to:CGPointMake(0, 6)];
    [[_pencil draw] path:path.CGPath];
}

@end
