//
//  CVEventsWeekStdAgendaTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventCell.h"
#import "CVRootTableViewController.h"
#import "CVTableSectionHeaderView.h"


@interface CVEventsWeekStdAgendaTableViewController : CVRootTableViewController {
}


#pragma mark - Properties
@property (nonatomic, weak  ) id<CVEventCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray          *cellDataHolderArray;
@property (nonatomic, copy  ) NSArray                 *daysOfWeekArray;
@property (nonatomic, strong) UINib                   *eventCellNib;
@property (nonatomic, strong) UINib                   *sectionHeaderNib;


#pragma mark - Methods


#pragma mark - IBActions


#pragma mark - Notifications


@end