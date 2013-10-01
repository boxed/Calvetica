//
//  CVRemindersWeekAgendaTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaReminderCell.h"
#import "CVFriendlyCellDataHolder.h"
#import "CVWeekNumberCell.h"
#import "CVWeekNumberHolder.h"
#import "CVRootTableViewController.h"
#import "NSArray+Utilities.h"
#import "NSString+Utilities.h"

@interface CVRemindersWeekAgendaTableViewController : CVRootTableViewController {
}


#pragma mark - Properties
@property (nonatomic, weak) id<CVAgendaReminderCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@property (nonatomic, strong) UINib *reminderCellNib;
@property (nonatomic, strong) UINib *dayTitleCellNib;
@property (nonatomic, strong) UINib *friendlyCellNib;
@property (nonatomic, strong) UINib *weekNumberCellNib;


#pragma mark - Methods


#pragma mark - IBActions


@end