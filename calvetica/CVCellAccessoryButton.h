//
//  CVCellAccessoryButton.h
//  calvetica
//
//  Created by Adam Kirk on 5/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "geometry.h"

typedef enum {
    CVCellAccessoryButtonModeDefault,
    CVCellAccessoryButtonModeDelete
} CVCellAccessoryButtonMode;

@interface CVCellAccessoryButton : UIControl

@property (nonatomic) CVCellAccessoryButtonMode mode;
@property (nonatomic, strong) UIImage *defaultImage;

- (void)toggleMode;

@end
