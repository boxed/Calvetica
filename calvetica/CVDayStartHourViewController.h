//
//  CVDayStartHourViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@protocol CVDayStartEndHoursViewControllerDelegate;


@interface CVDayStartHourViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, nullable, weak) id<CVDayStartEndHoursViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<NSNumber *>                               *hoursArray;


#pragma mark - Public Methods


#pragma mark - Notifications


@end

NS_ASSUME_NONNULL_END