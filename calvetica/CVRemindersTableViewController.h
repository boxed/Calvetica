//
//  CVRemindersTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderCell.h"
#import "CVRootTableViewController.h"


@interface CVRemindersTableViewController : CVRootTableViewController {
}


#pragma mark - Properties
@property (nonatomic, weak) id<CVReminderCellDelegate> delegate;
@property (nonatomic, strong) UINib *reminderCellNib;
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;


#pragma mark - Methods
- (void)loadTableView;


@end