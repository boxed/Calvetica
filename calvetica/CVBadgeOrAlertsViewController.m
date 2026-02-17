//
//  CVBadgeOrAlertsViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVBadgeOrAlertsViewController.h"




@implementation CVBadgeOrAlertsViewController




#pragma mark - Properties




#pragma mark - Constructor

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}




#pragma mark - Memory Management





#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Icon Badge and Alerts";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}




#pragma mark - Methods




#pragma mark - IBActions




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([CVSettings badgeOrAlerts] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Day of Month Badge Only";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Custom Alerts Only";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"Badge and Alerts";
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"Neither";
    }
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [CVSettings setBadgeOrAlerts:indexPath.row];
    [self.tableView reloadData];
}

@end
