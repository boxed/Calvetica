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


#pragma mark - Public

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

    CGContextFillPath(context);
}


@end
