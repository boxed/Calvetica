//
//  CVClearButton.m
//  calvetica
//
//  Created by Adam Kirk on 10/2/13.
//
//

#import "CVClearButton.h"

@implementation CVClearButton

- (void)setupPencil
{
    [super setupPencil];
    
    CGRect rect;
    rect.size.width     = 15;
    rect.size.height    = 15;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[_pencil config] duration: 0.1];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
    [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect))];
}

@end
