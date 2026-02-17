//
//  CVManageCalendarsViewController_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVManageCalendarsViewController.h"
#import "CVCalendarCellModel.h"


@implementation CVManageCalendarsViewController

- (void)dealloc
{
    self.tableView.delegate     = nil;
    self.tableView.dataSource   = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellDataHolderArray = [NSMutableArray array];
        [self loadCellDataHolderArray];
    }
    return self;
}

- (void)viewDidLoad
{
    self.controllerTitle.text = @"SHOW EVENT CALENDARS";
}




#pragma mark - Actions

- (IBAction)saveButtonWasTapped:(id)sender
{
    if (self.modified) {
        for (CVCalendarCellModel *holder in self.cellDataHolderArray) {
            if (holder.isSelected) {
                holder.calendar.hidden = NO;
            }
            else {
                holder.calendar.hidden = YES;
            }
        }
    }

    CVManageCalendarsResult result = self.modified ? CVManageCalendarsResultModified : CVManageCalendarsResultCancelled;

    [self.delegate manageCalendarsViewController:self didFinishWithResult:result];
}

- (IBAction)cancelButtonWasTapped:(id)sender
{
    [self.delegate manageCalendarsViewController:self didFinishWithResult:CVManageCalendarsResultCancelled];
}



#pragma mark - Private

- (void)loadCellDataHolderArray
{
    NSArray *calendars = [[EKEventStore sharedStore] eventCalendars];
    //sort the calendars
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                 ascending:YES
                                                  selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor];
    calendars = [calendars sortedArrayUsingDescriptors:sortDescriptors];

    for (EKCalendar *cal in calendars) {
        CVCalendarCellModel *holder = [[CVCalendarCellModel alloc] init];
        holder.calendar = cal;
        if (!cal.isHidden) {
            holder.isSelected = YES;
        }
        else {
            holder.isSelected = NO;
        }
        [self.cellDataHolderArray addObject:holder];
    }
}










#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVManageCalendarTableViewCell *cell = [CVManageCalendarTableViewCell cellForTableView:tv];
    CVCalendarCellModel *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];

    cell.calendarTitleLabel.text = holder.calendar.title;
    cell.calendarTypeLabel.text = holder.calendar.source.title;
    cell.coloredDotView.color = [holder.calendar customColor];

    if (holder.isSelected) {
        cell.checkmarkImageView.image = [UIImage imageNamed:@"icon_calendar_on"];
    }
    else {
        cell.checkmarkImageView.image = [UIImage imageNamed:@"icon_calendar_off"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CVManageCalendarTableViewCell *cell = (CVManageCalendarTableViewCell *)[tv cellForRowAtIndexPath:indexPath];
    CVCalendarCellModel *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];
    
    if (holder.isSelected) {
        holder.isSelected = NO;
        cell.checkmarkImageView.image = [UIImage imageNamed:@"icon_calendar_off"];
    }
    else {
        holder.isSelected = YES;
        cell.checkmarkImageView.image = [UIImage imageNamed:@"icon_calendar_on"];
    }
    self.modified = YES;
}




#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched
{
	[self cancelButtonWasTapped:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
