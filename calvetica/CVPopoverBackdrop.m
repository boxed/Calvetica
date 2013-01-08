//
//  CVPopoverBackdrop.m
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPopoverBackdrop.h"


@implementation CVPopoverBackdrop

- (void)setArrowDirection:(CVPopoverArrowDirection)newArrowDirection 
{
	_arrowDirection = newArrowDirection;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
    
    CGFloat offset = POPOVER_ARROW_HEIGHT + POPOVER_SHADOW_PADDING;
    CGRect innerRect = CGRectInset(rect, offset, offset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set red color
	if (self.backdropColor) {
		CGContextSetFillColorWithColor(context, [self.backdropColor CGColor]);
	}
	else {
		CGContextSetFillColorWithColor(context, [patentedBlack CGColor]);		
	}
    
    // set the shadow
	CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 3, [patentedBlackLightShadow CGColor]);
    
    CGPoint currentPoint = CGPointMake(innerRect.origin.x, innerRect.origin.y);
    
    // draw inner rect counterclockwise
    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
    
    // top left
    if (_arrowDirection == CVPopoverArrowDirectionTopLeft) {
        currentPoint.x += POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y -= POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x += POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y += POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.x = innerRect.origin.x + (innerRect.size.width - POPOVER_ARROW_WIDTH) / 2.0;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // top middle
    if (_arrowDirection == CVPopoverArrowDirectionTopMiddle) {
        currentPoint.x += POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y -= POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x += POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y += POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.x = innerRect.origin.x + innerRect.size.width - POPOVER_ARROW_WIDTH;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // top right
    if (_arrowDirection == CVPopoverArrowDirectionTopRight) {
        currentPoint.x += POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y -= POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x += POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y += POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.x = innerRect.origin.x + innerRect.size.width;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // right top
    if (_arrowDirection == CVPopoverArrowDirectionRightTop) {
        currentPoint.x += POPOVER_ARROW_HEIGHT;
        currentPoint.y += POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x -= POPOVER_ARROW_HEIGHT;
        currentPoint.y += POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.y = innerRect.origin.y + (innerRect.size.height - POPOVER_ARROW_WIDTH) / 2.0;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // right middle
    if (_arrowDirection == CVPopoverArrowDirectionRightMiddle) {
        currentPoint.x += POPOVER_ARROW_HEIGHT;
        currentPoint.y += POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x -= POPOVER_ARROW_HEIGHT;
        currentPoint.y += POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.y = innerRect.origin.y + innerRect.size.height - POPOVER_ARROW_WIDTH;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // right bottom
    if (_arrowDirection == CVPopoverArrowDirectionRightBottom) {
        currentPoint.x += POPOVER_ARROW_HEIGHT;
        currentPoint.y += POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x -= POPOVER_ARROW_HEIGHT;
        currentPoint.y += POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.y = innerRect.origin.y + innerRect.size.height;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // bottom right
    if (_arrowDirection == CVPopoverArrowDirectionBottomRight) {
        currentPoint.x -= POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y += POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x -= POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y -= POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.x = innerRect.origin.x + ((innerRect.size.width - POPOVER_ARROW_WIDTH) / 2.0) + POPOVER_ARROW_WIDTH;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // bottom middle
    if (_arrowDirection == CVPopoverArrowDirectionBottomMiddle) {
        currentPoint.x -= POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y += POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x -= POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y -= POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.x = innerRect.origin.x + POPOVER_ARROW_WIDTH;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // bottom left
    if (_arrowDirection == CVPopoverArrowDirectionBottomLeft) {
        currentPoint.x -= POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y += POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x -= POPOVER_HALF_ARROW_WIDTH;
        currentPoint.y -= POPOVER_ARROW_HEIGHT;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.x = innerRect.origin.x;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // left bottom
    if (_arrowDirection == CVPopoverArrowDirectionLeftBottom) {
        currentPoint.x -= POPOVER_ARROW_HEIGHT;
        currentPoint.y -= POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x += POPOVER_ARROW_HEIGHT;
        currentPoint.y -= POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.y = innerRect.origin.y + ((innerRect.size.height - POPOVER_ARROW_WIDTH) / 2.0) + POPOVER_ARROW_WIDTH;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    // left middle
    if (_arrowDirection == CVPopoverArrowDirectionLeftMiddle) {
        currentPoint.x -= POPOVER_ARROW_HEIGHT;
        currentPoint.y -= POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x += POPOVER_ARROW_HEIGHT;
        currentPoint.y -= POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.y = innerRect.origin.y + POPOVER_ARROW_WIDTH;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y); 
    
    // left top
    if (_arrowDirection == CVPopoverArrowDirectionLeftTop) {
        currentPoint.x -= POPOVER_ARROW_HEIGHT;
        currentPoint.y -= POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        currentPoint.x += POPOVER_ARROW_HEIGHT;
        currentPoint.y -= POPOVER_HALF_ARROW_WIDTH;
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    
    currentPoint.y = innerRect.origin.y;
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y); 

	
    CGContextClosePath(context);    
    CGContextFillPath(context);
    
}

@end
