//
//  CVColoredDotView.h
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CVColoredShape) {
    CVColoredShapeCircle,
    CVColoredShapeTriangle,
    CVColoredShapeRectangle,
    CVColoredShapeCheck
};



NS_ASSUME_NONNULL_BEGIN

@protocol CVColoredDotViewDelegate;


@interface CVColoredDotView : UIView
@property (nonatomic, strong) UIColor        *color;
@property (nonatomic, assign) CVColoredShape shape;
@end

NS_ASSUME_NONNULL_END