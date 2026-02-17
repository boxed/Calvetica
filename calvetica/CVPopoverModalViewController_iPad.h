//
//  CVPageModalViewController_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVPopoverBackdrop.h"
#import "UIViewController+Utilities.h"
#import "dimensions.h"
#import "animations.h"
#import "CVModalProtocol.h"
#import "geometry.h"

@interface CVPopoverModalViewController_iPad : CVViewController <UIGestureRecognizerDelegate> {
    CGFloat                 keyboardAppearedModalSavedYCoord;
    CVPopoverArrowDirection keyboardAppearedArrowSavedDirection;
}

@property (nonatomic, strong) CVViewController<CVModalProtocol> *contentViewController;
@property (nonatomic, strong) UIView                            *targetView;
@property (nonatomic, assign) BOOL                              ignoreKeyboard;

- (instancetype)initWithContentViewController:(CVViewController<CVModalProtocol> *)initContentViewController targetView:(UIView *)initTargetView;
- (CVPopoverArrowDirection)bestEnumMatch:(CVPopoverArrowDirection)direction inMask:(CVPopoverArrowDirection)directionMask;
- (void)layout;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide;

@end
