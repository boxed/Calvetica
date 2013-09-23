//
//  CVManageCalendarsViewController_iPhone.h
//  calvetica
//
//  Created by James Schultz on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


#import "CVManageCalendarTableViewCell_iPhone.h"
#import "CVEventStore.h"
#import "EKCalendar+Utilities.h"
#import "UIApplication+Utilities.h"
#import "CVCalendarReminderCalendarCellDataHolder.h"
#import "CVDebug.h"
#import "CVViewController.h"
#import "CVModalProtocol.h"
#import "CVEventStore.h"
#import "CVCalendarReminderCalendarCellDataHolder.h"


typedef enum {
    CVManageCalendarsResultClosed,
    CVManageCalendarsResultModified,
    CVManageCalendarsResultCancelled
} CVManageCalendarsResult;

typedef enum {
    CVManageCalendarsViewModeEvents,
    CVManageCalendarsViewModeReminders
} CVManageCalendarsViewMode;


@protocol CVManageCalendarsViewControllerDelegate;



@interface CVManageCalendarsViewController_iPhone : CVViewController <CVModalProtocol, UITableViewDelegate, UITableViewDataSource> {}

@property (nonatomic, unsafe_unretained) id<CVManageCalendarsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cellDataHolderArray;
@property CVManageCalendarsViewMode mode;
@property BOOL modified;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *controllerTitle;

- (id)initWithMode:(CVManageCalendarsViewMode)viewMode;
- (IBAction)cancelButtonWasTapped:(id)sender;

@end




@protocol CVManageCalendarsViewControllerDelegate <NSObject>
- (void)manageCalendarsViewController:(CVManageCalendarsViewController_iPhone *)controller didFinishWithResult:(CVManageCalendarsResult)result;
@end