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

	//sort the calendars
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
												 ascending:YES
												  selector:@selector(localizedCaseInsensitiveCompare:)];
	NSArray *sortDescriptors = @[sortDescriptor];
	_availableCalendars = [[EKEventStore eventCalendars] sortedArrayUsingDescriptors:sortDescriptors];
	
	_availableCalendars = [_availableCalendars filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKCalendar *calendar, NSDictionary *bindings) {
		return calendar.allowsContentModifications ? YES : NO;
	}]];
	
    self.navigationItem.title = NSLocalizedString(@"Event Default Calendar", @"Navigation item to select from a list of calendars");
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
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
    cell.detailTextLabel.font       = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor  = [UIColor lightGrayColor];

    EKCalendar *calendar = [self.availableCalendars objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = calendar.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [calendar account]];
    
    if (calendar == [CVSettings defaultEventCalendar]) {
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
    [CVSettings setDefaultEventCalendar:calendar];
    
    [tableView reloadData];
}


- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
