//
//  CVNavigationController.h
//  calvetica
//
//  Created by Adam Kirk on 5/5/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVNavigationController : CVViewController

#pragma mark - UINavigationController "like" properties
@property (nonatomic, nullable, weak            ) IBOutlet UIView           *contentViewContainer;
@property (nonatomic, strong, readonly)          CVViewController *topViewController;
@property (nonatomic, copy            )          NSArray<CVViewController *>          *viewControllers;
@property (nonatomic, strong, readonly)          CVViewController *visibleViewController;


#pragma mark - UINavigationController "like" methods
- (CVViewController *)popViewControllerAnimated:(BOOL)animated;
- (void)pushViewController:(CVViewController *)viewController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
