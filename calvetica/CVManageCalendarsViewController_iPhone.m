//
//  CVManageCalendarsViewController_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/14/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVManageCalendarsViewController_iPhone.h"




@interface CVManageCalendarsViewController_iPhone ()
@property (nonatomic, strong) UINib *calendarCellNib;
@end




@implementation CVManageCalendarsViewController_iPhone

- (void)dealloc
{
    self.tableView.delegate     = nil;
    self.tableView.dataSource   = nil;
}

- (id)initWithMode:(CVManageCalendarsViewMode)viewMode
{
    self = [super init];
    if (self) {
        _mode = viewMode;
        self.cellDataHolderArray = [NSMutableArray array];
        [self loadCellDataHolderArray];
    }
    return self;
}

- (UINib *)calendarCellNib 
{
    if (_calendarCellNib == nil) {
        self.calendarCellNib = [CVManageCalendarTableViewCell_iPhone nib];
    }
    return _calendarCellNib;    
}

- (void)viewDidLoad 
{
    if (self.mode == CVManageCalendarsViewModeEvents) {
        self.controllerTitle.text = @"SHOW EVENT CALENDARS";
    }
    else if (self.mode == CVManageCalendarsViewModeReminders) {
        self.controllerTitle.text = @"SHOW REMINDER CALENDARS";
    }
}


#pragma mark - Actions

- (IBAction)saveButtonWasTapped:(id)sender
{
    if (self.modified) {
        NSMutableArray *newSelectedArray = [NSMutableArray array];
        if (self.mode == CVManageCalendarsViewModeEvents) {
            for (CVCalendarReminderCalendarCellDataHolder *holder in self.cellDataHolderArray) {
                if (holder.isSelected) {
                    [newSelectedArray addObject:holder.calendar];
                }
            }
            [CVSettings setSelectedEventCalendars:newSelectedArray];
        }
        else if (self.mode == CVManageCalendarsViewModeReminders) {
            for (CVCalendarReminderCalendarCellDataHolder *holder in self.cellDataHolderArray) {
                if (holder.isSelected) {
                    [newSelectedArray addObject:holder.calendar];
                }
            }
            [CVSettings setSelectedReminderCalendars:newSelectedArray];
        }
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

    if (_mode == CVManageCalendarsViewModeEvents) {
        NSArray *calendars = [CVEventStore eventCalendars];
        //sort the calendars
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                     ascending:YES
                                                      selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *sortDescriptors = @[sortDescriptor];
        calendars = [calendars sortedArrayUsingDescriptors:sortDescriptors];

        for (EKCalendar *cal in calendars) {
            CVCalendarReminderCalendarCellDataHolder *holder = [[CVCalendarReminderCalendarCellDataHolder alloc] init];
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
    else if (_mode == CVManageCalendarsViewModeReminders) {

        NSArray *calendars = [CVEventStore reminderCalendars];
        if (calendars.count < 1) {
            EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:[CVEventStore sharedStore].eventStore];
            calendars = @[calendar];
        }

        for (EKCalendar *calendar in calendars) {
            CVCalendarReminderCalendarCellDataHolder *holder = [[CVCalendarReminderCalendarCellDataHolder alloc] init];
            holder.calendar = calendar;
            if ([calendar isASelectedCalendar]) {
                holder.isSelected = YES;
            }
            else {
                holder.isSelected = NO;
            }
            [self.cellDataHolderArray addObject:holder];
        }
    }
}










#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
    return self.cellDataHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    CVManageCalendarTableViewCell_iPhone *cell = [CVManageCalendarTableViewCell_iPhone cellForTableView:tv fromNib:self.calendarCellNib];
    CVCalendarReminderCalendarCellDataHolder *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];
    
    if (self.mode == CVManageCalendarsViewModeEvents) {
        cell.calendarTitleLabel.text = holder.calendar.title;
        cell.calendarTypeLabel.text = holder.calendar.source.title;
        cell.coloredDotView.color = [holder.calendar customColor];
        
        if (holder.isSelected) {
            cell.checkmarkImageView.image = [UIImage imageNamed:@"icon_calendar_on"];
        }
        else {
            cell.checkmarkImageView.image = [UIImage imageNamed:@"icon_calendar_off"];
        }
    }
    else if (self.mode == CVManageCalendarsViewModeReminders) {
        cell.calendarTitleLabel.text = holder.calendar.title;
		cell.calendarTypeLabel.text = @"LOCAL";
        cell.coloredDotView.color = [holder.calendar customColor];
        
        if (holder.isSelected) {
            cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_open"];
        }
        else {
            cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_closed"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVManageCalendarTableViewCell_iPhone *cell = (CVManageCalendarTableViewCell_iPhone *)[tv cellForRowAtIndexPath:indexPath];
    CVCalendarReminderCalendarCellDataHolder *holder = [self.cellDataHolderArray objectAtIndex:indexPath.row];
    
    if (self.mode == CVManageCalendarsViewModeEvents) {
        if (holder.isSelected) {
            holder.isSelected = NO;
            cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_closed"];
//            if ([holder.calendar isEqual:[CVSettings defaultEventCalendar]]) {
//                // throw up an alert
//                CVActionBlockButton *button = [CVActionBlockButton buttonWithTitle:@"OK" andActionBlock:^(void){}];
//                [UIApplication showAlertWithTitle:@"I'm sorry" message:@"Unable to hide default calendar" buttons:[NSArray arrayWithObject:button]];
//            }
//            else {
//                holder.isSelected = NO;
//                cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_closed"];
//            }
        }
        else {
            holder.isSelected = YES;
            cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_open"];
        }
    }
    else if (self.mode == CVManageCalendarsViewModeReminders) {
        if (holder.isSelected) {
            holder.isSelected = NO;
            cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_closed"];
//            if ([holder.calendar.UUID isEqualToString:[CVSettings defaultReminderCalendar].UUID]) {
//                // throw up an alert
//                CVActionBlockButton *button = [CVActionBlockButton buttonWithTitle:@"OK" andActionBlock:^(void){}];
//                [UIApplication showAlertWithTitle:@"I'm sorry" message:@"Unable to hide default reminder calendar" buttons:[NSArray arrayWithObject:button]];
//            }
//            else {
//                holder.isSelected = NO;
//                cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_closed"];
//            }
        }
        else {
            holder.isSelected = YES;
            cell.checkmarkImageView.image = [UIImage imageNamed:@"eye_open"];
        }
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
