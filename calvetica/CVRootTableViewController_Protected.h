//
//  CVRootTableViewController_Private.h
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import "CVRootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CVCalendarItemCellModel;

@interface CVRootTableViewController ()
@property (nonatomic, strong) NSMutableArray<CVCalendarItemCellModel *> *cellModelArray;
@end

NS_ASSUME_NONNULL_END
