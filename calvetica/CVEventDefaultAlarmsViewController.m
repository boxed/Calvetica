//
//  CVEventDefaultAlarmsViewController.m
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDefaultAlarmsViewController.h"

#define Title_Key @"TitleKey"
#define Value_Key @"ValueKey"
#define Selected_Key @"SelectedKey"




@implementation CVEventDefaultAlarmsViewController


+ (NSMutableDictionary *)alarmDictionary:(NSString *)title value:(NSNumber *)value selected:(BOOL)isSelected {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:title forKey:Title_Key];
    [dictionary setObject:value forKey:Value_Key];
    [dictionary setObject:@(isSelected) forKey:Selected_Key];
    
    return dictionary;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.alarms = [NSMutableArray array];
	self.selectedAlarms = [NSMutableArray arrayWithArray:[CVSettings defaultEventAlarms]];
	
    NSArray *availableAlarmTitles = @[NSLocalizedString(@"0 minutes before", @"0m"),
                                            NSLocalizedString(@"5 minutes before", @"5m"),
                                            NSLocalizedString(@"15 minutes before", @"15m"),
                                            NSLocalizedString(@"30 minutes before", @"30m"),
                                            NSLocalizedString(@"45 minutes before", @"45m"),
                                            NSLocalizedString(@"1 hour before", @"1hr"),
                                            NSLocalizedString(@"2 hours before", @"2hr"),
                                            NSLocalizedString(@"6 hours before", @"6hr"),
                                            NSLocalizedString(@"12 hours before", @"12hr"),
                                            NSLocalizedString(@"1 day before", @"1d"),
                                            NSLocalizedString(@"2 days before", @"2d"),
                                            NSLocalizedString(@"3 days before", @"3d"),
                                            NSLocalizedString(@"5 days before", @"5d"),
                                            NSLocalizedString(@"1 weeks before", @"1w"),
                                            NSLocalizedString(@"2 weeks before", @"2w"),
                                            NSLocalizedString(@"1 month before", @"1mo")];
    
    NSArray *availableAlarmValues = @[@0, 
                                            @(SECONDS_IN_MINUTE * 5), 
                                            @(SECONDS_IN_MINUTE * 15), 
                                            @(SECONDS_IN_MINUTE * 30), 
                                            @(SECONDS_IN_MINUTE * 45), 
                                            @SECONDS_IN_HOUR, 
                                            @(SECONDS_IN_HOUR * 2), 
                                            @(SECONDS_IN_HOUR * 6), 
                                            @(SECONDS_IN_HOUR * 12), 
                                            @SECONDS_IN_DAY, 
                                            @(SECONDS_IN_DAY * 2), 
                                            @(SECONDS_IN_DAY * 3), 
                                            @(SECONDS_IN_DAY * 5), 
                                            @SECONDS_IN_WEEK, 
                                            @(SECONDS_IN_WEEK * 2), 
                                            @SECONDS_IN_MONTH];
    
    for (int i = 0; i < [availableAlarmTitles count]; i++) {
        BOOL selected = NO;
            
        for (NSNumber *number in self.selectedAlarms) {
            if ([number isEqualToNumber:[availableAlarmValues objectAtIndex:i]]) {
                selected = YES;
            }
        }
            
        NSMutableDictionary *dict = [CVEventDefaultAlarmsViewController alarmDictionary:[availableAlarmTitles objectAtIndex:i] value:[availableAlarmValues objectAtIndex:i] selected:selected];
        [self.alarms addObject:dict];
    }
    
    self.navigationItem.title = NSLocalizedString(@"Default Event Alarms", @"Navigation item to Default Alarms");
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
    return self.alarms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    UITableViewCell *cell       = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    cell.textLabel.font         = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font   = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];


    NSDictionary *alarmDict = [self.alarms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [alarmDict objectForKey:Title_Key];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[alarmDict objectForKey:Selected_Key] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Available alarms", @"Table header for Default alarms");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Check to add as a default alarm, uncheck to remove as a default alarm", @"Instructions to the user as a table foooter");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSMutableDictionary *dict = [self.alarms objectAtIndex:indexPath.row];
        [dict setObject:@(YES) forKey:Selected_Key];
        [self.selectedAlarms addObject:[dict objectForKey:Value_Key]];
    } 
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSMutableDictionary *dict = [self.alarms objectAtIndex:indexPath.row];
        [dict setObject:@(NO) forKey:Selected_Key];
        [self.selectedAlarms removeObject:[dict objectForKey:Value_Key]];
    }
    [CVSettings setDefaultEventAlarms:self.selectedAlarms];
}





- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
