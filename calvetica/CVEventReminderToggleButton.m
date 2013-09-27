//
//  CVCheckmarkButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVEventReminderToggleButton.h"


@implementation CVEventReminderToggleButton

- (void)setupPencil
{
    CGRect rect;
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    [[[_pencil move] delay:0.5] color:[UIColor whiteColor]];

    if (_icon == CVEventReminderToggleButtonIconCheck) {
        [[_pencil move] duration:0.15];
        [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
        [[_pencil draw] to:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
        [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    }
    else if (_icon == CVEventReminderToggleButtonIconCalendar) {
        [[_pencil move] duration:0.4];
        CGFloat y           = CGRectGetHeight(rect) * (1/3.0);
        UIBezierPath *path  = [UIBezierPath bezierPathWithRect:rect];
        [[_pencil draw] path:path.CGPath];
        [[_pencil move] to:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + y)];
        [[_pencil draw] to:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + y)];
    }
}

- (void)setIcon:(CVEventReminderToggleButtonIcon)icon
{
    _icon = icon;
    [_pencil reset];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
