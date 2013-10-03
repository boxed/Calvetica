//
//  CVNavigationController.h
//  calvetica
//
//  Created by Adam Kirk on 5/5/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"


@interface CVNavigationController : CVViewController

#pragma mark - UINavigationController "like" properties
@property (nonatomic, weak            ) IBOutlet UIView           *contentViewContainer;
@property (nonatomic, strong, readonly)          CVViewController *topViewController;
@property (nonatomic, copy            )          NSArray          *viewControllers;
@property (nonatomic, strong, readonly)          CVViewController *visibleViewController;


#pragma mark - UINavigationController "like" methods
- (CVViewController *)popViewControllerAnimated:(BOOL)animated;
- (void)pushViewController:(CVViewController *)viewController animated:(BOOL)animated;

@end
