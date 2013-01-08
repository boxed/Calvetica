//
//  CVActionBlockButton.m
//  calvetica
//
//  Created by Adam Kirk on 6/6/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVActionBlockButton.h"
#import "CVAlertViewController.h"


@interface CVActionBlockButton ()
@end



@implementation CVActionBlockButton

@synthesize titleLabel = _titleLabel;


+ (CVActionBlockButton *)buttonWithTitle:(NSString *)title andActionBlock:(void (^)(void))tapActionBlock {
	
	CVActionBlockButton *button = [CVActionBlockButton viewFromNib:[CVActionBlockButton nib]];
	
	button.titleLabel.text = title;
	button.actionBlock = tapActionBlock;

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:button action:@selector(handleTapGesture:)];
	[button addGestureRecognizer:tapGesture];
	
	return button;
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateEnded) return;
    
	// dismiss the alert view
	[_alertViewController dismiss];
	
    // execute its actions block
    _actionBlock();
    
}

@end
