//
//  CVRemindersWeekStdAgendaTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderCell.h"
#import "CVRootTableViewController.h"
#import "CVTableSectionHeaderView.h"


@interface CVRemindersWeekStdAgendaTableViewController : CVRootTableViewController

@property (nonatomic, weak) id<CVReminderCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@property (nonatomic, strong) NSArray *daysOfWeekArray;
@property (nonatomic, strong) UINib *reminderCellNib;
@property (nonatomic, strong) UINib *sectionHeaderNib;

@end