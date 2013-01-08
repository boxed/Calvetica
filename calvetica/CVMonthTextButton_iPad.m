//
//  CVMonthTextButton_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthTextButton_iPad.h"
#import "colors.h"




@implementation CVMonthTextButton_iPad




#pragma mark - Properties

- (void)setHighlighted:(BOOL)highlighted 
{
    super.highlighted = highlighted;
    if (self.highlighted) {
        for (UILabel *label in self.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.textColor = patentedBlack;
                label.shadowOffset = CGSizeMake(0,1);
                label.shadowColor = patentedWhiteLightShadow;
            }
        }
    } else {
        for (UILabel *label in self.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.textColor = patentedWhite;
                label.shadowOffset = CGSizeMake(0,1);
                label.shadowColor = patentedBlackLightShadow;
            }
        }
    }
}




#pragma mark - Constructor




#pragma mark - Memory Management





#pragma mark - View lifecycle




#pragma mark - Methods




@end
