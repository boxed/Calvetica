//
//  CVTextView.m
//  calvetica
//
//  Created by Adam Kirk on 5/6/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTextView.h"

@implementation CVTextView

- (void)awakeFromNib 
{
    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    self.editable = NO;
    
    [super awakeFromNib];
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *)sender 
{
	if (sender.state != 3) return;
	if (!self.editable) {
        [self.cv_delegate textViewWasTappedWhenUneditable:self];
    }
}

@end
