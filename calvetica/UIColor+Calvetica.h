//
//  UIColor+Utilities.h
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Calvetica)

@property (nonatomic, strong) NSString *mys_title;
@property (nonatomic, assign) BOOL     mys_selected;

+ (NSArray *)primaryPalette;
+ (NSArray *)secondaryPalette;
+ (NSArray *)systemPalette;

+ (UIColor *)randomColorFromPalette:(NSArray *)palette;
- (UIColor *)closestColorInCalveticaPalette;

@end

NS_ASSUME_NONNULL_END