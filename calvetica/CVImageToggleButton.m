//
//  CVToggleButton.m
//  calvetica
//
//  Created by Adam Kirk on 6/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVImageToggleButton.h"


@implementation CVImageToggleButton

@synthesize titleLabel = _titleLabel;

- (void)setup 
{
    [super setup];
    self.selectable = YES;
}

- (void)setImage:(UIImage *)newImage 
{
    _image = newImage;
    
    if (!_image) return;
    
    // hide the shape
    self.coloredShape.hidden = YES;
    
    // show image view
    self.imageView.hidden = NO;
    
    // resize and image view
    CGSize imageSize = _image.size;
    [self.imageView setFrame:CVRectResize(self.imageView.frame, imageSize)];
    
    // assign image to image view
    self.imageView.image = _image;
}

- (void)setShape:(CVColoredShape)newShape 
{
    _shape = newShape;
    
    // hide image view
    self.imageView.hidden = YES;
    self.imageView.image = nil;
    
    // show colored dot
    _coloredShape.hidden = NO;
    
    // set the shape
    _coloredShape.shape = _shape;
}

- (void)setSelected:(BOOL)newSelected 
{
    super.selected = newSelected;
    
    if (newSelected) {
        _coloredShape.color = _shapeColorSelected;
    }
    else {
        _coloredShape.color = _shapeColorUnselected;        
    }
}

@end
