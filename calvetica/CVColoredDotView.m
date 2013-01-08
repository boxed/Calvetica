//
//  CVColoredDotView.m
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"



@interface CVColoredDotView ()
@property CGRect drawRect;
@end


@implementation CVColoredDotView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shape = CVColoredShapeCircle;
        self.opaque = NO;
    }
    return self;
}

- (void)awakeFromNib 
{
    self.shape = CVColoredShapeCircle;
    self.opaque = NO;
    [super awakeFromNib];
}

- (void)setColor:(UIColor *)cl 
{
    _color = cl;
	[self setNeedsDisplay];
    
    if (_delegate && [_delegate respondsToSelector:@selector(coloredDot:didChangeColor:)]) {
        [_delegate coloredDot:self didChangeColor:_color];        
    }
}

- (void)setShape:(CVColoredShape)newShape 
{
    _shape = newShape;
    [self setNeedsDisplay];
}

- (void)drawCircle 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
	CGContextFillEllipseInRect(context, rect);
}

- (void)drawTriangle 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
	CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, maxX / 2.0, minY);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawRectangle 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    CGContextFillRect(context, rect);
}

- (void)drawRoundedRect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
	CGFloat radius = (rect.size.height / 2.0); 
	CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, radius, minY);
    CGContextAddLineToPoint(context, maxX - radius, minY);
    CGContextAddLineToPoint(context, maxX - radius, maxY);
    CGContextAddLineToPoint(context, radius, maxY);
    CGContextClosePath(context);
    CGContextFillPath(context);
	CGContextFillEllipseInRect(context, CGRectMake(minX, minY, radius * 2, radius * 2));
	CGContextFillEllipseInRect(context, CGRectMake(maxX - (radius * 2), minY, radius * 2, radius * 2));
}

- (void)drawCircleSquaredLeftEnd 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
	CGFloat radius = (rect.size.height / 2.0);
	CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, maxX - radius, minY);
    CGContextAddLineToPoint(context, maxX - radius, maxY);    
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextClosePath(context);
    CGContextFillPath(context);
	CGContextFillEllipseInRect(context, CGRectMake(maxX - (radius * 2), minY, radius * 2, radius * 2));    
}

- (void)drawCircleSquaredRightEnd 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
	CGFloat radius = (rect.size.height / 2.0);
	CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, maxX, minY);
    CGContextAddLineToPoint(context, minX + radius, minY);
    CGContextAddLineToPoint(context, minX + radius, maxY);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, maxX, minY);
    CGContextClosePath(context);
    CGContextFillPath(context);
	CGContextFillEllipseInRect(context, CGRectMake(minX, minY, radius * 2, radius * 2));
}

- (void)drawCircleSquaredBothEnds 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = _drawRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
	CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, maxX, minY);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, minX, minY);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect 
{
    _drawRect = rect;
    
	CGContextRef context = UIGraphicsGetCurrentContext();

//#if TARGET_IPHONE_SIMULATOR
//    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.263 green:0.320 blue:0.506 alpha:1] CGColor]);
//#else
    CGContextSetFillColorWithColor(context, [self.color CGColor]);
//#endif
    
	if (_shape == CVColoredShapeCircle) {
        [self drawCircle];
    } else if (_shape == CVColoredShapeTriangle) {
        [self drawTriangle];
    } else if (_shape == CVColoredShapeRectangle) {
        [self drawRectangle];
    } else if (_shape == CVColoredShapeRoundedRect) {
        [self drawRoundedRect];
    } else if (_shape == CVColoredShapeSquaredLeftEnd) {
        [self drawCircleSquaredLeftEnd];
    } else if (_shape == CVColoredShapeSquaredRightEnd) {
        [self drawCircleSquaredRightEnd];
    } else if (_shape == CVColoredShapeSquaredBothEnds) {
        [self drawCircleSquaredBothEnds];
    }
}


#pragma mark - Memory


@end
