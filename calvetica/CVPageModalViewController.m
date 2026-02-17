//
//  CVPageModalViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPageModalViewController.h"
#import "CVAppDelegate.h"

@implementation CVPageModalViewController

- (instancetype)initWithContentViewController:(CVViewController *)initContentViewController 
{
    self = [super init];
    if (self) {
        _contentViewController = initContentViewController;
        _contentViewController.containingViewController = self;
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat topMargin = 40;
    CGFloat bottomMargin = 40;
    CGFloat horizontalMargin = 16;
    if ([CVAppDelegate hasNotch]) {
        topMargin = 60;
        bottomMargin = 50;
    }

    _contentViewController.view.width   = self.view.width - (horizontalMargin * 2);
    _contentViewController.view.height  = self.view.height - topMargin - bottomMargin;
    _contentViewController.view.y       = topMargin;
    _contentViewController.view.x       = horizontalMargin;

    // add content to view controller
    [self.view addSubview:_contentViewController.view];
}

@end
