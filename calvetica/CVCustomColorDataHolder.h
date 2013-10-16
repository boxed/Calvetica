//
//  CVCustomColorDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@interface CVCustomColorDataHolder : NSObject

@property (nonatomic, strong) UIColor  *color;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic        ) BOOL     isSelected;

+ (NSArray *)customColorsDataHolderCollection;

@end
