//
//  CVContactUsViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"
#import <MessageUI/MessageUI.h>
#import "CVDebug.h"

@protocol CVContactUsViewControllerDelegate;


@interface CVContactUsViewController : UITableViewController <MFMailComposeViewControllerDelegate>

- (void)emailButtonWasPressed;
- (void)twitterButtonWasPressed;
- (void)appStoreButtonWasPressed;

@end
