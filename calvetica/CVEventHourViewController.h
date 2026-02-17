//
//  CVEventHourViewController.h
//  calvetica
//
//  Created by Adam Kirk on 5/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "colors.h"
#import "CVSelectionTableViewCell.h"
#import "CVViewButton.h"
#import "viewtagoffsets.h"
#import "CVViewController.h"


typedef NS_ENUM(NSUInteger, CVEventHourViewControllerMode) {
    CVEventHourViewControllerModeStartTime,
    CVEventHourViewControllerModeEndTime,
    CVEventHourViewControllerModeAllDay
};


@interface CVEventHourViewController : CVViewController

@property (nonatomic        ) BOOL   allDay;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic        ) BOOL   militaryTime;
@property (nonatomic        ) BOOL   editable;

@property (copy, nonatomic)	void (^startDateUpdatedBlock)(NSDate *date);
@property (copy, nonatomic)	void (^endDateUpdatedBlock)(NSDate *date);
@property (copy, nonatomic)	void (^allDayUpdatedBlock)(BOOL allDay);

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay useMilitaryTime:(BOOL)military;

@end
