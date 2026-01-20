//
//  CVSlideLockControl.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVSlideLockControl.h"
#import "colors.h"




@implementation CVSlideLockControl

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = slideToDeleteBackgroundColor();

    if (!self.thumbImage) {
        [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    }

    // set the slider background images
    UIImage *image = [[UIImage imageNamed:@"slider_background"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:0.0];

    [self.slider setMinimumTrackImage:image forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:image forState:UIControlStateNormal];

    // set up the rounded corners
    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
}

- (void)setThumbImage:(UIImage *)image 
{
    if (image) {
        _thumbImage = image;
        [self.slider setThumbImage:self.thumbImage forState:UIControlStateNormal];
    }
}

- (void)sliderEnded:(id)sender 
{
    if (_slider.value == 1) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self resetSlider];
    }
}

- (void)sliderMoved:(id)sender 
{
    self.titleLabel.alpha = fabs(self.slider.value - 1);
}

- (void)resetSlider 
{
    [self.slider setValue:0 animated:YES];
    self.titleLabel.alpha = 1.0;
}

@end
