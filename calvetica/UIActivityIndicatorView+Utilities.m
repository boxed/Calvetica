//
//  UIActivityIndicator+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIActivityIndicatorView+Utilities.h"
#import <objc/runtime.h>


@implementation UIActivityIndicatorView (Utilities)

static char selectedKey;

- (void)incrementAnimationCount 
{
    NSNumber *number = objc_getAssociatedObject(self, &selectedKey);
    NSInteger count = number != nil ? [number intValue] : 0;
    count++;
    objc_setAssociatedObject(self, &selectedKey, @(count), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self startAnimating];
}

- (void)decrementAnimationCount 
{
    NSNumber *number = objc_getAssociatedObject(self, &selectedKey);
    NSInteger count = number != nil && number > 0 ? [number intValue] : 1;
    count--;
    objc_setAssociatedObject(self, &selectedKey, @(count), OBJC_ASSOCIATION_RETAIN_NONATOMIC);    
    
    if (count == 0) {
        [self stopAnimating];
    }
}

@end
