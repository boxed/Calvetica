//
//  CVFAQViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVFAQViewController.h"
#import "CVNativeAlertView.h"


@interface CVFAQViewController () <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView               *helpScreen;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@end


@implementation CVFAQViewController

- (void)dealloc
{
    self.helpScreen.delegate = nil;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"FAQ";
    
    NSError *error;
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];    
    NSString *HTMLpath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
    NSString *HTML = [NSString stringWithContentsOfFile:HTMLpath encoding:NSUTF8StringEncoding error:&error];
    [self.helpScreen loadHTMLString:HTML baseURL:baseURL];
    self.helpScreen.delegate = self;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}



#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView 
{
    [self.indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    [self.indicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
	if(navigationType == UIWebViewNavigationTypeLinkClicked && ![request.URL isFileURL]) {
        [CVNativeAlertView showWithTitle:@"External Link" message:@"This link will be opened with Safari" cancelButtonTitle:@"cancel" cancelButtonBlock:nil otherButtonTitle:@"open" otherButtonBlock:^(void) {
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            }
            else {
                [CVNativeAlertView showWithTitle:@"Safari can not be opened" message:@"please verify network connection & parental settings" cancelButtonTitle:@"OK"];
            }
        }]; 
        return NO;
    }
	else {
		return YES;
    }
}



- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
