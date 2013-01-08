//
//  CVReminderDefaultCalendarViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderDefaultCalendarViewController.h"
#import "CVEventStore.h"




@implementation CVReminderDefaultCalendarViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Reminder Default Calendar", @"Navigation item to select from a list of reminder calendars");
    
    _availableCalendars = [CVEventStore reminderCalendars];
    if (_availableCalendars.count < 1) {
		EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:[CVEventStore sharedStore].eventStore];
        _availableCalendars = @[calendar];
		_availableCalendars = [_availableCalendars filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKCalendar *calendar, NSDictionary *bindings) {
			return calendar.allowsContentModifications ? YES : NO;
		}]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.availableCalendars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleSubtitle forTableView:tableView];

    EKCalendar *calendar = [self.availableCalendars objectAtIndex:indexPath.row];
    
    cell.selectionStyle			= UITableViewCellSelectionStyleNone;
    cell.textLabel.text			= calendar.title;
    cell.detailTextLabel.text	= [NSString stringWithFormat:@"%@", [calendar account]];

    if ([calendar.calendarIdentifier isEqualToString:[CVSettings defaultReminderCalendar].calendarIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    EKCalendar *calendar = [self.availableCalendars objectAtIndex:indexPath.row];
    [CVSettings setDefaultReminderCalendar:calendar];
    
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Available Reminder Calendars", @"The title of the header of a table with default calendars");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.availableCalendars.count > 0) {
        return NSLocalizedString(@"Check to select default reminder calendar", @"The footer in a table that gives instructions to the user");
    }
    else {
       return NSLocalizedString(@"Oops it looks like you haven't added any reminder calendars yet", @"The footer in a table that gives instructions to the user"); 
    }
}


- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
