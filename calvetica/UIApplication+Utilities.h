//
//  UIApplication+Utilities.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

@interface UIApplication (Utilities)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons;
+ (void)showBezelWithTitle:(NSString *)title;

- (CVViewController *)topmostSystemPresentedViewController;

@end



