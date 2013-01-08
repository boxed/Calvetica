//
//  CVRoundedTextButton.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRoundedTextButton.h"
#import <QuartzCore/QuartzCore.h>




@implementation CVRoundedTextButton




#pragma mark - Properties




#pragma mark - Constructor




#pragma mark - Memory Management





#pragma mark - View lifecycle




#pragma mark - Methods

- (void)setup 
{
    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
	[super setup];
}




@end
