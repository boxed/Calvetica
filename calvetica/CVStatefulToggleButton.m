//
//  CVAlarmPickerPopupButton.m
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVStatefulToggleButton.h"
#import "colors.h"


@implementation CVStatefulToggleButton

- (void)setup 
{
    [super setup];
    self.selectable = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *)sender 
{
	if (sender.state != UIGestureRecognizerStateEnded || _isDisabled) return;
    self.selected = !self.selected;
}

@end
