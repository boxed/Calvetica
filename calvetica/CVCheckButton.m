//
//  CVCheckButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/28/13.
//
//

#import "CVCheckButton.h"

@implementation CVCheckButton

- (void)setupPencil
{
    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[_pencil move] color:[UIColor whiteColor]] duration:0.15];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
}

@end
