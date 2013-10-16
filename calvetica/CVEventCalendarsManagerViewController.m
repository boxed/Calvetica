//
//  CVCalendarsManagerViewController.m
//  calvetica
//
//  Created by James Schultz on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CVEventCalendarsManagerViewController.h"
#import "EKEventStore+Shared.h"
#import "EKSource+Calvetica.h"


@interface CVEventCalendarsManagerViewController ()
@property (nonatomic, copy) NSArray *calendarSources;
@end


@implementation CVEventCalendarsManagerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	_calendarSources = [EKEventStore calendarSources];

	self.tableView.allowsSelectionDuringEditing = YES;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                           target:self
                                                                                           action:@selector(editButtonPressed:)];
	self.title = @"Calendars";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}




#pragma mark - Actions

- (IBAction)editButtonPressed:(id)sender
{
	if (self.tableView.editing) {
		[self.tableView setEditing:NO animated:YES];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
	}
	else {
		[self.tableView setEditing:YES animated:YES];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonPressed:)];
	}
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _calendarSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    EKSource *source = [_calendarSources objectAtIndex:section];
    if (source.sourceType == EKSourceTypeBirthdays || source.sourceType == EKSourceTypeSubscribed) {
        return [source calendarsForEntityType:EKEntityTypeEvent].count;
    }
    else {
        return [source calendarsForEntityType:EKEntityTypeEvent].count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EKSource *source = [_calendarSources objectAtIndex:indexPath.section];
    NSArray *calendars = [[source calendarsForEntityType:EKEntityTypeEvent] allObjects];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarCell"];
	cell.imageView.image = [UIImage imageNamed:@"bg_clear_cell_image"];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.32 alpha:1];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.userInteractionEnabled = YES;
    cell.textLabel.font         = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];


    if (indexPath.row != calendars.count) {
		EKCalendar *cal = [calendars objectAtIndex:indexPath.row];

        cell.textLabel.text = cal.title;
		cell.imageView.backgroundColor = [UIColor colorWithCGColor:cal.CGColor];

		if (cal.isImmutable) {
			cell.textLabel.textColor = [UIColor grayColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.userInteractionEnabled = NO;
		}
    }

    else {
		cell.textLabel.text = @"Add Calendar...";
        cell.imageView.backgroundColor = [UIColor clearColor];
    }

    return cell;
}




#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    EKSource *source = [_calendarSources objectAtIndex:section];
    return source.localizedTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    EKSource *source = [_calendarSources objectAtIndex:section];
    if (source.sourceType == EKSourceTypeLocal) {
        return @"Adding local calendars will not work if iCloud is enabled and syncing your calendars. You will need to create an iCloud calendar.";
    }
    else if (source.sourceType == EKSourceTypeBirthdays) {
        return (@"The birthday calendar cannot be edited. It is generated from your contacts, and their birthdays. "
                @"So, if you want to add a birthday to the birthday calendar add a birthday to one of your contacts "
                @"in the Contacts.app.");
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	EKSource *source = [_calendarSources objectAtIndex:indexPath.section];
	NSArray *calendars = [[source calendarsForEntityType:EKEntityTypeEvent] allObjects];

    if (indexPath.row == calendars.count) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		EKSource *source = [_calendarSources objectAtIndex:indexPath.section];
		NSArray *calendars = [[source calendarsForEntityType:EKEntityTypeEvent] allObjects];
		EKCalendar *calendar = [calendars objectAtIndex:indexPath.row];
		if ([calendar remove]) {
            [tableView beginUpdates];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
		}
    }
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CalendarDetailSegue"]) {

		CVCalendarDetailsViewController *detailsView = segue.destinationViewController;
		detailsView.delegate = self;

		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

		EKSource *source = [_calendarSources objectAtIndex:indexPath.section];
		NSArray *calendars = [[source calendarsForEntityType:EKEntityTypeEvent] allObjects];

		if (indexPath.row != calendars.count)
			detailsView.calendar = [calendars objectAtIndex:indexPath.row];
		else {
			EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:[EKEventStore sharedStore]];
			calendar.source = source;
			detailsView.calendar = calendar;
		}
	}
}





#pragma mark - Detail Delegate

- (void)calendarDetailsController:(CVCalendarDetailsViewController *)controller didFinishWithResult:(CVCalendarDetailsControllerResult)result
{
    if (result == CVCalendarDetailsControllerResultSaved) {
        _calendarSources = [EKEventStore calendarSources];
    }
	else if (controller.calendar.isNew) {
		[controller.calendar remove];
	}
    [self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}




- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
