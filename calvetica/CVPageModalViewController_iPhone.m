//
//  CVPageModalViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPageModalViewController_iPhone.h"


@implementation CVPageModalViewController_iPhone

- (id)initWithContentViewController:(CVViewController *)initContentViewController 
{
    self = [super init];
    if (self) {
        _contentViewController = initContentViewController;
        _contentViewController.containingViewController = self;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

    if (_contentViewController.view.autoresizingMask & UIViewAutoresizingFlexibleHeight) {
        _contentViewController.view.height  = self.view.height - 60;
    }
    _contentViewController.view.y       = (self.view.height / 2) - (_contentViewController.view.height / 2);
    _contentViewController.view.x       = (self.view.width / 2) - (_contentViewController.view.width / 2);

    // add content to view controller
    [self.view addSubview:_contentViewController.view];
}

@end
