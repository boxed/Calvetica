//
//  CVDayStartHourViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@protocol CVDayStartEndHoursViewControllerDelegate;


@interface CVDayStartHourViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, weak) id<CVDayStartEndHoursViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray                               *hoursArray;


#pragma mark - Public Methods


#pragma mark - Notifications


@end
