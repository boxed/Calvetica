//
//  CVCheckmarkButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/21/13.
//
//

#import "CVEventReminderToggleButton.h"

@implementation CVEventReminderToggleButton

- (void)setIcon:(CVEventReminderToggleButtonIcon)icon
{
    _icon = icon;
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    rect.size.width     = 17;
    rect.size.height    = 17;
    rect.origin.x       = (self.width / 2) - (rect.size.width / 2);
    rect.origin.y       = (self.height / 2) - (rect.size.height / 2);

    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_icon == CVEventReminderToggleButtonIconCheck) {
        [path moveToPoint:CGPointMake(      CGRectGetMinX(rect), CGRectGetMidY(rect))];
        [path addLineToPoint:CGPointMake(   CGRectGetMidX(rect), CGRectGetMaxY(rect))];
        [path addLineToPoint:CGPointMake(   CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    }
    else if (_icon == CVEventReminderToggleButtonIconCalendar) {
        path = [UIBezierPath bezierPathWithRect:rect];
        CGFloat y = CGRectGetHeight(rect) * (1/3.0);
        [path moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + y)];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + y)];
    }
    [[self titleColorForState:self.state] set];
    [path stroke];
}

@end
