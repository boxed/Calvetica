//
//  CVFAQViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVFAQViewController.h"
#import "CVNativeAlertView.h"


@interface CVFAQViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *helpScreen;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@end


@implementation CVFAQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"FAQ";

    // Create WKWebView programmatically (replaces storyboard UIWebView)
    self.helpScreen = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.helpScreen.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.helpScreen.navigationDelegate = self;
    [self.view insertSubview:self.helpScreen atIndex:0];

    NSError *error;
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:bundlePath];
    NSString *HTMLpath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
    NSString *HTML = [NSString stringWithContentsOfFile:HTMLpath encoding:NSUTF8StringEncoding error:&error];
    [self.helpScreen loadHTMLString:HTML baseURL:baseURL];
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.indicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.indicator stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated && ![navigationAction.request.URL isFileURL]) {
        NSURL *url = navigationAction.request.URL;
        [CVNativeAlertView showWithTitle:@"External Link" message:@"This link will be opened with Safari" cancelButtonTitle:@"cancel" cancelButtonBlock:nil otherButtonTitle:@"open" otherButtonBlock:^(void) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
            else {
                [CVNativeAlertView showWithTitle:@"Safari cannot be opened" message:@"Please verify network connection & parental settings" cancelButtonTitle:@"OK"];
            }
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
