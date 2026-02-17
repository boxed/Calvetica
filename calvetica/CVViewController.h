//
//  CVViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVModalProtocol.h"
#import "CVPopoverBackdrop.h"

NS_ASSUME_NONNULL_BEGIN


@class CVNavigationController;
@class CVPageModalViewController;

@interface CVViewController : UIViewController

#pragma mark - Properties
@property (nonatomic, strong          )          NSMutableArray<CVPageModalViewController *>             *pageModalViewControllers;
@property (nonatomic, strong, readonly)          CVViewController           *closestSystemPresentedViewController;
@property (nonatomic, strong          )          NSMutableArray<CVViewController *>             *fullScreenModalViewControllers;
@property (nonatomic, strong          )          NSMutableArray             *popoverModalViewControllers;
@property (nonatomic, strong          )          CVNavigationController     *modalNavigationController;
@property (nonatomic, strong          )          CVViewController           *containingViewController;
@property (nonatomic, strong          )          UIColor                    *popoverBackdropColor;
@property (nonatomic, assign          )          CVPopoverArrowDirection    popoverArrowDirection;
@property (nonatomic, assign          )          CVPopoverModalAttachToSide attachPopoverArrowToSide;
@property (nonatomic, strong          )          UIView                     *popoverTargetView;
@property (nonatomic, assign          )          BOOL                       contentModified;
@property (nonatomic, nullable, weak            ) IBOutlet UIView                     *keyboardAccessoryView;

#pragma mark - Methods

- (void)viewDidAppearAfterLoad:(BOOL)animated;

- (void)hideKeyboard;
- (IBAction)accessoryViewCloseButtonTapped:(id)sender;

// page
- (void)presentPageModalViewController:(CVViewController *)modalViewController
                              animated:(BOOL)animated
                            completion:(void (^)(void))completion;
- (void)dismissPageModalViewControllerAnimated:(BOOL)animated
                                    completion:(void (^)(void))completion;

// full screen
- (void)presentFullScreenModalViewController:(CVViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissFullScreenModalViewControllerAnimated:(BOOL)animated;

// popover
- (void)presentPopoverModalViewController:(CVViewController<CVModalProtocol> *)modalViewController forView:(UIView *)view animated:(BOOL)animated;
- (void)dismissPopoverModalViewControllerAnimated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
