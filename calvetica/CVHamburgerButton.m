//
//  CVHamburgerButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVHamburgerButton.h"

@implementation CVHamburgerButton

- (void)setupPencil
{
    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 14;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[_pencil move] delay:0.5] color:[UIColor whiteColor]];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect))];
}

@end
