//
//  CVViewController.m
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVPageModalViewController_iPhone.h"
#import "CVPopoverModalViewController_iPad.h"
#import "UIViewController+Utilities.h"
#import "CVAlertViewController.h"
#import "animations.h"

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




#pragma mark - Page Modal

- (void)presentPageModalViewController:(CVViewController *)modalViewController animated:(BOOL)animated 
{
    
    CVPageModalViewController_iPhone *wrapper = [[CVPageModalViewController_iPhone alloc] initWithContentViewController:modalViewController];
    [self.pageModalViewControllers addObject:wrapper];
    wrapper.containingViewController = self;
    
    if (animated) {
        
        wrapper.view.alpha = 0;
		[wrapper.view setFrame:self.view.bounds];
        [self.view addSubview:wrapper.view];
        //[modalViewController viewWillAppear:YES];
        
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{ wrapper.view.alpha = 1.0; }
                         completion:^(BOOL finished) { 
                             //[modalViewController viewDidAppear:YES]; 
                         }];
        
    } else {
        [self.view addSubview:wrapper.view];
        //[modalViewController viewWillAppear:YES];
        //[modalViewController viewDidAppear:YES];
    }
    
}

- (void)dismissPageModalViewControllerAnimated:(BOOL)animated 
{
    
    // pop the most recently added view controller (view controllers are dismissed in LIFO order)
    CVPageModalViewController_iPhone *wrapperToDismiss = [self.pageModalViewControllers lastObject];
    CVViewController *viewControllerToDismiss = wrapperToDismiss.contentViewController;
    if (!viewControllerToDismiss) {
        return;
    }
    
    UIView *wrapper = wrapperToDismiss.view;
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_SPEED
                         animations:^{wrapper.alpha = 0.0;}
                         completion:^(BOOL finished){
                             //[viewControllerToDismiss viewDidDisappear:YES];
                             [wrapper removeFromSuperview]; 
                         }];
    } else {
        [wrapper removeFromSuperview]; 
        //[viewControllerToDismiss viewDidDisappear:YES];
    }
    
    [self.pageModalViewControllers removeObject:wrapperToDismiss];
}




#pragma mark - Full Screen Modal

- (void)presentFullScreenModalViewController:(CVViewController *)modalViewController animated:(BOOL)animated 
{
    [self.fullScreenModalViewControllers addObject:modalViewController];
    modalViewController.containingViewController = self;
    
	CGRect rect = [self.view bounds];
    [modalViewController.view setFrame:rect];
    
	if (animated) {
        
        
        modalViewController.view.alpha = 0;
        
        
        [self.view addSubview:modalViewController.view];
        //[modalViewController viewWillAppear:YES];
        
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{ 
            
            modalViewController.view.alpha = 1.0;
            
        }
                         completion:^(BOOL finished) { 
                             //[modalViewController viewDidAppear:YES]; 
                         }];
        
    } else {
        [self.view addSubview:modalViewController.view];
        //[modalViewController viewWillAppear:YES];
        //[modalViewController viewDidAppear:YES];
    }
}

- (void)dismissFullScreenModalViewControllerAnimated:(BOOL)animated 
{
    
    // pop the most recently added view controller (view controllers are dismissed in LIFO order)
    CVViewController *viewControllerToDismiss = [self.fullScreenModalViewControllers lastObject];
    if (!viewControllerToDismiss) {
        return;
    }
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_SPEED
                         animations:^{viewControllerToDismiss.view.alpha = 0.0;}
                         completion:^(BOOL finished){
                             //[viewControllerToDismiss viewDidDisappear:YES];
                             [viewControllerToDismiss.view removeFromSuperview]; 
                         }];
    } else {
        [viewControllerToDismiss.view removeFromSuperview]; 
        //[viewControllerToDismiss viewDidDisappear:YES];
    }
    
    [self.fullScreenModalViewControllers removeObject:viewControllerToDismiss];
}




#pragma mark - Popover Modal

- (void)presentPopoverModalViewController:(CVViewController<CVModalProtocol> *)modalViewController forView:(UIView *)view animated:(BOOL)animated 
{
    
	modalViewController.popoverTargetView = view;
	
    CVPopoverModalViewController_iPad *popover = [[CVPopoverModalViewController_iPad alloc] initWithContentViewController:modalViewController targetView:view];
    popover.containingViewController = self;
    
    [self.popoverModalViewControllers addObject:popover];
    
    if (animated) {
        
        popover.view.alpha = 0;
        [self.view addSubview:popover.view];
        //[modalViewController viewWillAppear:YES];
        
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{ popover.view.alpha = 1.0; }
                         completion:^(BOOL finished){ 
                             //[modalViewController viewDidAppear:YES]; 
                         }];
        
        
    } else {
        [self.view addSubview:popover.view];
        //[modalViewController viewWillAppear:YES];
        //[modalViewController viewDidAppear:NO];
    }
    
}

- (void)dismissPopoverModalViewControllerAnimated:(BOOL)animated 
{
    
    // pop the most recently added view controller (view controllers are dismissed in LIFO order)
    CVPopoverModalViewController_iPad *popoverToDismiss = [self.popoverModalViewControllers lastObject];
    CVViewController *viewControllerToDismiss = popoverToDismiss.contentViewController;
    
    if (!viewControllerToDismiss) {
        return;
    }
    
    UIView *wrapper = viewControllerToDismiss.view.superview.superview;
    
    if (animated) {
        [UIView animateWithDuration:ANIMATION_SPEED
                         animations:^{wrapper.alpha = 0.0;}
                         completion:^(BOOL finished){
                             [wrapper removeFromSuperview]; 
                             //[viewControllerToDismiss viewDidDisappear:YES];
                         }];
    } else {
        [wrapper removeFromSuperview]; 
        //[viewControllerToDismiss viewDidDisappear:YES];
    }
    
    [self.popoverModalViewControllers removeObject:popoverToDismiss];
}




#pragma mark - View lifecycle

- (void)viewDidUnload 
{
    [self setKeyboardAccessoryView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Keyboard Accessory Actions

- (UIView *)keyboardAccessoryView 
{
    if (!_keyboardAccessoryView) {
        UINib *inputAccessoryViewNib = [UINib nibWithNibName:@"CVInputAccessory_iPhone" bundle:nil];        
        [inputAccessoryViewNib instantiateWithOwner:self options:nil];
    }
    return _keyboardAccessoryView;
}

- (IBAction)accessoryViewCloseButtonTapped:(id)sender 
{
    [self hideKeyboard];
}




@end
