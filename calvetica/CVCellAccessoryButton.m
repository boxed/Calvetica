//
//  CVCellAccessoryButton.m
//  calvetica
//
//  Created by Adam Kirk on 5/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCellAccessoryButton.h"


@implementation CVCellAccessoryButton

- (void)awakeFromNib 
{
    self.mode = CVCellAccessoryButtonModeDefault;
    [super awakeFromNib];
}

- (void)setMode:(CVCellAccessoryButtonMode)newMode 
{
    _mode = newMode;
    
    UIImageView *buttonImage = (UIImageView *)[[self subviews] lastObject];
    if (_mode == CVCellAccessoryButtonModeDefault) {
        buttonImage.image = _defaultImage;
        [buttonImage setFrame:CVRectResize(buttonImage.frame, _defaultImage.size)];
    }
    else if (_mode == CVCellAccessoryButtonModeDelete) {
        buttonImage.image = _deleteImage;
        [buttonImage setFrame:CVRectResize(buttonImage.frame, _deleteImage.size)];
    }
}

- (void)setDefaultImage:(UIImage *)newDefaultImage 
{
    
    _defaultImage = newDefaultImage;
    
    self.mode = _mode;
}

- (void)setDeleteImage:(UIImage *)newDeleteImage 
{
    _deleteImage = newDeleteImage;
    
    self.mode = _mode;
}

- (void)toggleMode 
{
    if (self.mode == CVCellAccessoryButtonModeDefault) {
        self.mode = CVCellAccessoryButtonModeDelete;
    } else {
        self.mode = CVCellAccessoryButtonModeDefault;
    }
}

@end
