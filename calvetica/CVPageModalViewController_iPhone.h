//
//  CVPageModalViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"


@interface CVPageModalViewController_iPhone : CVViewController

@property (nonatomic, weak  ) IBOutlet UIView           *modalViewContainer;
@property (nonatomic, strong)          CVViewController *contentViewController;

- (id)initWithContentViewController:(CVViewController *)initContentViewController;

@end
