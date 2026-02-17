//
//  CVPageModalViewController_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVPageModalViewController : CVViewController

@property (nonatomic, nullable, weak  ) IBOutlet UIView           *modalViewContainer;
@property (nonatomic, strong)          CVViewController *contentViewController;

- (instancetype)initWithContentViewController:(CVViewController *)initContentViewController;

@end

NS_ASSUME_NONNULL_END
