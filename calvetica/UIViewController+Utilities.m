//
//  UIViewController+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 6/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIViewController+Utilities.h"


@implementation UIViewController (UIViewController_Utilities)

- (CGRect)fullScreenRectBasedOnOrientation 
{
    UIInterfaceOrientation o = self.interfaceOrientation;
    CGRect r = [[UIScreen mainScreen] bounds];
    if (o == UIInterfaceOrientationPortrait || o == UIInterfaceOrientationPortraitUpsideDown) {
        return r;
    } else {
        CGFloat temp = r.size.width;
        r.size.width = r.size.height;
        r.size.height = temp;
        return r;
    }
}

- (BOOL)isLandscape 
{
    UIInterfaceOrientation o = self.interfaceOrientation;
    return (o == UIInterfaceOrientationLandscapeLeft || o == UIInterfaceOrientationLandscapeRight);
}

@end
