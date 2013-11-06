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

	_weekdayTitles = [NSMutableArray array];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.year		= 1970;
	components.month	= 1;
	components.week		= 1;
	components.weekday	= 1;
	NSDate *startOfWeek = [NSDate mt_dateFromComponents:components];
	for (NSInteger i = 0; i < 7; i++) {
		NSDate *weekday = [startOfWeek mt_dateDaysAfter:i];
		[_weekdayTitles addObject:[weekday mt_stringFromDateWithFullWeekdayTitle]];
	}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PREFS.weekStartsOnWeekday = indexPath.row + 1;
	[self.tableView reloadData];
}

@end
