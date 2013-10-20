//
//  UIColor+Comparisons.h
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import <UIKit/UIKit.h>


@interface UIColor (Compare)

- (BOOL)shouldUseLightText;

- (BOOL)isEqualToColor:(UIColor *)color;

@end
