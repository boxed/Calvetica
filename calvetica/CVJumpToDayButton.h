//
//  CVDayButton_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UILabel+Utilities.h"
#import "CVEventStore.h"
#import "CVTodayBoxView.h"
#import "CVColoredDotView.h"

@interface CVJumpToDayButton : UIView

#pragma mark - Properties
@property (nonatomic, strong) NSDate         *date;
@property (nonatomic        ) BOOL           isToday;
@property (nonatomic        ) BOOL           isRootViewController;
@property (nonatomic        ) BOOL           isSelected;
@property (nonatomic, strong) CVTodayBoxView *todayBoxView;

#pragma mark - IBOutlets
@property (nonatomic, weak) IBOutlet UILabel     *label;
@property (nonatomic, weak) IBOutlet UILabel     *monthTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIView      *barViewContainer;
@property (nonatomic, weak) IBOutlet UIView      *dotViewContainer;

#pragma mark - Methods
- (void)drawDotWithOffset:(NSUInteger)offset shape:(CVColoredShape)shape rect:(CGRect)rect color:(UIColor *)color;
- (void)clearDots;

@end
