//
//  CVEventsAgendaTableViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventCell.h"
#import "CVRootTableViewController.h"


@interface CVEventsAgendaTableViewController : CVRootTableViewController {
}


#pragma mark - Properties
@property (nonatomic, weak) id<CVEventCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@property (nonatomic, strong) UINib *eventCellNib;


#pragma mark - Methods


#pragma mark - IBActions


@end