//
//  MTAppsViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "MTAppsViewController.h"




#pragma mark - Private
@interface MTAppsViewController ()
@property (nonatomic, strong) NSMutableArray *availableApps;
- (void)loadAvailableApps;
@end




@implementation MTAppsViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.title = @"Our apps";
    [self loadAvailableApps];
}

- (void)viewWillAppear:(BOOL)animated 
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}




#pragma mark - Methods

- (void)loadAvailableApps 
{
    self.availableApps = [NSMutableArray array];
    
    NSMutableDictionary *appDict0 = [NSMutableDictionary dictionary];
    [appDict0 setObject:@"Sticky Playlists" forKey:@"appname"];
    [appDict0 setObject:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=484145716&mt=8" forKey:@"applink"];
    [appDict0 setObject:@"Playlists that stick!" forKey:@"appDescription"];
    [self.availableApps addObject:appDict0];
    
    NSMutableDictionary *appDict1 = [NSMutableDictionary dictionary];
    [appDict1 setObject:@"Fast Calendar & Reminders (Calvetica)" forKey:@"appname"];
    [appDict1 setObject:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=385862462&mt=8" forKey:@"applink"];
    [appDict1 setObject:@"The fast calendar for power users" forKey:@"appDescription"];
    [self.availableApps addObject:appDict1];
    
    NSMutableDictionary *appDict2 = [NSMutableDictionary dictionary];
    [appDict2 setObject:@"Event Calendar (Tempus)" forKey:@"appname"];
    [appDict2 setObject:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=456838001&mt=8" forKey:@"applink"];
    [appDict2 setObject:@"The fast calendar for minimalists" forKey:@"appDescription"];
    [self.availableApps addObject:appDict2];
    
    NSMutableDictionary *appDict3 = [NSMutableDictionary dictionary];
    [appDict3 setObject:@"Dialvetica Contacts" forKey:@"appname"];
    [appDict3 setObject:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=404074258&mt=8" forKey:@"applink"];
    [appDict3 setObject:@"Contact your peeps with one tap" forKey:@"appDescription"];
    [self.availableApps addObject:appDict3];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.availableApps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"AppCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *dict = [self.availableApps objectAtIndex:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [dict objectForKey:@"appname"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.detailTextLabel.text = [dict objectForKey:@"appDescription"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    NSMutableDictionary *dict = [self.availableApps objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *appStoreLink = [NSURL URLWithString:[dict objectForKey:@"applink"]];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:appStoreLink]) {
        [[UIApplication sharedApplication] openURL:appStoreLink];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
