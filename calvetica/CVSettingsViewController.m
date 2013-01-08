//
//  CVSettingsViewController.m
//  calvetica
//
//  Created by Adam Kirk on 9/22/12.
//
//

#import "CVSettingsViewController.h"
#import "settingskeys.h"


@interface CVSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *askForCalendarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *multipleExchangeAlarmsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *twentyFourHourFormatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dotsOnlyMonthViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *scrollingMonthViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *durationBarReadOnlyCell;
@end




@implementation CVSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self checkCell:_askForCalendarCell withSetting:ALWAYS_ASK_FOR_CALENDAR];
	[self checkCell:_multipleExchangeAlarmsCell withSetting:MULTIPLE_EXCHANGE_ALARMS];
	[self checkCell:_twentyFourHourFormatCell withSetting:TWENTY_FOUR_HOUR_FORMAT];
	[self checkCell:_dotsOnlyMonthViewCell withSetting:DOTS_ONLY_MONTH_VIEW];
	[self checkCell:_scrollingMonthViewCell withSetting:SCROLLABLE_MONTH_VIEW];
	[self checkCell:_durationBarReadOnlyCell withSetting:SHOW_DURATION_ON_READ_ONLY_EVENTS];
}



#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	if (cell.tag == 101) {
		UIApplication *app = [UIApplication sharedApplication];
		NSURL *url = [NSURL URLWithString:@"http://www.mysterioustrousers.com/"];
		if ([app canOpenURL:url]) {
			[app openURL:url];
		}
	}

	else if (cell.tag == 102) {
		UIApplication *app = [UIApplication sharedApplication];
		NSURL *url = [NSURL URLWithString:@"http://www.tinkerlearn.com/"];
		if ([app canOpenURL:url]) {
			[app openURL:url];
		}
	}

	else if (cell == _askForCalendarCell)
		[self toggleCell:cell setting:ALWAYS_ASK_FOR_CALENDAR];

	else if (cell == _multipleExchangeAlarmsCell)
		[self toggleCell:cell setting:MULTIPLE_EXCHANGE_ALARMS];

	else if (cell == _twentyFourHourFormatCell)
		[self toggleCell:cell setting:TWENTY_FOUR_HOUR_FORMAT];

	else if (cell == _dotsOnlyMonthViewCell)
		[self toggleCell:cell setting:DOTS_ONLY_MONTH_VIEW];

	else if (cell == _scrollingMonthViewCell)
		[self toggleCell:cell setting:SCROLLABLE_MONTH_VIEW];

	else if (cell == _durationBarReadOnlyCell)
		[self toggleCell:cell setting:SHOW_DURATION_ON_READ_ONLY_EVENTS];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}






#pragma mark - Private

- (void)checkCell:(UITableViewCell *)cell withSetting:(NSString *)settingKey
{
	BOOL setting = [[NSUserDefaults standardUserDefaults] boolForKey:settingKey];
	cell.accessoryType = setting ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)toggleCell:(UITableViewCell *)cell setting:(NSString *)settingKey
{
	BOOL on = cell.accessoryType == UITableViewCellAccessoryCheckmark;
	cell.accessoryType = on ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
	[[NSUserDefaults standardUserDefaults] setBool:!on forKey:settingKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}



@end
