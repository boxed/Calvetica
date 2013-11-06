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
@property (nonatomic, weak) IBOutlet UISwitch *syncSettingsOveriCloudSwitch;
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

    self.syncSettingsOveriCloudSwitch.on    = PREFS.syncSettingsWithiCloud;
    self.askForCalendarSwitch.on            = PREFS.alwaysAskForCalendar;
    self.showRemindersSwitch.on             = PREFS.remindersEnabled;
    self.twentyFourHourFormatSwitch.on      = PREFS.twentyFourHourFormat;
    self.dotsOnlyMonthViewSwitch.on         = PREFS.dotsOnlyMonthView;
    self.scrollingMonthSwitch.on            = PREFS.iPhoneScrollableMonthView;
    self.durationBarReadOnlySwitch.on       = PREFS.showDurationOnReadOnlyEvents;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TimeZoneSegue"]) {
        CVTimeZoneViewController *controller    = [segue destinationViewController];
        controller.delegate                     = self;
        NSTimeZone *tz                          = PREFS.timeZoneName ? [NSTimeZone timeZoneWithName:PREFS.timeZoneName] : nil;
        controller.selectedTimeZone             = PREFS.timezoneSupportEnabled ? tz : nil;
    }
}




#pragma mark - Actions

- (IBAction)syncSettingsOveriCloudWasFlipped:(UISwitch *)sender
{
    PREFS.syncSettingsWithiCloud = sender.isOn;
    if (sender.isOn) {
        [[CVSharedSettings sharedSettings] pushLocalToiCloud];
    }
}

- (IBAction)askForCalendarWasFlipped:(UISwitch *)sender
{
    PREFS.alwaysAskForCalendar = sender.isOn;
}

- (IBAction)showRemindersWasFlipped:(UISwitch *)sender
{
    PREFS.remindersEnabled = sender.isOn;
}

- (IBAction)twentyFourHourFormatWasFlipped:(UISwitch *)sender
{
    PREFS.twentyFourHourFormat = sender.isOn;
}

- (IBAction)dotsOnlyMonthViewFlipped:(UISwitch *)sender
{
    PREFS.dotsOnlyMonthView = sender.isOn;
}

- (IBAction)scrollingMonthFlipped:(UISwitch *)sender
{
    PREFS.iPhoneScrollableMonthView = sender.isOn;
}

- (IBAction)durationBarReadOnlyFlipped:(UISwitch *)sender
{
    PREFS.showDurationOnReadOnlyEvents = sender.isOn;
}



#pragma mark - DATASOURCE Table View

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
    PREFS.timeZoneName = timeZone.name;
    [NSDate mt_setTimeZone:timeZone];
}

- (void)timeZoneViewController:(CVTimeZoneViewController *)controller didToggleSupportOn:(BOOL)isOn
{
    PREFS.timezoneSupportEnabled = isOn;
    if (isOn && PREFS.timeZoneName) {
        [NSDate mt_setTimeZone:[NSTimeZone timeZoneWithName:PREFS.timeZoneName]];
    }
    else {
        [NSDate mt_setTimeZone:[NSTimeZone systemTimeZone]];
    }
}


@end
