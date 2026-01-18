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
    // Enable dark mode support
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
	_selection = PREFS.badgeOrAlerts;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Enable dark mode support for cells
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    cell.textLabel.textColor = UIColor.labelColor;
    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            ((UILabel *)subview).textColor = UIColor.labelColor;
        }
    }

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
