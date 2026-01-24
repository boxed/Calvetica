//
//  CVStartWeekOnViewController.m
//  calvetica
//
//  Created by Adam Kirk on 10/15/12.
//
//

#import "CVStartWeekOnViewController.h"


@interface CVStartWeekOnViewController ()
@property (nonatomic, strong) NSMutableArray *weekdayTitles;
@end




@implementation CVStartWeekOnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Enable dark mode support
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;

	_weekdayTitles = [[NSDate mt_weekdaySymbols] mutableCopy];

	[self.tableView reloadData];
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _weekdayTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WeekDayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.textLabel.font         = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:15];

    cell.textLabel.text = _weekdayTitles[indexPath.row];
	if (indexPath.row == PREFS.weekStartsOnWeekday - 1)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Enable dark mode support for cells
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    cell.textLabel.textColor = UIColor.labelColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PREFS.weekStartsOnWeekday = (int)indexPath.row + 1;
	[self.tableView reloadData];
}

@end
