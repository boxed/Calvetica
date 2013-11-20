//
//  CVBadgeAndAlertsSettingViewController.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/12.
//
//

#import "CVBadgeAndAlertsSettingViewController.h"


@interface CVBadgeAndAlertsSettingViewController ()
@property NSInteger selection;
@end


@implementation CVBadgeAndAlertsSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_selection = PREFS.badgeOrAlerts;
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
    UITableViewCell *cell   = [tableView cellForRowAtIndexPath:indexPath];
    _selection              = cell.tag;
    PREFS.badgeOrAlerts     = cell.tag;
    cell.accessoryType      = UITableViewCellAccessoryCheckmark;
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadData];
}

@end
