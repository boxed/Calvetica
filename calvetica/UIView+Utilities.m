//
//  UIView+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIView+Utilities.h"


@implementation UIView (UIView_Utilities)

- (void)bounce 
{
    self.y -= 10;
    [UIView mt_animateWithDuration:0.3
                    timingFunction:kMTEaseOutElastic
                           options:UIViewAnimationOptionBeginFromCurrentState
                        animations:^
     {
         self.y += 10;
     } completion:^{
     }];
}

@end
