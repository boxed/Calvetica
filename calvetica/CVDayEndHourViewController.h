//
//  CVDayEndHourViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

@protocol CVDayEndHourViewControllerDelegate;


@interface CVDayEndHourViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, unsafe_unretained) id<CVDayEndHourViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *hoursArray;


#pragma mark - Public Methods


#pragma mark - Notifications


@end
