//
//  CVSettingsViewController.m
//  calvetica
//
//  Created by Adam Kirk on 9/22/12.
//
//

#import "CVSettingsViewController.h"
#import "CVTimeZoneViewController.h"
#import "settingskeys.h"


@interface CVSettingsViewController () <CVTimeZoneViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UISwitch *askForCalendarSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *showRemindersSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *twentyFourHourFormatSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *dotsOnlyMonthViewSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *scrollingMonthSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *durationBarReadOnlySwitch;
@end




@implementation CVSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self flipSwitch:_askForCalendarSwitch          withSetting:ALWAYS_ASK_FOR_CALENDAR];
	[self flipSwitch:_twentyFourHourFormatSwitch    withSetting:TWENTY_FOUR_HOUR_FORMAT];
	[self flipSwitch:_dotsOnlyMonthViewSwitch       withSetting:DOTS_ONLY_MONTH_VIEW];
	[self flipSwitch:_scrollingMonthSwitch          withSetting:SCROLLABLE_MONTH_VIEW];
	[self flipSwitch:_durationBarReadOnlySwitch     withSetting:SHOW_DURATION_ON_READ_ONLY_EVENTS];

    self.showRemindersSwitch.on = PREFS.showReminders;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TimeZoneSegue"]) {
        CVTimeZoneViewController *controller    = [segue destinationViewController];
        controller.delegate                     = self;
        controller.selectedTimeZone             = [CVSettings timeZoneSupport] ? [CVSettings timezone] : nil;
    }
}




#pragma mark - Actions

- (IBAction)askForCalendarWasFlipped:(id)sender
{
    [self toggleSwitch:sender setting:ALWAYS_ASK_FOR_CALENDAR];
}

- (IBAction)showRemindersWasFlipped:(UISwitch *)sender
{
    PREFS.showReminders = @(sender.isOn);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)twentyFourHourFormatWasFlipped:(id)sender
{
    [self toggleSwitch:sender setting:TWENTY_FOUR_HOUR_FORMAT];
}

- (IBAction)dotsOnlyMonthViewFlipped:(id)sender
{
    [self toggleSwitch:sender setting:DOTS_ONLY_MONTH_VIEW];
}

- (IBAction)scrollingMonthFlipped:(id)sender
{
    [self toggleSwitch:sender setting:SCROLLABLE_MONTH_VIEW];
}

- (IBAction)durationBarReadOnlyFlipped:(id)sender
{
    [self toggleSwitch:sender setting:SHOW_DURATION_ON_READ_ONLY_EVENTS];
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

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - DELEGATE time zone view controller

- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didSelectTimeZone:(NSTimeZone *)timeZone
{
    [CVSettings setTimeZone:timeZone];
    [NSDate mt_setTimeZone:timeZone];
}

- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didToggleSupportOn:(BOOL)isOn
{
    [CVSettings setTimeZoneSupport:isOn];
    if (isOn) {
        [NSDate mt_setTimeZone:[CVSettings timezone]];
    }
    else {
        [NSDate mt_setTimeZone:[NSTimeZone systemTimeZone]];
    }
}




#pragma mark - Private

- (void)flipSwitch:(UISwitch *)swich withSetting:(NSString *)settingKey
{
	swich.on = [[NSUserDefaults standardUserDefaults] boolForKey:settingKey];
}

- (void)toggleSwitch:(UISwitch *)swich setting:(NSString *)settingKey
{
	[[NSUserDefaults standardUserDefaults] setBool:swich.isOn forKey:settingKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}



@end
