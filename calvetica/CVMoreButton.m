//
//  CVMoreButton.m
//  calvetica
//
//  Created by Adam Kirk on 10/2/13.
//
//

#import "CVMoreButton.h"

@implementation CVMoreButton

- (void)setupPencil
{
    [super setupPencil];
    
    CGRect frame = CGRectMake(0, 0, 46, 12);
    frame.origin.x = (self.width / 2) - (frame.size.width / 2);
    frame.origin.y = (self.height / 2) - (frame.size.height / 2);


    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 35.5, CGRectGetMinY(frame) + 1.5, 9, 9)];
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 18.5, CGRectGetMinY(frame) + 1.5, 9, 9)];
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 1.5, CGRectGetMinY(frame) + 1.5, 9, 9)];


    [[_pencil config] duration:0.2];
    [[_pencil move] to:CGPointMake(0, 6)];
    [[_pencil draw] path:oval2Path.CGPath];
    [[_pencil draw] path:ovalPath.CGPath];
    [[_pencil draw] path:oval3Path.CGPath];
}

@end
