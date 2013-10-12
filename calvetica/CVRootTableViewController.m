//
//  CVRootTableViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRootTableViewController.h"




@implementation CVRootTableViewController

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)setTableView:(UITableView *)newTableView 
{
    _tableView                  = newTableView;
    _tableView.delegate         = self;
    _tableView.dataSource       = self;
    _tableView.separatorColor   = RGB(214, 214, 214);
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;
}

- (void)setDelegate:(id)delegate 
{
    
}

- (void)loadTableView 
{
    _tableView.delegate     = self;
    _tableView.dataSource   = self;
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


@end
