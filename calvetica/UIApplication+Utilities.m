//
//  UIApplication+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIApplication+Utilities.h"
#import "CVAlertViewController.h"
#import "CVHUD.h"
#import "CVViewController.h"
#import "UIView+Utilities.h"


@implementation UIApplication (Utilities)

- (CVViewController *)topmostSystemPresentedViewController 
{
    CVViewController *topmost = (CVViewController *)self.windows.firstObject.rootViewController;
    
    // climb down the presented view controller chain until we get the top most presented view controller
    while (topmost.presentedViewController) {
        topmost = (CVViewController *)topmost.presentedViewController;
    }
    return topmost;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
                completion:(void (^)(void))completion
{
	CVAlertViewController *alertViewController = [[CVAlertViewController alloc] init];
    [alertViewController view];

    CVViewController *topmostViewController = [[UIApplication sharedApplication] topmostSystemPresentedViewController];
    alertViewController.titleLabel.text     = title;
    alertViewController.completion          = completion;
	[alertViewController setMessageText:message resizeDialog:YES];
	
	for (CVActionBlockButton *button in buttons) {
		[alertViewController addButton:button];
	}

	[topmostViewController presentPageModalViewController:alertViewController animated:YES completion:^{
        alertViewController.view.x -= 20;
        [UIView mt_animateWithDuration:0.5
                        timingFunction:kMTEaseOutElastic
                               options:(MTViewAnimationOptions)UIViewAnimationOptionBeginFromCurrentState
                            animations:^
         {
             alertViewController.view.x += 20;
         } completion:^{
             if (completion) completion();
         }];
    }];
}

+ (void)showBezelWithTitle:(NSString *)title
{
    CVHUD *bezel = [CVHUD fromNibOfSameName];
    bezel.titleLabel.text = title;
    
	CVViewController *topmostViewController = [[UIApplication sharedApplication] topmostSystemPresentedViewController];
    
    [topmostViewController.view addSubview:bezel];
    [bezel presentBezel];
}

@end
