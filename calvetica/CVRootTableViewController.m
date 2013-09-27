//
//  CVRootTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootTableViewController.h"




@implementation CVRootTableViewController

- (void)setTableView:(UITableView *)newTableView 
{
    _tableView = newTableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = RGB(204, 204, 204);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)setDelegate:(id)delegate 
{
    
}

- (void)loadTableView 
{
    
}

- (id)cellDataHolderAtIndexPath:(NSIndexPath *)index 
{
    return nil;
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)index 
{
    
}

- (void)scrollToCurrentHour 
{
    
}

- (void)scrollToDate:(NSDate *)date 
{
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return nil;
}

#pragma mark - Table View Delegate

@end
