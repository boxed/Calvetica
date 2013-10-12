//
//  CVCloseButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVCloseButton.h"


@implementation CVCloseButton

- (void)setupPencil
{
    CGRect rect;
    rect.size.width     = 15;
    rect.size.height    = 15;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[[_pencil move] delay:0.5] color:[UIColor whiteColor]] duration:0.1];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
}

@end
