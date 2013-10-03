//
//  CVFAQViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVModalProtocol.h"
#import "CVViewController.h"


@protocol CVFAQViewControllerDelegate;


@interface CVFAQViewController : CVViewController <UIWebViewDelegate, CVModalProtocol>

@property (nonatomic, weak)          id<CVFAQViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIWebView                       *helpScreen;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView         *indicator;

@end




@protocol CVFAQViewControllerDelegate <NSObject>
@required
- (void)faqControllerDidFinish:(CVFAQViewController *)controller;
@end