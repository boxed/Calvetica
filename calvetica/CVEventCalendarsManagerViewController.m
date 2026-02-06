//
//  CVCalendarsManagerViewController.m
//  calvetica
//
//  Created by James Schultz on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CVEventCalendarsManagerViewController.h"
#import "UIImage+Clear.h"


@interface CVEventCalendarsManagerViewController ()
@property (nonatomic, copy  ) NSArray *calendarSources;
@property (nonatomic, strong) UIImage *clearImage;
@end


@implementation CVEventCalendarsManagerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

    // Enable dark mode support
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;

	self.calendarSources = [EKEventStore sharedStore].sources;

    self.clearImage = [UIImage clearImageWithSize:CGSizeMake(30, 30)];

	self.tableView.allowsSelectionDuringEditing = YES;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                           target:self
                                                                                           action:@selector(editButtonPressed:)];
	self.title = @"Calendars";
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
    EKSource *source            = [_calendarSources objectAtIndex:indexPath.section];
    NSArray *calendars          = [[source calendarsForEntityType:EKEntityTypeEvent] allObjects];

    UITableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"CalendarCell"];
    cell.imageView.image        = self.clearImage;
    cell.textLabel.textColor    = UIColor.labelColor;
    cell.backgroundColor        = UIColor.secondarySystemGroupedBackgroundColor;
    cell.selectionStyle         = UITableViewCellSelectionStyleGray;
    cell.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
    cell.userInteractionEnabled = YES;
    cell.textLabel.font         = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:15];


    if (indexPath.row != calendars.count) {
		EKCalendar *cal = [calendars objectAtIndex:indexPath.row];

        cell.textLabel.text = cal.title;
		cell.imageView.backgroundColor = cal.customColor;

		if (cal.isImmutable) {
            cell.textLabel.textColor    = UIColor.secondaryLabelColor;
            cell.accessoryType          = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = NO;
		}
    }

    else {
		cell.textLabel.text = @"Add Calendar...";
        cell.imageView.backgroundColor = patentedClear;
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
        EKSource *source        = [_calendarSources objectAtIndex:indexPath.section];
        NSArray *calendars      = [[source calendarsForEntityType:EKEntityTypeEvent] allObjects];
        EKCalendar *calendar    = [calendars objectAtIndex:indexPath.row];
		if ([calendar removeWithError:nil]) {
            [tableView beginUpdates];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
		}
    }
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CalendarDetailSegue"]) {

		CVEditCalendarViewController *detailsView = segue.destinationViewController;
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

- (void)calendarDetailsController:(CVEditCalendarViewController *)controller didFinishWithResult:(CVCalendarDetailsControllerResult)result
{
    if (result == CVCalendarDetailsControllerResultSaved) {
        _calendarSources = [EKEventStore sharedStore].sources;
    }
	else if (controller.calendar.isNew) {
		[controller.calendar removeWithError:nil];
	}
    [self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
