//
//  UIColor+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIColor+Calvetica.h"
#import <UIColor+Distance.h>
#import <MYSCategoryProperties.h>


#define CV_PALETTE_1 [UIColor colorWithRed:0.937 green:0.631 blue:0.502 alpha:1.000]
#define CV_PALETTE_2 [UIColor colorWithRed:0.898 green:0.459 blue:0.310 alpha:1.000]
#define CV_PALETTE_3 [UIColor colorWithRed:0.835 green:0.122 blue:0.000 alpha:1.000]
#define CV_PALETTE_4 [UIColor colorWithRed:0.647 green:0.816 blue:0.863 alpha:1.000]
#define CV_PALETTE_5 [UIColor colorWithRed:0.478 green:0.710 blue:0.780 alpha:1.000]
#define CV_PALETTE_6 [UIColor colorWithRed:0.153 green:0.529 blue:0.643 alpha:1.000]
#define CV_PALETTE_7 [UIColor colorWithRed:0.702 green:0.718 blue:0.812 alpha:1.000]
#define CV_PALETTE_8 [UIColor colorWithRed:0.549 green:0.569 blue:0.702 alpha:1.000]
#define CV_PALETTE_9 [UIColor colorWithRed:0.267 green:0.298 blue:0.518 alpha:1.000]
#define CV_PALETTE_10 [UIColor colorWithRed:0.639 green:0.827 blue:0.741 alpha:1.000]
#define CV_PALETTE_11 [UIColor colorWithRed:0.467 green:0.725 blue:0.600 alpha:1.000]
#define CV_PALETTE_12 [UIColor colorWithRed:0.133 green:0.553 blue:0.349 alpha:1.000]
#define CV_PALETTE_13 [UIColor colorWithRed:0.765 green:0.824 blue:0.525 alpha:1.000]
#define CV_PALETTE_14 [UIColor colorWithRed:0.631 green:0.718 blue:0.333 alpha:1.000]
#define CV_PALETTE_15 [UIColor colorWithRed:0.400 green:0.541 blue:0.000 alpha:1.000]
#define CV_PALETTE_16 [UIColor colorWithRed:0.792 green:0.671 blue:0.827 alpha:1.000]
#define CV_PALETTE_17 [UIColor colorWithRed:0.675 green:0.506 blue:0.725 alpha:1.000]
#define CV_PALETTE_18 [UIColor colorWithRed:0.471 green:0.196 blue:0.553 alpha:1.000]
#define CV_PALETTE_19 [UIColor colorWithRed:0.925 green:0.792 blue:0.510 alpha:1.000]
#define CV_PALETTE_20 [UIColor colorWithRed:0.878 green:0.671 blue:0.318 alpha:1.000]
#define CV_PALETTE_21 [UIColor colorWithRed:0.804 green:0.467 blue:0.000 alpha:1.000]
#define CV_PALETTE_22 [UIColor colorWithRed:0.937 green:0.000 blue:0.000 alpha:1.000]
#define CV_PALETTE_23 [UIColor colorWithRed:0.961 green:0.596 blue:0.000 alpha:1.000]
#define CV_PALETTE_24 [UIColor colorWithRed:0.988 green:0.914 blue:0.000 alpha:1.000]
#define CV_PALETTE_25 [UIColor colorWithRed:0.549 green:1.000 blue:0.000 alpha:1.000]
#define CV_PALETTE_26 [UIColor colorWithRed:0.302 green:1.000 blue:0.325 alpha:1.000]
#define CV_PALETTE_27 [UIColor colorWithRed:0.298 green:0.996 blue:1.000 alpha:1.000]
#define CV_PALETTE_28 [UIColor colorWithRed:0.180 green:0.584 blue:1.000 alpha:1.000]
#define CV_PALETTE_29 [UIColor colorWithRed:0.051 green:0.067 blue:1.000 alpha:1.000]
#define CV_PALETTE_30 [UIColor colorWithRed:0.306 green:0.000 blue:1.000 alpha:1.000]
#define CV_PALETTE_31 [UIColor colorWithRed:0.482 green:0.000 blue:1.000 alpha:1.000]
#define CV_PALETTE_32 [UIColor colorWithRed:0.812 green:0.000 blue:1.000 alpha:1.000]
#define CV_PALETTE_33 [UIColor colorWithRed:0.937 green:0.000 blue:0.396 alpha:1.000]
#define CV_PALETTE_34 [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000]
#define CV_PALETTE_35 [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1.000]
#define CV_PALETTE_36 [UIColor colorWithRed:0.427 green:0.427 blue:0.427 alpha:1.000]
#define CV_PALETTE_37 [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000]
#define CV_PALETTE_38 [UIColor colorWithRed:0.706 green:0.000 blue:0.000 alpha:1.000]


