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

@interface CVDayButton_iPhone : UIView

#pragma mark - Properties
@property (nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL isRootViewController;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, strong) CVTodayBoxView *todayBoxView;

#pragma mark - IBOutlets
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UILabel *monthTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIView *barViewContainer;
@property (nonatomic, strong) IBOutlet UIView *dotViewContainer;

#pragma mark - Methods
- (void)drawDotWithOffset:(NSUInteger)offset shape:(CVColoredShape)shape rect:(CGRect)rect color:(UIColor *)color;
- (void)clearDots;

@end
