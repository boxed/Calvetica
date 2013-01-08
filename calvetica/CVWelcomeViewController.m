//
//  CVWelcomeViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWelcomeViewController.h"




@implementation CVWelcomeViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)migrateButtonWasTapped:(id)sender
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultMigrateReminders];
}

- (IBAction)faqButtonWasTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultFAQ];
}

- (IBAction)gesturesButtonWasTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultGestures];
}

- (IBAction)closeButtonWasTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultCancel];
}

- (IBAction)learnToMakeYourOwnButtonWasTapped:(id)sender 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.tinkerlearn.com/"]];
}

- (IBAction)dontShowMeButtonTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultDontShowMe];
}


@end
