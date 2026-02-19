//
//  geometry.c
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#include "geometry.h"


CGFloat CVPointDistance(CGPoint p1, CGPoint p2) {
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    CGFloat dist = sqrtf(powf(dx, 2) + powf(dy, 2));
    return dist;
}

CGRect CVRectResize(CGRect rect, CGSize newSize) {
    CGRect newRect = rect;
    CGFloat dx = (rect.size.width - newSize.width) / 2.0;
    CGFloat dy = (rect.size.height - newSize.height) / 2.0;
    newRect.origin.x += dx;
    newRect.origin.y += dy;
    newRect.size.width = newSize.width;
    newRect.size.height = newSize.height;
    return newRect;
}

CGPoint CVRectCenterPoint(CGRect rect) {
    CGPoint centerPoint = CGPointZero;
    centerPoint.x = CGRectGetMidX(rect);
    centerPoint.y = CGRectGetMidY(rect);
    return centerPoint;
}

CGPoint CVLineMidPoint(CGPoint p1, CGPoint p2) {
    CGPoint midPoint = CGPointZero;
	midPoint.x = (p1.x + p2.x) / 2.0;
	midPoint.y = (p1.y + p2.y) / 2.0;
	return midPoint;
}

void CVRectClosestTwoPoints(CGRect rect, CGPoint point, CGPoint *point1, CGPoint *point2) {

	// gather the rects points
    CGPoint rectPoints[4];
    rectPoints[0] = CGPointMake(rect.origin.x, rect.origin.y);
    rectPoints[1] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    rectPoints[2] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    rectPoints[3] = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    
	
    // bubble sort them
    int changed = 1;
    while (changed) {
        changed = 0;
        for (int i = 0; i < 3; i++) {
            CGPoint p1 = rectPoints[i];
            CGPoint p2 = rectPoints[i+1];
            if (CVPointDistance(point, p1) > CVPointDistance(point, p2)) {
                rectPoints[i] = p2;
                rectPoints[i+1] = p1;
                changed = 1;
            }
        }
    }

	// assign them to the passed in pointers
    *point1 = rectPoints[0];
    *point2 = rectPoints[1];
}

void CVContextFillRoundedRect(CGContextRef context, CGRect rect, CGFloat radius) {
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;    
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

void CVContextStrokeRoundedRect(CGContextRef context, CGRect rect, CGFloat radius) {
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;    
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}