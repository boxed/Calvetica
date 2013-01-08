//
//  CVToggleButton.h
//  calvetica
//
//  Created by Adam Kirk on 6/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVButton.h"
#import "CVColoredDotView.h"
#import "geometry.h"

@interface CVImageToggleButton : CVButton

@property (nonatomic, weak) IBOutlet CVColoredDotView *coloredShape;
@property (nonatomic) CVColoredShape shape;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak, readonly) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIColor *shapeColorSelected;
@property (nonatomic, strong) UIColor *shapeColorUnselected;

@end
