//
//  CVSlideLockControl.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "colors.h"

@interface CVSlideLockControl : UIControl

// Use these for accessing UIElements
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UIImage *thumbImage;

- (void)resetSlider;
- (IBAction)sliderMoved:(id)sender;
- (IBAction)sliderEnded:(id)sender;

@end
