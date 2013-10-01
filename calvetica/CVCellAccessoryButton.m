//
//  CVCellAccessoryButton.m
//  calvetica
//
//  Created by Adam Kirk on 5/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCellAccessoryButton.h"
#import "CVDeleteButton.h"


@implementation CVCellAccessoryButton

- (void)awakeFromNib 
{
    self.mode = CVCellAccessoryButtonModeDefault;
    [super awakeFromNib];
}

- (void)setMode:(CVCellAccessoryButtonMode)newMode 
{
    _mode = newMode;

    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }

    UIView *v;
    if (_mode == CVCellAccessoryButtonModeDefault) {
        UIImageView *buttonImage = [[UIImageView alloc] initWithImage:_defaultImage];
        v = buttonImage;
    }
    else if (_mode == CVCellAccessoryButtonModeDelete) {
        CVDeleteButton *button = [[CVDeleteButton alloc] initWithFrame:CGRectMake(0, 0, 45, 35)];
        button.backgroundColor = RGBHex(0xCC0000);
        button.userInteractionEnabled = NO;
        v = button;
    }

    v.x = (self.width / 2) - (v.height / 2) - 1;
    v.y = (self.height / 2) - (v.height / 2) - 1;
    [self addSubview:v];
}

- (void)setDefaultImage:(UIImage *)newDefaultImage 
{
    _defaultImage = newDefaultImage;
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
