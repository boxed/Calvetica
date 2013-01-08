//
//  CVColoredDotView.h
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

typedef enum {
    CVColoredShapeCircle,
    CVColoredShapeTriangle,
    CVColoredShapeRectangle,
    CVColoredShapeRoundedRect,
    CVColoredShapeSquaredLeftEnd,
    CVColoredShapeSquaredRightEnd,
    CVColoredShapeSquaredBothEnds
} CVColoredShape;



@protocol CVColoredDotViewDelegate;



@interface CVColoredDotView : UIView

@property (nonatomic, unsafe_unretained) id<CVColoredDotViewDelegate> delegate;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CVColoredShape shape;

- (void)drawCircle;
- (void)drawTriangle;
- (void)drawRectangle;
- (void)drawRoundedRect;
- (void)drawCircleSquaredLeftEnd;
- (void)drawCircleSquaredRightEnd;
- (void)drawCircleSquaredBothEnds;

@end




@protocol CVColoredDotViewDelegate <NSObject>
@optional
- (void)coloredDot:(CVColoredDotView *)coloredDot didChangeColor:(UIColor *)color;
@end