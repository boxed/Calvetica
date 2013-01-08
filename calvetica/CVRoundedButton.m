//
//  CVRoundedButton.m
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CVRoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CVRoundedButton

- (void)awakeFromNib 
{
    [super awakeFromNib];
    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
}

@end
