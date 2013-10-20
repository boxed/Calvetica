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
    CVColoredShapeCheck
} CVColoredShape;


@protocol CVColoredDotViewDelegate;


@interface CVColoredDotView : UIView
@property (nonatomic, strong) UIColor        *color;
@property (nonatomic, assign) CVColoredShape shape;
@end
