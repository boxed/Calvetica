//
//  CVCellDataHolder.h
//  calvetica
//
//  Created by Adam Kirk on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDataHolder.h"
#import "CVEventCell.h"


@interface CVEventCellDataHolder : CVDataHolder

#pragma mark - Properties
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) id cell;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic) BOOL continuedFromPreviousDay;
@property (nonatomic) CGFloat durationBarPercent;
@property (nonatomic, strong) UIColor *durationBarColor;
@property (nonatomic) CGFloat secondaryDurationBarPercent;
@property (nonatomic, strong) UIColor *secondaryDurationBarColor;

@end