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

@property (nonatomic, unsafe_unretained) id<CVWelcomeViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet CVRoundedButton *faqButton;
@property (nonatomic, strong) IBOutlet CVRoundedButton *gestureButton;

- (IBAction)faqButtonWasTapped:(id)sender;
- (IBAction)gesturesButtonWasTapped:(id)sender;
- (IBAction)closeButtonWasTapped:(id)sender;
- (IBAction)dontShowMeButtonTapped:(id)sender;

@end




@protocol CVWelcomeViewControllerDelegate <NSObject>
@required
- (void)welcomeController:(CVWelcomeViewController *)controller didFinishWithResult:(CVWelcomeViewControllerResult)result;
@end
