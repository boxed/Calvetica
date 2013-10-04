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

@interface CVEventsWeekAgendaTableViewController : CVRootTableViewController
@property (nonatomic, weak  ) id<CVAgendaEventCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray                *cellDataHolderArray;
@property (nonatomic, strong) UINib                         *eventCellNib;
@property (nonatomic, strong) UINib                         *dayTitleCellNib;
@property (nonatomic, strong) UINib                         *friendlyCellNib;
@property (nonatomic, strong) UINib                         *weekNumberCellNib;
@end