//
//  CVWelcomeViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVWelcomeViewControllerResult) {
    CVWelcomeViewControllerResultFAQ,
    CVWelcomeViewControllerResultGestures,
    CVWelcomeViewControllerResultContactUs,
    CVWelcomeViewControllerResultDontShowMe,
	CVWelcomeViewControllerResultCancel
};


@protocol CVWelcomeViewControllerDelegate;


@interface CVWelcomeViewController : CVViewController
@property (nonatomic, nullable, weak) id<CVWelcomeViewControllerDelegate> delegate;
@end


@protocol CVWelcomeViewControllerDelegate <NSObject>
- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result;
@end

NS_ASSUME_NONNULL_END
