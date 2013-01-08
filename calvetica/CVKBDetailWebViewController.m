//
//  CVKBDetailWebViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVKBDetailWebViewController.h"




@implementation CVKBDetailWebViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self loadAnswerHTML];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadAnswerHTML
{
    if (self.question) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];        
        [self.webView loadHTMLString:self.question.answerHTML baseURL:baseURL];
        self.webView.delegate = self;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    [self.activityIndicator stopAnimating];
}


#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched 
{
	[_delegate KBDetailsControllerDidFinish:self];
}

@end
