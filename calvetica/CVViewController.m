//
//  CVViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVPageModalViewController.h"
#import "CVPopoverModalViewController_iPad.h"
#import "UIViewController+Utilities.h"
#import "animations.h"


@interface CVViewController ()
@property (nonatomic, assign) BOOL hasAppearedBefore;
@end


@implementation CVViewController


- (id)init 
{
    self = [super init];
    if (self) {
        self.popoverArrowDirection = CVPopoverArrowDirectionAny;
		self.contentModified = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.hasAppearedBefore) {
        [self viewDidAppearAfterLoad:animated];
        self.hasAppearedBefore = YES;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Public

- (void)viewDidAppearAfterLoad:(BOOL)animated
{

}

#pragma mark (properties)

- (NSMutableArray *)pageModalViewControllers 
{
    if (!_pageModalViewControllers) {
        self.pageModalViewControllers = [NSMutableArray array];
    }
    return _pageModalViewControllers;
}

- (NSMutableArray *)fullScreenModalViewControllers 
{
    if (!_fullScreenModalViewControllers) {
        self.fullScreenModalViewControllers = [NSMutableArray array];
    }
    return _fullScreenModalViewControllers;
}

- (NSMutableArray *)popoverModalViewControllers 
{
    if (!_popoverModalViewControllers) {
        self.popoverModalViewControllers = [NSMutableArray array];
    }
    return _popoverModalViewControllers;
}




- (void)hideKeyboard 
{
}

- (CVViewController *)closestSystemPresentedViewController 
{
    if (self.parentViewController) {
        return self;
    }
    else if ([UIApplication sharedApplication].keyWindow.rootViewController == self) {
        return self;
    }
    else if (self.containingViewController) {
        return [self.containingViewController closestSystemPresentedViewController];
    }
    return (CVViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}




#pragma mark (Page Modal)

- (void)presentPageModalViewController:(CVViewController *)modalViewController
                              animated:(BOOL)animated
                            completion:(void (^)(void))completion
{
    CVPageModalViewController *containerViewController =
    [[CVPageModalViewController alloc] initWithContentViewController:modalViewController];

    [self.pageModalViewControllers addObject:containerViewController];
    containerViewController.containingViewController = self;
    [containerViewController view];
    
    if (animated) {

        UIView *containerView   = containerViewController.view;
        containerView.frame     = self.view.bounds;
        containerView.alpha     = 0;
        [self.view addSubview:containerViewController.view];

        UIView *modalView   = modalViewController.view;
        CGRect orignalRect  = modalView.frame;
        modalView.x         = -modalView.width;
        modalView.hidden    = YES;

        [UIView animateWithDuration:0.2
                         animations:^
        {
            containerView.alpha = 1;
        } completion:^(BOOL finished) {
            modalView.hidden = NO;
            [UIView mt_animateWithDuration:0.2
                            timingFunction:kMTEaseOutExpo
                                   options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                                animations:^
             {
                 modalView.frame = orignalRect;
             } completion:^{
                 if (completion) completion();
             }];
        }];

    } else {
        if (completion) completion();
        [self.view addSubview:containerViewController.view];
    }
    
}

- (void)dismissPageModalViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    // pop the most recently added view controller (view controllers are dismissed in LIFO order)
    CVPageModalViewController *containerViewController = [self.pageModalViewControllers lastObject];
    CVViewController *modalViewController = containerViewController.contentViewController;
    if (!modalViewController) {
        return;
    }

    UIView *containerView   = containerViewController.view;
    UIView *modalView       = modalViewController.view;

    if (animated) {
        [UIView mt_animateWithDuration:0.2
                        timingFunction:kMTEaseInExpo
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^
         {
             modalView.x = self.view.bounds.size.width;
         } completion:^{
             [UIView animateWithDuration:0.2
                              animations:^
              {
                  containerView.alpha = 0;
              } completion:^(BOOL finished) {
                  [containerView removeFromSuperview];
                  if (completion) completion();
              }];
         }];

    } else {
        [containerView removeFromSuperview];
        if (completion) completion();
    }
    
    [self.pageModalViewControllers removeObject:containerViewController];
}




#pragma mark (Full Screen Modal)

- (void)presentFullScreenModalViewController:(CVViewController *)fullScreenViewController animated:(BOOL)animated 
{
    [self.fullScreenModalViewControllers addObject:fullScreenViewController];
    fullScreenViewController.containingViewController = self;

    UIView *view   = fullScreenViewController.view;
    view.frame     = self.view.bounds;

	if (animated) {

        view.x = -view.width;
        [self.view addSubview:fullScreenViewController.view];

        [UIView mt_animateWithDuration:0.2
                        timingFunction:kMTEaseOutExpo
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^{
                                view.frame = self.view.bounds;
                            } completion:^{
                                view.frame = self.view.bounds;
                            }];
    } else {
        [self.view addSubview:fullScreenViewController.view];
    }
}

- (void)dismissFullScreenModalViewControllerAnimated:(BOOL)animated 
{
    // pop the most recently added view controller (view controllers are dismissed in LIFO order)
    CVViewController *fullScreenViewController = [self.fullScreenModalViewControllers lastObject];

    if (!fullScreenViewController) {
        return;
    }

    UIView *view = fullScreenViewController.view;
    
    if (animated) {
        [UIView mt_animateWithDuration:0.2
                        timingFunction:kMTEaseInExpo
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^{
                                view.x = view.width;
                            } completion:^{
                                [view removeFromSuperview];
                                [self.fullScreenModalViewControllers removeObject:fullScreenViewController];
                            }];
    } else {
        [fullScreenViewController.view removeFromSuperview]; 
        [self.fullScreenModalViewControllers removeObject:fullScreenViewController];
    }
}


#pragma mark (Popover Modal)

- (void)presentPopoverModalViewController:(CVViewController<CVModalProtocol> *)modalViewController forView:(UIView *)view animated:(BOOL)animated 
{
	modalViewController.popoverTargetView = view;
    CVPopoverModalViewController_iPad *popover = [[CVPopoverModalViewController_iPad alloc]
                                                  initWithContentViewController:modalViewController
                                                  targetView:view];
    popover.containingViewController = self;
    [self.popoverModalViewControllers addObject:popover];
    [self.view addSubview:popover.view];

    if (animated) {

        UIView *v = modalViewController.view.superview;
        v.mt_animationPerspective = -1 / 1600.0;
        v.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);

        [UIView mt_animateWithDuration:0.2
                        timingFunction:kMTEaseOutBack
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^
         {
             v.layer.transform = CATransform3DIdentity;
         } completion:^{
             v.layer.transform = CATransform3DIdentity;
         }];
    }
}

- (void)dismissPopoverModalViewControllerAnimated:(BOOL)animated 
{
    // pop the most recently added view controller (view controllers are dismissed in LIFO order)
    CVPopoverModalViewController_iPad *popoverToDismiss = [self.popoverModalViewControllers lastObject];
    CVViewController *viewControllerToDismiss           = popoverToDismiss.contentViewController;

    if (!viewControllerToDismiss) {
        return;
    }
    
    UIView *wrapper = viewControllerToDismiss.view.superview.superview;

    if (animated) {
        popoverToDismiss.ignoreKeyboard = YES;

        UIView *v = viewControllerToDismiss.view.superview;
        v.mt_animationPerspective = -1 / 1600.0;
        v.layer.transform = CATransform3DIdentity;

        [UIView mt_animateWithDuration:0.4
                        timingFunction:kMTEaseInBack
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^
         {
             v.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
         } completion:^{
             v.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
             [wrapper removeFromSuperview];
             [self.popoverModalViewControllers removeObject:popoverToDismiss];
             popoverToDismiss.ignoreKeyboard = NO;
         }];

    } else {
        [wrapper removeFromSuperview];
        [self.popoverModalViewControllers removeObject:popoverToDismiss];
    }
}






#pragma mark - Keyboard Accessory Actions

- (UIView *)keyboardAccessoryView 
{
    if (!_keyboardAccessoryView) {
        UINib *inputAccessoryViewNib = [UINib nibWithNibName:@"CVInputAccessory" bundle:nil];        
        [inputAccessoryViewNib instantiateWithOwner:self options:nil];
    }
    return _keyboardAccessoryView;
}

- (IBAction)accessoryViewCloseButtonTapped:(id)sender 
{
    [self hideKeyboard];
}


@end
