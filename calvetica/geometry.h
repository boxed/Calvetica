//
//  geometry.h
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "math.h"

#define CVMAX(A, B) (((NSInteger)(A) > (NSInteger)(B)) ? A : B)
#define CVMIN(A, B) (((NSInteger)(A) < (NSInteger)(B)) ? A : B)

#define CVABS(A) (((A) < 0) ? -(A) : (A))

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

CGFloat CVPointDistance(CGPoint p1, CGPoint p2);
CGRect CVRectResize(CGRect rect, CGSize newSize);
CGRect CVRectInsetEdge(CGRect rect, CGRectEdge edge, CGFloat amount);
CGRect CVRectStackedWithinRectFromEdge(CGRect rect, CGSize size, int count, CGRectEdge edge, bool reverse);
CGPoint CVRectCenterPoint(CGRect rect);
CGPoint CVLineMidPoint(CGPoint p1, CGPoint p2);
void CVRectClosestTwoPoints(CGRect rect, CGPoint point, CGPoint *point1, CGPoint *point2);

void CVContextFillRoundedRect(CGContextRef context, CGRect rect, CGFloat radius);
void CVContextStrokeRoundedRect(CGContextRef context, CGRect rect, CGFloat radius);
//void CVContextFillRoundedRectSquaredTop(CGContextRef context, CGRect rect, CGFloat radius);
//void CVContextFillRoundedRectSquaredRight(CGContextRef context, CGRect rect, CGFloat radius);
//void CVContextFillRoundedRectSquaredBottom(CGContextRef context, CGRect rect, CGFloat radius);
//void CVContextFillRoundedRectSquaredLeft(CGContextRef context, CGRect rect, CGFloat radius);
