//
//  CVAddButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVAddButton.h"

@implementation CVAddButton

- (void)setupPencil
{
    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[[_pencil move] delay:0.5] color:[UIColor whiteColor]] duration:0.1];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
}

@end
