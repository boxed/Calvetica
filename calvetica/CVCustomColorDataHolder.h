//
//  CVCustomColorDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDataHolder.h"
#import "colors.h"

@interface CVCustomColorDataHolder : CVDataHolder {
@private
@protected
}

+ (NSArray *)customColorsDataHolderCollection;
+ (CVCustomColorDataHolder *)customColor:(UIColor *)color title:(NSString *)colorTitle;

#pragma mark - Public Properties
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL isSelected;

#pragma mark - Public Methods

@end
