//
//  CVSlideLockControl.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "colors.h"

NS_ASSUME_NONNULL_BEGIN


@interface CVSlideLockControl : UIControl

// Use these for accessing UIElements
@property (nonatomic, nullable, weak  ) IBOutlet UISlider *slider;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel  *titleLabel;
@property (nonatomic, strong)          UIImage  *thumbImage;

- (void)resetSlider;
- (IBAction)sliderMoved:(id)sender;
- (IBAction)sliderEnded:(id)sender;

@end

NS_ASSUME_NONNULL_END
