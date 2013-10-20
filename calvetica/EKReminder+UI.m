//
//  EKReminder+UI.m
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

#import "EKReminder+UI.h"

@implementation EKReminder (UI)

- (CVColoredShape)colorDotShapeForPriority
{
    // set the shape
    if (self.priority >= 1 && self.priority < 5) {
		return CVColoredShapeTriangle;
    }
    else if (self.priority == 5) {
        return CVColoredShapeCircle;
    }
    else if (self.priority > 5) {
        return CVColoredShapeRectangle;
    }

    return CVColoredShapeCircle;
}

@end
