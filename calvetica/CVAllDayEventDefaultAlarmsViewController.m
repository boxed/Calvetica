//
//  CVAllDayEventDefaultAlarmsViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAllDayEventDefaultAlarmsViewController.h"

#define Title_Key @"TitleKey"
#define Value_Key @"ValueKey"
#define Selected_Key @"SelectedKey"




@implementation CVAllDayEventDefaultAlarmsViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.alarms = [NSMutableArray array];
	self.selectedAlarms = [NSMutableArray arrayWithArray:[CVSettings defaultAllDayEventAlarms]];

    NSArray *availableAlarmTitles;
    NSArray *availableAlarmValues;
    
    if ([CVSettings isTwentyFourHourFormat]) {
        availableAlarmTitles = @[@"18 the day before",
                                         @"22 the day before",
                                         @"6 the day of",
                                         @"7 the day of",
                                         @"8 the day of",
                                         @"9 the day of"];
    }
    else {
        availableAlarmTitles = @[@"6pm the day before",
                                @"10pm the day before",
                                @"6am the day of",
                                @"7am the day of",
                                @"8am the day of",
                                @"9am the day of"];
    }
    
    availableAlarmValues = @[@(-SECONDS_IN_HOUR * 6), 
                                     @(-SECONDS_IN_HOUR * 2), 
                                     @(SECONDS_IN_HOUR * 6), 
                                     @(SECONDS_IN_HOUR * 7), 
                                     @(SECONDS_IN_HOUR * 8), 
                                     @(SECONDS_IN_HOUR * 9)];
    
    for (int i = 0; i < [availableAlarmTitles count]; i++) {
        BOOL selected = NO;
        
        for (NSNumber *number in self.selectedAlarms) {
            if ([number isEqualToNumber:[availableAlarmValues objectAtIndex:i]]) {
                selected = YES;
            }
        }
        
        NSMutableDictionary *dict = [CVAllDayEventDefaultAlarmsViewController alarmDictionary:[availableAlarmTitles objectAtIndex:i] value:[availableAlarmValues objectAtIndex:i] selected:selected];
        [self.alarms addObject:dict];
    }
    
    self.navigationItem.title = NSLocalizedString(@"Default All Day Event Alarms", @"Navigation item to Default All Day Event Alarms");
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}




#pragma mark - Public Methods

+ (NSMutableDictionary *)alarmDictionary:(NSString *)title value:(NSNumber *)value selected:(BOOL)isSelected {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:title forKey:Title_Key];
    [dictionary setObject:value forKey:Value_Key];
    [dictionary setObject:@(isSelected) forKey:Selected_Key];
    
    return dictionary;
}




#pragma mark - UITableViewDataSource

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
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *alarmDict = [self.alarms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [alarmDict objectForKey:Title_Key];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    if ([[alarmDict objectForKey:Selected_Key] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

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
    [CVSettings setDefaultAllDayEventAlarms:self.selectedAlarms];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Available Alarms", @"Table header for all day event default alarms");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Check to add as a default alarm, uncheck to remove as a default alarm", @"Instructions to the user as a table foooter");
}





- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
