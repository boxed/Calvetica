//
//  CVGearButton.m
//  calvetica
//
//  Created by Adam Kirk on 10/21/13.
//
//

#import "CVGearButton.h"

@implementation CVGearButton

- (void)setupPencil
{
    [super setupPencil];

    CGRect frame = CGRectMake(0, 0, 20, 20);
    frame.origin.x = (self.width / 2) - (frame.size.width / 2);
    frame.origin.y = (self.height / 2) - (frame.size.height / 2);

    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.81, CGRectGetMinY(frame) + 2.52)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5.82, CGRectGetMinY(frame) + 0.08)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 13.19, CGRectGetMinY(frame) + 2.42)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.18, CGRectGetMinY(frame) + 0.03)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 17.47, CGRectGetMinY(frame) + 6.78)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 19.97, CGRectGetMinY(frame) + 5.84)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 17.52, CGRectGetMinY(frame) + 12.96)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 19.97, CGRectGetMinY(frame) + 14.1)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 13.19, CGRectGetMinY(frame) + 17.27)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.18, CGRectGetMinY(frame) + 19.97)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 6.87, CGRectGetMinY(frame) + 17.32)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5.82, CGRectGetMinY(frame) + 19.92)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 2.58, CGRectGetMinY(frame) + 12.96)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03, CGRectGetMinY(frame) + 14.1)];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 2.58, CGRectGetMinY(frame) + 6.88)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03, CGRectGetMinY(frame) + 5.79)];
    [bezierPath appendPath:[UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 2.5, CGRectGetMinY(frame) + 2.5, 15, 15)]];

    [[[_pencil config] delay:0.1] duration:0.5];
    [[_pencil draw] path:bezierPath.CGPath];
}

@end
