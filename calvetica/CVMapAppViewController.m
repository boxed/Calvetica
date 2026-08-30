//
//  CVMapAppViewController.m
//  calvetica
//

#import "CVMapAppViewController.h"


@interface CVMapAppViewController ()
@property NSInteger selection;
@end


@implementation CVMapAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Enable dark mode support
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    _selection = PREFS.defaultMapApp;
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
    PREFS.defaultMapApp     = cell.tag;
    cell.accessoryType      = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

@end
