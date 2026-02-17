//
//  CVAlarmPickerPopout_iPhone.h
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CVStatefulToggleButton.h"
#import "CVToggleButton.h"
#import "CVModalProtocol.h"
#import "CVEventCell.h"
#import "times.h"
#import "geometry.h"
#import "CVViewController.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM (NSUInteger, CVAlarmPickerResult) {
    CVAlarmPickerResultCancelled,
    CVAlarmPickerResultChanged
};


@protocol CVAlarmPickerViewControllerDelegate;


@interface CVAlarmPickerViewController : CVViewController <CVModalProtocol>

@property (nonatomic, nullable, weak  ) id<CVAlarmPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) EKCalendarItem                          *calendarItem;

- (NSArray *)alarms;

@end




@protocol CVAlarmPickerViewControllerDelegate <NSObject>
- (void)alarmPicker:(CVAlarmPickerViewController *)picker didFinishWithResult:(CVAlarmPickerResult)result;
@end





// protected
@interface CVAlarmPickerViewController ()
@property (nonatomic, strong) NSMutableArray *buttons;
@end

NS_ASSUME_NONNULL_END


