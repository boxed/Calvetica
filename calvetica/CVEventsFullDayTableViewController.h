//
//  CVEventsFullDayTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootTableViewController.h"
#import "CVEventCell.h"
#import "colors.h"
#import "CVDebug.h"


@interface CVEventsFullDayTableViewController : CVRootTableViewController {
}


#pragma mark - Properties
@property (nonatomic, weak  ) id<CVEventCellDelegate> delegate;
@property (nonatomic, strong  ) NSMutableArray          *cellDataHolderArray;
@property (nonatomic, strong) UINib                   *eventCellNib;


#pragma mark - Methods
- (void)calculateDurationBars;


#pragma mark - IBActions


@end
