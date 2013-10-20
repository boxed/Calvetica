//
//  UIColor+Comparisons.m
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import "UIColor+Compare.h"


@implementation UIColor (Compare)

- (BOOL)shouldUseLightText
{
    /*
     If you're only doing black or white text, use the color brightness calculation above.
     If it is below 125, use white text. If it is 125 or above, use black text.

     edit 1: bias towards black text. :)

     edit 2: The formula to use is ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000
     */

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    red                *= 255;
    green              *= 255;
    blue               *= 255;
    CGFloat brightness  = ((red * 299.0) + (green * 587.0) + (blue * 114.0)) / 1000.0;
    return brightness < 125;
}

- (BOOL)isEqualToColor:(UIColor *)color
{
    CGFloat red1;
    CGFloat green1;
    CGFloat blue1;
    CGFloat alpha1;
    [self getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];

    CGFloat red2;
    CGFloat green2;
    CGFloat blue2;
    CGFloat alpha2;
    [color getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];

    red1   *= 100;
    green1 *= 100;
    blue1  *= 100;
    alpha1 *= 100;

    red2   *= 100;
    green2 *= 100;
    blue2  *= 100;
    alpha2 *= 100;

    return (floor(red1)     == floor(red2) &&
            floor(green1)   == floor(green2) &&
            floor(blue1)    == floor(blue2) &&
            floor(alpha1)   == floor(alpha2));
}

@end
