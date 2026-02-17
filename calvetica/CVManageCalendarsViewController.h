//
//  CVManageCalendarsViewController_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVManageCalendarTableViewCell.h"
#import "UIApplication+Utilities.h"
#import "CVDebug.h"
#import "CVViewController.h"
#import "CVModalProtocol.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, CVManageCalendarsResult) {
    CVManageCalendarsResultClosed,
    CVManageCalendarsResultModified,
    CVManageCalendarsResultCancelled
};


@class CVCalendarCellModel;
@protocol CVManageCalendarsViewControllerDelegate;


@interface CVManageCalendarsViewController : CVViewController <CVModalProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, nullable, weak  )          id<CVManageCalendarsViewControllerDelegate> delegate;
@property (nonatomic, strong)          NSMutableArray<CVCalendarCellModel *>                              *cellDataHolderArray;
@property (nonatomic, assign)          BOOL                                        modified;

@property (nonatomic, nullable, weak  ) IBOutlet UITableView                                 *tableView;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                                     *controllerTitle;

- (IBAction)cancelButtonWasTapped:(id)sender;

@end




@protocol CVManageCalendarsViewControllerDelegate <NSObject>
- (void)manageCalendarsViewController:(CVManageCalendarsViewController *)controller didFinishWithResult:(CVManageCalendarsResult)result;
@end

NS_ASSUME_NONNULL_END