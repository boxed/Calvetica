//
//  CVWelcomeViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVViewController.h"
#import "CVRoundedButton.h"


typedef enum {
	CVWelcomeViewControllerResultStore,
    CVWelcomeViewControllerResultFAQ,
    CVWelcomeViewControllerResultGestures,
    CVWelcomeViewControllerResultDontShowMe,
	CVWelcomeViewControllerResultCancel
} CVWelcomeViewControllerResult;


@protocol CVWelcomeViewControllerDelegate;


@interface CVWelcomeViewController : CVViewController

@property (nonatomic, weak) id<CVWelcomeViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet CVRoundedButton *faqButton;
@property (nonatomic, weak) IBOutlet CVRoundedButton *gestureButton;

- (IBAction)faqButtonWasTapped:(id)sender;
- (IBAction)gesturesButtonWasTapped:(id)sender;
- (IBAction)closeButtonWasTapped:(id)sender;
- (IBAction)dontShowMeButtonTapped:(id)sender;

@end




@protocol CVWelcomeViewControllerDelegate <NSObject>
@required
- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result;
@end
