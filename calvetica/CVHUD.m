//
//  CVBezel.m
//  calvetica
//
//  Created by James Schultz on 6/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVHUD.h"

// private extension
@interface CVHUD ()
- (void)setBezelPosition;
@end





@implementation CVHUD


- (void)awakeFromNib 
{
    [super awakeFromNib];
    
    [self.layer setCornerRadius:6.0f];
}

- (void)presentBezel 
{
    [self setBezelPosition];
    self.x = -self.width;
    // animate the fade out and remove from view
    // in the future add cases here for various animation options
    // add perhaps add some enums

    [UIView mt_animateWithDuration:0.5
                    timingFunction:kMTEaseOutBack
                           options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                        animations:^{
                            [self setBezelPosition];
                        } completion:^{
                            [UIView mt_animateWithDuration:0.75
                                            timingFunction:kMTEaseInExpo
                                                   options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                                                animations:^{
                                                    self.x = [UIScreen mainScreen].bounds.size.height;
                                                } completion:^{
                                                    [self removeFromSuperview];
                                                }];
                        }];
}

- (void)setBezelPosition 
{
    // get and set sizes
    UIView *view = [self superview];
    
    // set the number of lines of text
    self.titleLabel.numberOfLines = [self.titleLabel linesOfWordWrapTextInLabelWithConstraintWidth:self.titleLabel.bounds.size.width];
    
    //NSInteger indent;
    NSInteger X;
    NSInteger Y;
    NSInteger width = self.bounds.size.width;
    NSInteger height = self.bounds.size.height;
    
    // adjust the height of the bezel if there is more than 1 line of text
    if (self.titleLabel.numberOfLines > 1) {
        height = [self.titleLabel totalHeightOfWordWrapTextInLabelWithConstraintWidth:self.titleLabel.bounds.size.width] + height;
    }
    
    // center the bezel in the super view
    Y = (view.bounds.size.height / 2) - (height / 2);
    X = (view .bounds.size.width / 2) - (width / 2);
    
//    // adjust the postion of the bezel on the screen
//    if (view.bounds.size.width > 640) {
//        Y = (view.bounds.size.height / 2) - (height / 2);
//        indent = -324;
//    }
//    else {
//        Y = (view.bounds.size.height / 4) - (height / 2);
//        indent = 41;
//    }
//    
//    X = ((view.bounds.size.width + indent) / 2) - (self.bounds.size.width / 2);
    
    self.frame = CGRectMake(X, Y, width, height);
}

@end
