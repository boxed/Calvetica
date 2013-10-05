//
//  CVWelcomeViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVViewController.h"


typedef enum {
    CVWelcomeViewControllerResultFAQ,
    CVWelcomeViewControllerResultGestures,
    CVWelcomeViewControllerResultContactUs,
    CVWelcomeViewControllerResultDontShowMe,
	CVWelcomeViewControllerResultCancel
} CVWelcomeViewControllerResult;


@protocol CVWelcomeViewControllerDelegate;


@interface CVWelcomeViewController : CVViewController
@property (nonatomic, weak) id<CVWelcomeViewControllerDelegate> delegate;
@end


@protocol CVWelcomeViewControllerDelegate <NSObject>
- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result;
@end
