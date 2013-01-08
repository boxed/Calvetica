//
//  UIApplication+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIApplication+Utilities.h"
#import "CVAlertViewController.h"
#import "CVBezel.h"
#import "CVViewController.h"


@implementation UIApplication (Utilities)

- (CVViewController *)topmostSystemPresentedViewController 
{
    CVViewController *topmost = (CVViewController *)self.keyWindow.rootViewController;
    
    // climb down the presented view controller chain until we get the top most presented view controller
    while (topmost.presentedViewController) {
        topmost = (CVViewController *)topmost.presentedViewController;
    }
    return topmost;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons {
	
	CVAlertViewController *alertViewController = [[CVAlertViewController alloc] init];
	CVViewController *topmostViewController = [[UIApplication sharedApplication] topmostSystemPresentedViewController];
	[topmostViewController presentFullScreenModalViewController:alertViewController animated:YES];
	alertViewController.titleLabel.text = title;
	[alertViewController setMessageText:message resizeDialog:YES];
	
	for (CVActionBlockButton *button in buttons) {
		[alertViewController addButton:button];
	}
}

+ (void)showBezelWithTitle:(NSString *)title {
    CVBezel *bezel = [CVBezel viewFromNib:[CVBezel nib]];
    bezel.titleLabel.text = title;
    
	CVViewController *topmostViewController = [[UIApplication sharedApplication] topmostSystemPresentedViewController];
    
    [topmostViewController.view addSubview:bezel];
    [bezel presentBezel];
}

@end
