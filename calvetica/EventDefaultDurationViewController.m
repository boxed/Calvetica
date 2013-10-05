//
//  EventDefaultDurationViewController.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/12.
//
//

#import "EventDefaultDurationViewController.h"
#import "settingskeys.h"


@interface EventDefaultDurationViewController ()
@property NSInteger duration;
@end

@implementation EventDefaultDurationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	_duration = [CVSettings defaultDuration];
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
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	_duration = cell.tag;
	[[NSUserDefaults standardUserDefaults] setInteger:cell.tag forKey:DEFAULT_DURATION];
	[[NSUserDefaults standardUserDefaults] synchronize];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadData];
}

@end
