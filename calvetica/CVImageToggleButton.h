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

NS_ASSUME_NONNULL_BEGIN


@interface CVImageToggleButton : CVButton

@property (nonatomic, nullable, weak            ) IBOutlet CVColoredDotView *coloredShape;
@property (nonatomic                  )          CVColoredShape   shape;
@property (nonatomic, strong          )          UIImage          *image;
@property (nonatomic, nullable, weak,   readonly) IBOutlet UILabel          *titleLabel;

@property (nonatomic, strong          )          UIColor          *shapeColorSelected;
@property (nonatomic, strong          )          UIColor          *shapeColorUnselected;

@end

NS_ASSUME_NONNULL_END
