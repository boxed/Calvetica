//
//  CVBadgeAndAlertsSettingViewController.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/12.
//
//

#import "CVBadgeAndAlertsSettingViewController.h"
#import "settingskeys.h"




@interface CVBadgeAndAlertsSettingViewController ()
@property NSInteger selection;
@end




@implementation CVBadgeAndAlertsSettingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

	_selection = [[NSUserDefaults standardUserDefaults] integerForKey:BADGE_OR_ALERTS];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (cell.tag == _selection) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	_selection = cell.tag;
	[[NSUserDefaults standardUserDefaults] setInteger:cell.tag forKey:BADGE_OR_ALERTS];
	[[NSUserDefaults standardUserDefaults] synchronize];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadData];
}

@end
