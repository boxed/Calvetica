//
//  EventDefaultDurationViewController.m
//  accross
//
//  Created by Adam Kirk on 9/24/12.
//
//

#import "EventDefaultDurationViewController.h"


@interface EventDefaultDurationViewController ()
@property NSInteger duration;
@end

@implementation EventDefaultDurationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_duration = PREFS.defaultDuration;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (cell.tag == _duration) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell   = [tableView cellForRowAtIndexPath:indexPath];
    _duration               = cell.tag;
    PREFS.defaultDuration   = (int)cell.tag;
    cell.accessoryType      = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadData];
}

@end
