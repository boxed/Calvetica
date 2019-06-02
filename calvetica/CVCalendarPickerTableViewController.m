//
//  CVEventDetailsCalendarTableViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 5/11/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarPickerTableViewController.h"


@implementation CVCalendarPickerTableViewController

- (id)init 
{
    self = [super init];
    if (self) {
		_showUneditableCalendars = YES;
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (NSArray *)calendars
{
	if (!_editableCalendars || !_allCalendars) {
        //sort the calendars
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                     ascending:YES
                                                      selector:@selector(localizedCaseInsensitiveCompare:)];  
        NSArray *sortDescriptors = @[sortDescriptor];
        
		_editableCalendars = [[[EKEventStore sharedStore] editableCalendarsForEntityType:EKEntityTypeEvent] sortedArrayUsingDescriptors:sortDescriptors];
		_allCalendars = [[EKEventStore sharedStore] eventCalendars];
		_allCalendars = [_allCalendars  sortedArrayUsingDescriptors:sortDescriptors];
	}
	return _showUneditableCalendars ? _allCalendars : _editableCalendars;
}

- (void)setSelectedCalendar:(EKCalendar *)calendar 
{
	for (EKCalendar *c in [self calendars]) {
		if ([c.calendarIdentifier isEqualToString:calendar.calendarIdentifier]) {
			NSIndexPath *ip = [NSIndexPath indexPathForRow:[[self calendars] indexOfObject:c] inSection:0];
            if (self.tableView.scrollEnabled) {
                [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            } 
            else {
                [self.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
			return;
		}
	}
}

- (void)setShowUneditableCalendars:(BOOL)newShowUneditableCalendars 
{
	_showUneditableCalendars = newShowUneditableCalendars;
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self calendars].count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVCalendarTableViewCell *cell = [CVCalendarTableViewCell cellForTableView:tv];
	
    EKCalendar *calendar            = [[self calendars] objectAtIndex:indexPath.row];
    cell.calendarTitleLabel.text    = calendar.title;
    cell.disabled                   = !calendar.allowsContentModifications;
    cell.calendarTypeLabel.text     = calendar.accountName;
    cell.coloredDotView.color       = [calendar customColor];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	CVCalendarTableViewCell *cell = (CVCalendarTableViewCell *)[tv cellForRowAtIndexPath:indexPath];
	if (cell.disabled) return;
    EKCalendar *calendar = [[self calendars] objectAtIndex:indexPath.row];
    [_delegate calendarPicker:self didPickCalendar:calendar];
}

@end
