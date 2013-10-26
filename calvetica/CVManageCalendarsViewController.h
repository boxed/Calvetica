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


typedef NS_ENUM(NSUInteger, CVManageCalendarsResult) {
    CVManageCalendarsResultClosed,
    CVManageCalendarsResultModified,
    CVManageCalendarsResultCancelled
};


@protocol CVManageCalendarsViewControllerDelegate;


@interface CVManageCalendarsViewController : CVViewController <CVModalProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak  )          id<CVManageCalendarsViewControllerDelegate> delegate;
@property (nonatomic, strong)          NSMutableArray                              *cellDataHolderArray;
@property (nonatomic, assign)          BOOL                                        modified;

@property (nonatomic, weak  ) IBOutlet UITableView                                 *tableView;
@property (nonatomic, weak  ) IBOutlet UILabel                                     *controllerTitle;

- (IBAction)cancelButtonWasTapped:(id)sender;

@end




@protocol CVManageCalendarsViewControllerDelegate <NSObject>
- (void)manageCalendarsViewController:(CVManageCalendarsViewController *)controller didFinishWithResult:(CVManageCalendarsResult)result;
@end