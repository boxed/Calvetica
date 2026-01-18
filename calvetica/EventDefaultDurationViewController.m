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
    // Enable dark mode support
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
	_duration = PREFS.defaultDuration;
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
