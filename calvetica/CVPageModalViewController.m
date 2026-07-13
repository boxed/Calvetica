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

    // add content to view controller (sizing happens in viewWillLayoutSubviews, once we have real bounds)
    [self.view addSubview:_contentViewController.view];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGFloat topMargin = 40;
    CGFloat bottomMargin = 40;
    CGFloat horizontalMargin = 16;
    if ([CVAppDelegate hasNotch]) {
        topMargin = 60;
        bottomMargin = 50;
    }

    CGRect bounds = self.view.bounds;

    // Legacy modals kept a fixed ~288pt width regardless of device. Controllers that opt in
    // (e.g. the jump-to-date dialog) stretch to nearly the full available width instead.
    CGFloat contentWidth;
    if (_contentViewController.modalMaximizesWidth) {
        contentWidth = bounds.size.width - (horizontalMargin * 2);
    } else {
        contentWidth = 320 - (horizontalMargin * 2);
    }

    CGFloat availableHeight = bounds.size.height - topMargin - bottomMargin;
    CGFloat contentHeight = availableHeight;
    CGFloat contentY = topMargin;
    if (_contentViewController.modalPreferredHeight > 0) {
        contentHeight = MIN(availableHeight, _contentViewController.modalPreferredHeight);
        contentY = round((bounds.size.height - contentHeight) / 2.0);
    }

    _contentViewController.view.width  = contentWidth;
    _contentViewController.view.height = contentHeight;
    _contentViewController.view.y      = contentY;
    _contentViewController.view.x      = round((bounds.size.width - contentWidth) / 2.0);
}

@end
