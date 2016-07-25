//
//  CVDayStartHourViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDayStartHourViewController.h"


@interface CVDayStartHourViewController()
#pragma mark - Private Properties
#pragma mark - Private Methods
#pragma mark - IBActions
@end




@implementation CVDayStartHourViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];

	_hoursArray = [NSMutableArray array];

    for (int i = 0; i < 12; i++) {
        [self.hoursArray addObject:@(i)];
    }
    
    self.navigationItem.title = @"Day Start Hour";
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.hoursArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    NSNumber *time = [self.hoursArray objectAtIndex:indexPath.row];

    cell.selectionStyle         = UITableViewCellSelectionStyleNone;
    cell.textLabel.font         = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:15];

    if (PREFS.twentyFourHourFormat) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d", [time intValue]];
    }
    else {
        if ([time intValue] == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%dam", 12];
        }
        else {
            cell.textLabel.text = [NSString stringWithFormat:@"%dam", [time intValue]];
        }
    }
    
    if (PREFS.dayStartHour == [time intValue]) {
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
    NSNumber *time = [self.hoursArray objectAtIndex:indexPath.row];
    
    PREFS.dayStartHour = [time intValue];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self.tableView reloadData];
}




- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
