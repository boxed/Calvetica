//
//  CVEventDefaultCalendarViewController.m
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDefaultCalendarViewController.h"




@implementation CVEventDefaultCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Enable dark mode support
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;

	//sort the calendars
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
												 ascending:YES
												  selector:@selector(localizedCaseInsensitiveCompare:)];
	NSArray *sortDescriptors = @[sortDescriptor];
	_availableCalendars = [[[EKEventStore sharedStore] eventCalendars] sortedArrayUsingDescriptors:sortDescriptors];
	
	_availableCalendars = [_availableCalendars filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKCalendar *calendar, NSDictionary *bindings) {
		return calendar.allowsContentModifications ? YES : NO;
	}]];
	
    self.navigationItem.title = NSLocalizedString(@"Event Default Calendar", @"Navigation item to select from a list of calendars");
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _availableCalendars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell           = [UITableViewCell cellWithStyle:UITableViewCellStyleSubtitle forTableView:tableView];
    cell.textLabel.font             = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor        = UIColor.labelColor;
    cell.detailTextLabel.font       = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor  = UIColor.secondaryLabelColor;
    cell.backgroundColor            = UIColor.secondarySystemGroupedBackgroundColor;

    EKCalendar *calendar = [self.availableCalendars objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = calendar.title;
    cell.detailTextLabel.text = calendar.accountName;
    
    if ([calendar.title isEqualToString:PREFS.defaultEventCalendarIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}




#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Available Event Calendars", @"The title of the header of a table with default calendars");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Check to select default event calendar", @"The footer in a table that gives instructions to the user");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    EKCalendar *calendar = [_availableCalendars objectAtIndex: indexPath.row];
    PREFS.defaultEventCalendarIdentifier = calendar.title;
    [tableView reloadData];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
