//
//  CVMonthTextButton_iPhone.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthTextButton_iPhone.h"
#import "colors.h"



@implementation CVMonthTextButton_iPhone


- (void)setHighlighted:(BOOL)highlighted 
{
    super.highlighted = highlighted;
    if (self.highlighted) {
        self.titleLabel.textColor = patentedBlack;
        self.titleLabel.shadowOffset = CGSizeMake(-1,0);
        self.titleLabel.shadowColor = patentedWhiteLightShadow;
    } else {
        self.titleLabel.textColor = patentedWhite;
        self.titleLabel.shadowOffset = CGSizeMake(-1,0);
        self.titleLabel.shadowColor = patentedBlackLightShadow;
    }
}


@end
