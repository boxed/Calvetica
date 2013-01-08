//
//  CVKBDetailWebViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "KBQuestion.h"
#import "CVModalProtocol.h"
#import "CVViewController.h"


@protocol CVKBDetailWebViewControllerDelegate;


@interface CVKBDetailWebViewController : CVViewController <UIWebViewDelegate, CVModalProtocol>{
}


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVKBDetailWebViewControllerDelegate> delegate;
@property (nonatomic, strong) KBQuestion *question;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

#pragma mark - Methods
- (void)loadAnswerHTML;

#pragma mark - IBActions


#pragma mark - Notifications


@end

@protocol CVKBDetailWebViewControllerDelegate <NSObject>
@required
- (void)KBDetailsControllerDidFinish:(CVKBDetailWebViewController *)controller;
@end