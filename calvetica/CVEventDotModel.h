//
//  CVEventDot.h
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVColoredDotView.h"

/*
 A cheap way to wrap events and store an offset value for rendering dots on the month view
 */
@interface CVEventDotModel : NSObject
@property (nonatomic, strong) EKEvent        *event;
@property (nonatomic, assign) NSUInteger     offset;
@property (nonatomic, assign) CVColoredShape shape;
@property (nonatomic, assign) CGRect         shapeRect;
@property (nonatomic, strong) UIColor        *dotColor;
@end
