//
//  CVAlertViewController.m
//  calvetica
//
//  Created by Adam Kirk on 5/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAlertViewController.h"
#import "UIApplication+Utilities.h"
#import "geometry.h"

#define BUTTON_SPACING 10.0f
#define PADDING 20.0f



@implementation CVAlertViewController

#pragma mark - Methods

- (NSMutableArray *)buttons 
{
    if (!_buttons) {
        self.buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)addButton:(CVActionBlockButton *)button 
{
    [self.buttons addObject:button];
	
	button.alertViewController = self;
	
	// resize button container to fit new button
    CGRect f = self.buttonContainerView.frame;
    f.size.height = (self.buttons.count * (button.frame.size.height + BUTTON_SPACING)) - BUTTON_SPACING;
    [_buttonContainerView setFrame:f];
    
    // resize alert view
    f = self.view.frame;
    CGFloat newHeight = _buttonContainerView.frame.origin.y + _buttonContainerView.frame.size.height + PADDING; // 20 for padding on bottom
    f = CVRectResize(f, CGSizeMake(f.size.width, newHeight));
    [self.view setFrame:f];

    // set frame of new button
    f = button.frame;
    f.origin.y = ((self.buttons.count * (button.frame.size.height + BUTTON_SPACING)) - BUTTON_SPACING) - button.frame.size.height;
    [button setFrame:f];

    // add the button to the UI
    [_buttonContainerView addSubview:button];
	
}

- (void)dismiss
{
	CVViewController *rootViewController = [[UIApplication sharedApplication] topmostSystemPresentedViewController];
	[rootViewController dismissPageModalViewControllerAnimated:YES completion:^{
        if (self.completion) self.completion();
    }];
}

- (void)setMessageText:(NSString *)message resizeDialog:(BOOL)resize 
{
    self.messageTextView.text = message;
    
    if (resize) {
        CGRect frame = self.messageTextView.frame;
        frame.size.height = self.messageTextView.contentSize.height;
        self.messageTextView.frame = frame;
        
        // After resizing the message text view, resize the dialog.
        CGRect alertFrame = self.view.frame;
        CGFloat newHeight = self.messageTextView.frame.origin.y + self.messageTextView.frame.size.height + _buttonContainerView.frame.size.height + PADDING;
        alertFrame = CVRectResize(alertFrame, CGSizeMake(alertFrame.size.width, newHeight));
        self.view.frame = alertFrame;
        
        // Reposition the buttons container.
        CGRect buttonFrame = _buttonContainerView.frame;
        buttonFrame.origin.y = self.messageTextView.frame.origin.y + self.messageTextView.frame.size.height;
        _buttonContainerView.frame = buttonFrame;
    }
}



#pragma mark - Actions

- (IBAction)closeButtonWasTapped:(id)sender 
{
	[self dismiss];
}




@end
