//
//  CVCustomColorDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDataHolder.h"
#import "colors.h"

@interface CVCustomColorDataHolder : CVDataHolder

+ (NSArray *)customColorsDataHolderCollection;
+ (CVCustomColorDataHolder *)customColor:(UIColor *)color title:(NSString *)colorTitle;

@property (nonatomic, strong) UIColor  *color;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic        ) BOOL     isSelected;

@end
