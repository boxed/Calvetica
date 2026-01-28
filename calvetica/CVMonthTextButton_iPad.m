//
//  CVMonthTextButton_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMonthTextButton_iPad.h"
#import "colors.h"




@implementation CVMonthTextButton_iPad

- (void)setHighlighted:(BOOL)highlighted 
{
    super.highlighted = highlighted;
    if (self.highlighted) {
        for (UILabel *label in self.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.textColor = calTextColor();
            }
        }
    } else {
        for (UILabel *label in self.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                label.textColor = calBackgroundColor();
            }
        }
    }
}


@end
