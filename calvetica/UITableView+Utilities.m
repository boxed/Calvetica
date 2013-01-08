//
//  UITableView+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableView+Utilities.h"


@implementation UITableView (UITableView_Utilities)

- (NSIndexPath *)indexPathForRowContainingView:(UIView *)view 
{
    CGPoint correctedPoint = [view convertPoint:view.bounds.origin toView:self];
    return [self indexPathForRowAtPoint:correctedPoint];
}

@end
