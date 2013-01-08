//
//  CVEventsWeekAgendaTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaEventCell.h"
#import "CVDataHolder.h"
#import "CVFriendlyCellDataHolder.h"
#import "CVWeekNumberHolder.h"
#import "CVRootTableViewController.h"
#import "CVWeekNumberCell.h"
#import "NSArray+Utilities.h"
#import "NSString+Utilities.h"

// @todo: Duplicate code is everywhere inside the reminder and event view controllers. It needs to be combined.
@interface CVEventsWeekAgendaTableViewController : CVRootTableViewController {
}


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVAgendaEventCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@property (nonatomic, strong) UINib *eventCellNib;
@property (nonatomic, strong) UINib *dayTitleCellNib;
@property (nonatomic, strong) UINib *friendlyCellNib;
@property (nonatomic, strong) UINib *weekNumberCellNib;


#pragma mark - Methods

#pragma mark - IBActions


@end