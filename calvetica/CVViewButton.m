//
//  CVPlainButton.m
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CVViewButton.h"


@implementation CVViewButton

- (UILabel *)titleLabel 
{
    if (self.subviews.count > 0) {
        UILabel *v = [self.subviews lastObject];
        if (v && [v isKindOfClass:[UILabel class]]) {
            return v;
        }
    }
    
    return nil;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (!enabled) {
        self.alpha = 0.6;
    }
}

@end
