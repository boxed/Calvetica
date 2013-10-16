//
//  CVManageCalendarsViewController_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVManageCalendarsViewController_iPhone.h"
#import "CVCalendarCellDataHolder.h"


@implementation CVManageCalendarsViewController_iPhone

- (void)dealloc
{
    self.tableView.delegate     = nil;
    self.tableView.dataSource   = nil;
}

- (id)init
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
        NSMutableArray *newSelectedArray = [NSMutableArray array];
        for (CVCalendarCellDataHolder *holder in self.cellDataHolderArray) {
            if (holder.isSelected) {
                [newSelectedArray addObject:holder.calendar];
            }
        }
        [CVSettings setSelectedEventCalendars:newSelectedArray];
    }

    CVManageCalendarsResult result = self.modified ? CVManageCalendarsResultModified : CVManageCalendarsResultCancelled;

    [self.delegate manageCalendarsViewController:self didFinishWithResult:result];
}

- (IBAction)cancelButtonWasTapped:(id)sender
{
    [self.delegate manageCalendarsViewController:self didFinishWithResult:CVManageCalendarsResultCancelled];
}



#pragma mark - Private Methods

- (void)loadCellDataHolderArray
{
    NSArray *calendars = [EKEventStore eventCalendars];
    //sort the calendars
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                 ascending:YES
                                                  selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = @[sortDescriptor];
    calendars = [calendars sortedArrayUsingDescriptors:sortDescriptors];

    for (EKCalendar *cal in calendars) {
        CVCalendarCellDataHolder *holder = [[CVCalendarCellDataHolder alloc] init];
        holder.calendar = cal;
        if ([cal isASelectedCalendar]) {
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
    CVManageCalendarTableViewCell_iPhone *cell = [CVManageCalendarTableViewCell_iPhone cellForTableView:tv];
    CVCalendarCellDataHolder *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];

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
    CVManageCalendarTableViewCell_iPhone *cell = (CVManageCalendarTableViewCell_iPhone *)[tv cellForRowAtIndexPath:indexPath];
    CVCalendarCellDataHolder *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];
    
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
