//
//  CVSevenButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/13.
//
//

#import "CVSevenButton.h"

@implementation CVSevenButton

- (void)setupPencil
{
    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[_pencil move] delay:0.5] color:[UIColor whiteColor]];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMidX(rect) + 5, CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMinX(rect) + 5, CGRectGetMaxY(rect))];
}

@end
