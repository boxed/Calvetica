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

- (instancetype)initWithFrame:(CGRect)frame 
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

- (void)drawCheck
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [self.color CGColor]);

    CGRect rect = CGRectInset(_drawRect, 1, 1);
//    rect.origin.x = 0;
//    rect.origin.y = 0;
	CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minX, minY + (rect.size.height * 0.6));
    CGContextAddLineToPoint(context, minX + (rect.size.width * 0.4), maxY);
    CGContextAddLineToPoint(context, minX + (rect.size.width * 0.8), minY);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect 
{
    _drawRect = rect;
    
	CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [self.color CGColor]);

	if (_shape == CVColoredShapeCircle) {
        [self drawCircle];
    }
    else if (_shape == CVColoredShapeTriangle) {
        [self drawTriangle];
    }
    else if (_shape == CVColoredShapeRectangle) {
        [self drawRectangle];
    }
    else if (_shape == CVColoredShapeCheck) {
        [self drawCheck];
    }
}




@end
