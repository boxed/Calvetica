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
    
	// set the frame to match
	[_contentViewController.view setFrame:self.modalViewContainer.bounds];
	
    // add content to view controller
    [self.modalViewContainer addSubview:_contentViewController.view];
}

@end
