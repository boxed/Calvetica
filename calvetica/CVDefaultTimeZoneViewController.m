//
//  CVDefaultTimeZoneViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDefaultTimeZoneViewController.h"



@implementation CVDefaultTimeZoneViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.availableTimeZones = [NSTimeZone knownTimeZoneNames];
    self.navigationItem.title = NSLocalizedString(@"Time Zone Support", @"Navigation item to Default Time Zone");
    self.timeZonesSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    self.timeZonesSwitch.on = [CVSettings timeZoneSupport];
    [self.timeZonesSwitch addTarget:self action:@selector(timeZoneSwitchToggled:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}



#pragma mark - Public Methods

- (void)timeZoneSwitchToggled:(id)sender 
{
    [CVSettings setTimeZoneSupport:self.timeZonesSwitch.on];
    if (self.timeZonesSwitch.on) {
        [CVSettings setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    else {
        [CVSettings setTimeZone:nil];
    }
    
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if ([CVSettings timeZoneSupport]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) {
        return 1;
    }
    return self.availableTimeZones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Time zone support";
        cell.accessoryView = self.timeZonesSwitch;
        return cell;
    }
    else if (indexPath.section == 1) {
        NSString *timeZoneName = [self.availableTimeZones objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = [self.availableTimeZones objectAtIndex:indexPath.row];
        cell.accessoryView = nil;
        
        if ([[CVSettings timezone] isEqualToTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *timeZoneName = [self.availableTimeZones objectAtIndex:indexPath.row];
    [CVSettings setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 1) {
        return NSLocalizedString(@"Time Zones", @"The header of a table with a list of available time zones");
    }
    return nil;
}




- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
