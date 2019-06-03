//
//  CVNavigationController.m
//  calvetica
//
//  Created by Adam Kirk on 5/5/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVNavigationController.h"


@implementation CVNavigationController

- (CVViewController *)popViewControllerAnimated:(BOOL)animated 
{
    // if this is the last view controller, return nil, can't pop it
    if (_topViewController == _visibleViewController) {
        return nil;
    }
    
    // grab the last view controller
    CVViewController *lastViewController = [_viewControllers lastObject];
    
    // ensmallen the scroll view content size
    CGRect cr = _contentViewContainer.frame;
    cr.size.width -= lastViewController.view.frame.size.width;
    [_contentViewContainer setFrame:cr];
    
    // remove from scroll view
    //[lastViewController viewWillDisappear:YES];
    [lastViewController.view removeFromSuperview];
    //[lastViewController viewDidDisappear:YES];
    
    // remove the last view controller from the stack
    NSMutableArray *newViewControllerArray = [NSMutableArray arrayWithArray:_viewControllers];
    [newViewControllerArray removeObject:lastViewController];
    lastViewController.containingViewController = nil;
    _viewControllers = [[NSArray alloc] initWithArray:newViewControllerArray];
    
    // update some crap
    _visibleViewController = [_viewControllers lastObject];
    
    // scroll animate that sucker back sucker
    [UIView animateWithDuration:0.2 animations:^{
        CGRect r = self->_contentViewContainer.frame;
        r.origin.x += lastViewController.view.frame.size.width;
        [self->_contentViewContainer setFrame:r];
    } completion:^(BOOL finished){
        //[visibleViewController viewDidAppear:YES];
    }];

    return lastViewController;
}

- (void)pushViewController:(CVViewController *)viewController animated:(BOOL)animated 
{
    
    // add the view controller to the view controllers array
    NSMutableArray *newViewControllerArray = [NSMutableArray arrayWithArray:_viewControllers];
    [newViewControllerArray addObject:viewController];
    viewController.containingViewController = self;
    
    _viewControllers = [[NSArray alloc] initWithArray:newViewControllerArray];
    
    // enbiggen the scroll views content size
    CGRect cr = _contentViewContainer.frame;
    cr.size.width += viewController.view.frame.size.width;
    [_contentViewContainer setFrame:cr];
	
	// set frame of last view controller
	CGRect r = _contentViewContainer.frame;
	r.size.width = viewController.view.frame.size.width;
    r.origin.x = cr.size.width - viewController.view.frame.size.width;
	r.origin.y = 0;
	[viewController.view setFrame:r];
    
    // add the new view controllers view to the far right of the scroll view
    _visibleViewController = viewController;
    viewController.modalNavigationController = self;
    [_contentViewContainer addSubview:viewController.view];
    
    // scroll animate that sucker
    [UIView animateWithDuration:0.2 animations:^{
        CGRect r = self->_contentViewContainer.frame;
        r.origin.x -= viewController.view.frame.size.width;
        [self->_contentViewContainer setFrame:r];
    } completion:^(BOOL finished){
        //[visibleViewController viewDidAppear:YES];
    }];
}

- (void)setViewControllers:(NSArray *)controllers 
{
    _viewControllers = controllers;
    
    // remove all previous view controller views
    for (UIView *v in _contentViewContainer.subviews) {
        [v removeFromSuperview];
    }
    
    for (CVViewController *vc in controllers) {
        vc.containingViewController = self;
    }
    
    // grab the last view controller off the stack (array)
    CVViewController *lastController = [_viewControllers lastObject];
    

    // if there is a last view controller, add it to the scroll view
    if (lastController) {
        _topViewController = [_viewControllers objectAtIndex:0];
        
        // set frame of last view controller
        CGRect cr = _contentViewContainer.frame;
        cr.size.width = lastController.view.frame.size.width;
        cr.origin.y = 0;
        cr.origin.x = 0;
        [lastController.view setFrame:cr];

        // reset the frame of the content container
        CGRect r = _contentViewContainer.frame;
        r.origin.x = 0;
        r.size.width = lastController.view.frame.size.width;
        [_contentViewContainer setFrame:r];
        
        // add it to the content view container
        _visibleViewController = lastController;
        lastController.modalNavigationController = self;
        [_contentViewContainer addSubview:lastController.view];
    }
    //[lastController viewDidAppear:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
