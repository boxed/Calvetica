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
@property (nonatomic, weak  ) IBOutlet UISlider *slider;
@property (nonatomic, weak  ) IBOutlet UILabel  *titleLabel;
@property (nonatomic, strong)          UIImage  *thumbImage;

- (void)resetSlider;
- (IBAction)sliderMoved:(id)sender;
- (IBAction)sliderEnded:(id)sender;

@end
