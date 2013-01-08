//
//  CVViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVModalProtocol.h"
#import "CVPopoverBackdrop.h"

@class CVNavigationController;

@interface CVViewController : UIViewController

#pragma mark - Properties
@property (nonatomic, strong) NSMutableArray *pageModalViewControllers;
@property (weak, nonatomic, readonly) CVViewController *closestSystemPresentedViewController;
@property (nonatomic, strong) NSMutableArray *fullScreenModalViewControllers;
@property (nonatomic, strong) NSMutableArray *popoverModalViewControllers;
@property (nonatomic, unsafe_unretained) CVNavigationController *modalNavigationController;
@property (nonatomic, weak) CVViewController *containingViewController;
@property (nonatomic, strong) UIColor *popoverBackdropColor;
@property (nonatomic, assign) CVPopoverArrowDirection popoverArrowDirection;
@property (nonatomic, assign) CVPopoverModalAttachToSide attachPopoverArrowToSide;
@property (nonatomic, strong) UIView *popoverTargetView;
@property (nonatomic, assign) BOOL contentModified;


#pragma mark - IBOutles
@property (nonatomic, strong) IBOutlet UIView *keyboardAccessoryView;

#pragma mark - Methods

- (void)hideKeyboard;

- (void)presentPageModalViewController:(CVViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissPageModalViewControllerAnimated:(BOOL)animated;

- (void)presentFullScreenModalViewController:(CVViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissFullScreenModalViewControllerAnimated:(BOOL)animated;

- (void)presentPopoverModalViewController:(CVViewController<CVModalProtocol> *)modalViewController forView:(UIView *)view animated:(BOOL)animated;
- (void)dismissPopoverModalViewControllerAnimated:(BOOL)animated;

#pragma mark - Actions
- (IBAction)accessoryViewCloseButtonTapped:(id)sender;

@end
