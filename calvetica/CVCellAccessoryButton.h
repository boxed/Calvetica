//
//  CVCellAccessoryButton.h
//  calvetica
//
//  Created by Adam Kirk on 5/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "geometry.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CVCellAccessoryButtonMode) {
    CVCellAccessoryButtonModeDefault,
    CVCellAccessoryButtonModeDelete
};

@interface CVCellAccessoryButton : UIControl

@property (nonatomic) CVCellAccessoryButtonMode mode;
@property (nonatomic, strong) UIImage *defaultImage;

- (void)toggleMode;

@end

NS_ASSUME_NONNULL_END