@implementation UIColor (Calvetica)

@dynamic mys_title;
@dynamic mys_selected;

+ (void)load
{
    [MYSCategoryProperties setup:self];
}

+ (NSArray *)primaryPalette
{
    return @[[self customColor:CV_PALETTE_1 title:@"Tequila Sunset"],
             [self customColor:CV_PALETTE_2 title:@"Salmon Patty"],
             [self customColor:CV_PALETTE_3 title:@"\"Geoff\""],
             [self customColor:CV_PALETTE_4 title:@"Cold Shoulder"],
             [self customColor:CV_PALETTE_5 title:@"Iceman Cometh"],
             [self customColor:CV_PALETTE_6 title:@"Blue Steel"],
             [self customColor:CV_PALETTE_7 title:@"Electric Boogaloo"],
             [self customColor:CV_PALETTE_8 title:@"Mysterious Shadow"],
             [self customColor:CV_PALETTE_9 title:@"Also Blue Steel"],
             [self customColor:CV_PALETTE_10 title:@"Members Only"],
             [self customColor:CV_PALETTE_11 title:@"Greenesque"],
             [self customColor:CV_PALETTE_12 title:@"Teal With Envy"],
             [self customColor:CV_PALETTE_13 title:@"Romaine Empire"],
             [self customColor:CV_PALETTE_14 title:@"Wild Cucumber"],
             [self customColor:CV_PALETTE_15 title:@"Eat Your Veggies"],
             [self customColor:CV_PALETTE_16 title:@"Angry Peacock"],
             [self customColor:CV_PALETTE_17 title:@"Violet Crumble"],
             [self customColor:CV_PALETTE_18 title:@"Deep Purple"],
             [self customColor:CV_PALETTE_19 title:@"Mango Lassi"],
             [self customColor:CV_PALETTE_20 title:@"Le Tigre"],
             [self customColor:CV_PALETTE_21 title:@"Chancho"]];
}

+ (NSArray *)secondaryPalette
{
    return @[[self customColor:CV_PALETTE_22 title:@"Caliente Tamale"],
             [self customColor:CV_PALETTE_23 title:@"Burning Down The House"],
             [self customColor:CV_PALETTE_24 title:@"Lemony Snickers"],
             [self customColor:CV_PALETTE_25 title:@"Lime Uh Rick"],
             [self customColor:CV_PALETTE_26 title:@"Not Lime"],
             [self customColor:CV_PALETTE_27 title:@"Retina Burn Blue"],
             [self customColor:CV_PALETTE_28 title:@"Contrails Over Paris"],
             [self customColor:CV_PALETTE_29 title:@"Bleu"],
             [self customColor:CV_PALETTE_30 title:@"Violet Grumble"],
             [self customColor:CV_PALETTE_31 title:@"Sasquatch Purple"],
             [self customColor:CV_PALETTE_32 title:@"Hot Pants"],
             [self customColor:CV_PALETTE_33 title:@"Hotter Pants"],
             [self customColor:CV_PALETTE_34 title:@"Blacktastikal"],
             [self customColor:CV_PALETTE_35 title:@"Night Owl"],
             [self customColor:CV_PALETTE_36 title:@"Dusky"],
             [self customColor:CV_PALETTE_37 title:@"Misty Dew"],
             [self customColor:CV_PALETTE_38 title:@"Mystrou Red"]];
}

+ (NSArray *)systemPalette
{
    return @[[self customColor:[UIColor redColor]       title:@"Red"],
             [self customColor:[UIColor orangeColor]    title:@"Orange"],
             [self customColor:[UIColor yellowColor]    title:@"Yellow"],
             [self customColor:[UIColor greenColor]     title:@"Green"],
             [self customColor:[UIColor blueColor]      title:@"Blue"],
             [self customColor:[UIColor purpleColor]    title:@"Purple"],
             [self customColor:[UIColor brownColor]     title:@"Brown"]];
}

+ (UIColor *)randomColorFromPalette:(NSArray *)palette
{
    NSInteger index = arc4random() % [palette count];
    return palette[index];
}

- (UIColor *)closestColorInCalveticaPalette
{
    return [self closestColorInPalette:[UIColor primaryPalette]];
}




#pragma mark - Private

+ (UIColor *)customColor:(UIColor *)color title:(NSString *)title
{
    color.mys_title     = title;
    color.mys_selected  = NO;
    return color;
}

@end
