//
//  CVEventHourViewController.h
//  calvetica
//
//  Created by Adam Kirk on 5/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "colors.h"
#import "EKEvent+Utilities.h"
#import "CVSelectionTableViewCell_iPhone.h"
#import "CVViewButton.h"
#import "viewtagoffsets.h"
#import "CVViewController.h"

typedef enum {
    CVEventHourViewControllerModeStartTime,
    CVEventHourViewControllerModeEndTime,
    CVEventHourViewControllerModeAllDay
} CVEventHourViewControllerMode;


@interface CVEventHourViewController_iPhone : CVViewController

@property (nonatomic)			BOOL			allDay;
@property (nonatomic, copy)		NSDate			*startDate;
@property (nonatomic, copy)		NSDate			*endDate;
@property (nonatomic)			BOOL			militaryTime;
@property (nonatomic)			BOOL			editable;
@property (nonatomic)			BOOL			reminderUI;

@property (strong, nonatomic)	void (^startDateUpdatedBlock)(NSDate *date);
@property (strong, nonatomic)	void (^endDateUpdatedBlock)(NSDate *date);
@property (strong, nonatomic)	void (^allDayUpdatedBlock)(BOOL allDay);

- (id)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay useMilitaryTime:(BOOL)military;

@end
