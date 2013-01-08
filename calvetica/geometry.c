//
//  geometry.c
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#include "geometry.h"
#include "colors.h"


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

CGRect CVRectInsetEdge(CGRect rect, CGRectEdge edge, CGFloat amount) {
    CGRect slice = CGRectZero;
    CGRect remainder = CGRectZero;
    CGRectDivide(rect, &slice, &remainder, amount, edge);
    return remainder;
}

CGRect CVRectStackedWithinRectFromEdge(CGRect rect, CGSize size, int count, CGRectEdge edge, bool reverse) {

    
    int max_columns = floor(rect.size.width / size.width);
    int max_rows = floor(rect.size.height / size.height);
    
    if (edge == CGRectMinYEdge) {
        int current_row = floor(count / max_columns);
        int current_col = count % max_columns;
        if (reverse) current_col = max_columns - current_col;
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMinX(rect) + (current_col * size.width);
            CGFloat y = CGRectGetMinY(rect) + (current_row * size.height);
            return CGRectMake(x, y, size.width, size.height);
        }
    }
    
    else if (edge == CGRectMaxYEdge) {
        int current_row = floor(count / max_columns);
        int current_col = count % max_columns;
        if (reverse) current_col = max_columns - current_col;
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMinX(rect) + (current_col * size.width);
            CGFloat y = CGRectGetMaxY(rect) - size.height - (current_row * size.height);
            return CGRectMake(x, y, size.width, size.height);
        }
    }
    
    else if (edge == CGRectMinXEdge) {
        int current_col = floor(count / max_columns);
        int current_row = count % max_columns;
        if (reverse) current_col = max_columns - current_col;
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMinX(rect) + (current_col * size.width);
            CGFloat y = CGRectGetMinY(rect) + (current_row * size.height);
            return CGRectMake(x, y, size.width, size.height);
        }
    }
    
    else if (edge == CGRectMaxXEdge) {
        int current_col = floor(count / max_columns);
        int current_row = count % max_columns;
        if (reverse) current_col = max_columns - current_col;
        if (current_col > max_columns || current_row > max_rows) {
            return CGRectNull;
        }
        else {
            CGFloat x = CGRectGetMaxX(rect) - size.width - (current_col * size.width);
            CGFloat y = CGRectGetMinY(rect) + current_row * size.height;
            return CGRectMake(x, y, size.width, size.height);
        }
    }
    
    return CGRectNull;
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



//void CVContextFillRoundedRectSquaredTop(CGContextRef context, CGRect rect, CGFloat radius) {
//    
//}
//
//void CVContextFillRoundedRectSquaredRight(CGContextRef context, CGRect rect, CGFloat radius) {
//    rect.origin.x = 0;
//    rect.origin.y = 0;
//	CGFloat minX = CGRectGetMinX(rect);
//    CGFloat maxX = CGRectGetMaxX(rect);
//    CGFloat minY = CGRectGetMinY(rect);
//    CGFloat maxY = CGRectGetMaxY(rect);
//    CGContextMoveToPoint(context, maxX, minY);
//    CGContextAddLineToPoint(context, minX + radius, minY);
//    CGContextAddLineToPoint(context, minX + radius, maxY);
//    CGContextAddLineToPoint(context, maxX, maxY);
//    CGContextAddLineToPoint(context, maxX, minY);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//	CGContextFillEllipseInRect(context, CGRectMake(minX, minY, radius * 2, radius * 2));
//}
//
//void CVContextFillRoundedRectSquaredBottom(CGContextRef context, CGRect rect, CGFloat radius) {
//    
//}
//
//void CVContextFillRoundedRectSquaredLeft(CGContextRef context, CGRect rect, CGFloat radius) {
//    rect.origin.x = 0;
//    rect.origin.y = 0;
//	CGFloat minX = CGRectGetMinX(rect);
//    CGFloat maxX = CGRectGetMaxX(rect);
//    CGFloat minY = CGRectGetMinY(rect);
//    CGFloat maxY = CGRectGetMaxY(rect);
//    CGContextMoveToPoint(context, minX, minY);
//    CGContextAddLineToPoint(context, maxX - radius, minY);
//    CGContextAddLineToPoint(context, maxX - radius, maxY);    
//    CGContextAddLineToPoint(context, minX, maxY);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//	CGContextFillEllipseInRect(context, CGRectMake(maxX - (radius * 2), minY, radius * 2, radius * 2)); 
//}
