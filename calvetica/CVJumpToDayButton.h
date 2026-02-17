//
//  CVDayButton_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UILabel+Utilities.h"
#import "CVTodayBoxView.h"
#import "CVColoredDotView.h"

NS_ASSUME_NONNULL_BEGIN


@interface CVJumpToDayButton : UIView

#pragma mark - Properties
@property (nonatomic, strong) NSDate         *date;
@property (nonatomic        ) BOOL           isToday;
@property (nonatomic        ) BOOL           isRootViewController;
@property (nonatomic        ) BOOL           isSelected;
@property (nonatomic, strong) CVTodayBoxView *todayBoxView;

#pragma mark - IBOutlets
@property (nonatomic, nullable, weak) IBOutlet UILabel     *label;
@property (nonatomic, nullable, weak) IBOutlet UILabel     *monthTitleLabel;
@property (nonatomic, nullable, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, nullable, weak) IBOutlet UIView      *barViewContainer;
@property (nonatomic, nullable, weak) IBOutlet UIView      *dotViewContainer;

#pragma mark - Methods
- (void)drawDotWithOffset:(NSUInteger)offset shape:(CVColoredShape)shape rect:(CGRect)rect color:(UIColor *)color;
- (void)clearDots;

@end

NS_ASSUME_NONNULL_END
