//
//  CVWelcomeViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWelcomeViewController.h"


@interface CVWelcomeViewController ()

@end


@implementation CVWelcomeViewController {
    __weak IBOutlet UIScrollView        *_scrollView;
    __weak IBOutlet UISegmentedControl  *_segmentedControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Only show the first page
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height);
    _scrollView.scrollEnabled = NO;
    _segmentedControl.hidden = YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (PAD) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - Actions

- (IBAction)closeButtonWasTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultCancel];
}

- (IBAction)faqButtonWasTapped:(id)sender
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultFAQ];
}

- (IBAction)gesturesButtonWasTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultGestures];
}

- (IBAction)learnAboutFirehoseWasTapped:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.firehosechat.com/"] options:@{} completionHandler:nil];
}

- (IBAction)contactUsButtonWasTapped:(id)sender
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultContactUs];
}

- (IBAction)dontShowMeButtonTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultDontShowMe];
}



@end
