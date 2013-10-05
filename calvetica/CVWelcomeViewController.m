//
//  CVWelcomeViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWelcomeViewController.h"


@interface CVWelcomeViewController () <UIScrollViewDelegate>

@end


@implementation CVWelcomeViewController {
    __weak IBOutlet UIScrollView        *_scrollView;
    __weak IBOutlet UISegmentedControl  *_segmentedControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(_scrollView.width * 3, _scrollView.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Actions

- (IBAction)segmentControlChanged:(UISegmentedControl *)segmentedControl
{
    [_scrollView scrollRectToVisible:CGRectMake(segmentedControl.selectedSegmentIndex * _scrollView.width,
                                                0,
                                                _scrollView.width,
                                                _scrollView.height)
                            animated:YES];
}


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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.getfirehose.com/"]];
}

- (IBAction)contactUsButtonWasTapped:(id)sender
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultContactUs];
}

- (IBAction)dontShowMeButtonTapped:(id)sender 
{
	[_delegate welcomeController:self didFinishWithResult:CVWelcomeViewControllerResultDontShowMe];
}



#pragma mark - DELEGATE scroll view

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _segmentedControl.selectedSegmentIndex = (NSInteger)(_scrollView.contentOffset.x / _scrollView.width);
}


@end
