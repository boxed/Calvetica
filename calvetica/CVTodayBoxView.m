//
//  CVTodayBoxView.m
//  calvetica
//
//  Created by Adam Kirk on 5/23/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTodayBoxView.h"


@implementation CVTodayBoxView

- (void)setFrame:(CGRect)frame
{
	// @hack: for some reason, when the table view scrolls, it tries to reframe the red selected day square, so this just ignores it.
}

- (void)setSuperFrame:(CGRect)frame
{
	[super setFrame:frame];
}

- (void)drawRect:(CGRect)rect 
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    // set red color
    CGContextSetFillColorWithColor(context, [patentedRed CGColor]);

    // outer rect
    CGRect outerRect = CGRectInset(rect, TODAY_BOX_OUTER_OFFSET, TODAY_BOX_OUTER_OFFSET);
    
    // draw outer rect clockwise
    CGContextMoveToPoint(context, outerRect.origin.x, outerRect.origin.y);
    CGContextAddLineToPoint(context, outerRect.origin.x + outerRect.size.width, outerRect.origin.y);
    CGContextAddLineToPoint(context, outerRect.origin.x + outerRect.size.width, outerRect.origin.y + outerRect.size.height);
    CGContextAddLineToPoint(context, outerRect.origin.x, outerRect.origin.y + outerRect.size.height);
    CGContextAddLineToPoint(context, outerRect.origin.x, outerRect.origin.y);
    CGContextClosePath(context);
    
    // inner rect we're going to cut out
    CGRect innerRect = CGRectInset(rect, TODAY_BOX_INNER_OFFSET, TODAY_BOX_INNER_OFFSET);
    
    // draw inner rect counterclockwise
    CGContextMoveToPoint(context, innerRect.origin.x, innerRect.origin.y);
    CGContextAddLineToPoint(context, innerRect.origin.x, innerRect.origin.y + innerRect.size.height);
    CGContextAddLineToPoint(context, innerRect.origin.x + innerRect.size.width, innerRect.origin.y + innerRect.size.height);
    CGContextAddLineToPoint(context, innerRect.origin.x + innerRect.size.width, innerRect.origin.y);
    CGContextAddLineToPoint(context, innerRect.origin.x, innerRect.origin.y);
    CGContextClosePath(context);

    // @improve: not sure if this is possible but it'd be nice if we could apply this gradient.  The problem
    // is that is seems you can't hollow out a gradient.  (notice the clockwise-counterclockwise way in which
    // the squares are drawn above, that is what cases the hollowing out.
    
    /*
    // generate gradient array
	UIColor* startColor = patentedTodayBoxRedBottomLeft;
	UIColor* endColor = patentedTodayBoxRedTopRight;
    CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, 2, NULL);
	CFArrayAppendValue(colorArray, [startColor CGColor]);
	CFArrayAppendValue(colorArray, [endColor CGColor]);

	// Create gradient object to draw gradient rect
    // NOTE: Passing NULL for the color space gives causes the gradient to use an RGB color space
    // NOTE: Passing NULL for the locations array causes a default location array of { 0.0f, 1.0f } to be used
	CGPoint startPoint = CGPointMake(0, rect.size.height);
	CGPoint endPoint = CGPointMake(rect.size.width, 0);
	CGGradientRef gradient = CGGradientCreateWithColors(NULL, colorArray, NULL);

	// draw gradient
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

	// cleanup gradient
	CGGradientRelease(gradient);
	CFRelease(colorArray);
    */

    CGContextFillPath(context);
}


@end
