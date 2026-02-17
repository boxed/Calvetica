//
//  UIApplication+Utilities.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIApplication (Utilities)

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
                completion:(void (^)(void))completion;

+ (void)showBezelWithTitle:(NSString *)title;

- (CVViewController *)topmostSystemPresentedViewController;

@end

NS_ASSUME_NONNULL_END



