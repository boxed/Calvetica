//
//  CVCustomColorDataHolder.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCustomColorDataHolder.h"
#import "colors.h"


@implementation CVCustomColorDataHolder


+ (NSArray *)customColorsDataHolderCollection {
    return @[[CVCustomColorDataHolder customColor:CV_PALETTE_1 title:NSLocalizedString(@"Tequila Sunset", @"Tequila Sunset")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_2 title:NSLocalizedString(@"Salmon Patty", @"Salmon Patty")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_3 title:NSLocalizedString(@"\"Geoff\"", @"\"Geoff\"")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_4 title:NSLocalizedString(@"Cold Shoulder", @"Cold Shoulder")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_5 title:NSLocalizedString(@"Iceman Cometh", @"Iceman Cometh")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_6 title:NSLocalizedString(@"Blue Steel", @"Blue Steel")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_7 title:NSLocalizedString(@"Electric Boogaloo", @"Electric Boogaloo")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_8 title:NSLocalizedString(@"Mysterious Shadow", @"Mysterious Shadow")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_9 title:NSLocalizedString(@"Also Blue Steel", @"Also Blue Steel")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_10 title:NSLocalizedString(@"Members Only", @"Members Only")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_11 title:NSLocalizedString(@"Greenesque", @"Greenesque")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_12 title:NSLocalizedString(@"Teal With Envy", @"Teal With Envy")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_13 title:NSLocalizedString(@"Romaine Empire", @"Romaine Empire")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_14 title:NSLocalizedString(@"Wild Cucumber", @"Wild Cucumber")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_15 title:NSLocalizedString(@"Eat Your Veggies", @"Eat Your Veggies")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_16 title:NSLocalizedString(@"Angry Peacock", @"Angry Peacock")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_17 title:NSLocalizedString(@"Violet Crumble", @"Violet Crumble")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_18 title:NSLocalizedString(@"Deep Purple", @"Deep Purple")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_19 title:NSLocalizedString(@"Mango Lassi", @"Mango Lassi")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_20 title:NSLocalizedString(@"Le Tigre", @"Le Tigre")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_21 title:NSLocalizedString(@"Chancho", @"Chancho")],
            
            [CVCustomColorDataHolder customColor:CV_PALETTE_22 title:NSLocalizedString(@"Caliente Tamale", @"Caliente Tamale")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_23 title:NSLocalizedString(@"Burning Down The House", @"Burning Down The House")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_24 title:NSLocalizedString(@"Lemony Snickers", @"Lemony Snickers")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_25 title:NSLocalizedString(@"Lime Uh Rick", @"Lime Uh Rick")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_26 title:NSLocalizedString(@"Not Lime", @"Not Lime")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_27 title:NSLocalizedString(@"Retina Burn Blue", @"Retina Burn Blue")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_28 title:NSLocalizedString(@"Contrails Over Paris", @"Contrails Over Paris")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_29 title:NSLocalizedString(@"Bleu", @"Bleu")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_30 title:NSLocalizedString(@"Violet Grumble", @"Violet Grumble")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_31 title:NSLocalizedString(@"Sasquatch Purple", @"Sasquatch Purple")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_32 title:NSLocalizedString(@"Hot Pants", @"Hot Pants")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_33 title:NSLocalizedString(@"Hotter Pants", @"Hotter Pants")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_34 title:NSLocalizedString(@"Blacktastikal", @"Blacktastikal")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_35 title:NSLocalizedString(@"Night Owl", @"Night Owl")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_36 title:NSLocalizedString(@"Dusky", @"Dusky")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_37 title:NSLocalizedString(@"Misty Dew", @"Misty Dew")],
            [CVCustomColorDataHolder customColor:CV_PALETTE_38 title:NSLocalizedString(@"Mystrou Red", @"Mystrou Red")],
            
            [CVCustomColorDataHolder customColor:[UIColor redColor] title:NSLocalizedString(@"Plain Red", @"Plain Red")],
            [CVCustomColorDataHolder customColor:[UIColor orangeColor] title:NSLocalizedString(@"Plain Orange", @"Plain Orange")],
            [CVCustomColorDataHolder customColor:[UIColor yellowColor] title:NSLocalizedString(@"Plain Yellow", @"Plain Yellow")],
            [CVCustomColorDataHolder customColor:[UIColor greenColor] title:NSLocalizedString(@"Plain Green", @"Plain Green")],
            [CVCustomColorDataHolder customColor:[UIColor blueColor] title:NSLocalizedString(@"Plain Blue", @"Plain Blue")],
            [CVCustomColorDataHolder customColor:[UIColor purpleColor] title:NSLocalizedString(@"Plain Purple", @"Plain Purple")],
            [CVCustomColorDataHolder customColor:[UIColor brownColor] title:NSLocalizedString(@"Plain Brown", @"Brown")]];
}

+ (CVCustomColorDataHolder *)customColor:(UIColor *)customColor title:(NSString *)colorTitle {
    CVCustomColorDataHolder *holder = [[CVCustomColorDataHolder alloc] init];
    holder.color = customColor;
    holder.title = colorTitle;
    holder.isSelected = NO;
    
    return holder;
}


@end
