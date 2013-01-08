//
//  CVReminderDetailsOrderViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderDetailsOrderViewController.h"


@implementation CVReminderDetailsOrderViewController



- (void)viewDidLoad 
{
    [super viewDidLoad];

	if ([CVSettings reminderDetailsOrderingArray]) {
		self.detailsOrderArray = [NSMutableArray arrayWithArray:[CVSettings reminderDetailsOrderingArray]];
	}
	else {
		self.detailsOrderArray = [CVReminderDetailsOrderViewController standardDetailsOrderingArray];
	}

    self.navigationItem.title = NSLocalizedString(@"Reminder details", @"Navigation item to Reminder details");
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}





#pragma mark - Public Methods

+ (NSMutableDictionary *)detailsDictionary:(NSString *)title hidden:(BOOL)isHidden {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:title forKey:@"TitleKey"];
    [dictionary setObject:@(isHidden) forKey:@"HiddenKey"];
    
    return dictionary;
}

+ (NSMutableArray *)standardDetailsOrderingArray {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             [CVReminderDetailsOrderViewController 
                              detailsDictionary:@"Title" hidden:NO],
                             [CVReminderDetailsOrderViewController 
                              detailsDictionary:@"Calendar" hidden:NO],
                             [CVReminderDetailsOrderViewController 
                              detailsDictionary:@"Priority" hidden:NO],
                             [CVReminderDetailsOrderViewController 
                              detailsDictionary:@"Notes" hidden:NO],
                             [CVReminderDetailsOrderViewController 
                              detailsDictionary:@"Complete" hidden:NO],
                             [CVReminderDetailsOrderViewController 
                              detailsDictionary:@"Delete" hidden:NO],
                             nil];
    return array;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) {
        return self.detailsOrderArray.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        NSMutableDictionary *dictionary = [_detailsOrderArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dictionary objectForKey:@"TitleKey"];
        cell.showsReorderControl = YES;
        
        if ([[dictionary objectForKey:@"HiddenKey"] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        return cell;
        
    } else {
        cell.textLabel.text = NSLocalizedString(@"Reset to defaults", @"Reset to defaults");
        return cell;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        return  YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    // do nothing 
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    NSMutableDictionary *fromObject = [self.detailsOrderArray objectAtIndex:fromIndexPath.row];
    
    [self.detailsOrderArray removeObject:fromObject];
    [self.detailsOrderArray insertObject:fromObject atIndex:toIndexPath.row];
    
    [CVSettings setReminderDetailsOrderingArray:[NSArray arrayWithArray:self.detailsOrderArray]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        return  YES;
    }
    return NO;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *tempOrderArray = [NSMutableArray arrayWithArray:self.detailsOrderArray];
        NSMutableDictionary *detailDict = [NSMutableDictionary dictionaryWithDictionary:[tempOrderArray objectAtIndex:indexPath.row]];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [detailDict setObject:@(NO) forKey:@"HiddenKey"];
        }
        else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [detailDict setObject:@(YES) forKey:@"HiddenKey"];
        }
        
        [tempOrderArray removeObjectAtIndex:indexPath.row];
        [tempOrderArray insertObject:detailDict atIndex:indexPath.row];
        
        self.detailsOrderArray = tempOrderArray;
    }
    else if (indexPath.section == 1) {
        self.detailsOrderArray = [CVReminderDetailsOrderViewController standardDetailsOrderingArray];
        [self.tableView reloadData];
    }
    
    [CVSettings setReminderDetailsOrderingArray:[NSArray arrayWithArray:self.detailsOrderArray]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return NSLocalizedString(@"Reminder details", @"Table header for Reminder details");        
    }
    return NSLocalizedString(@"Defaults", @"Defaults");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (section == 0) {
        return NSLocalizedString(@"Uncheck to hide, tap edit and then move to reorder, no deleting allowed", @"Instructions to the user in a table footer for the event details");    
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return NSLocalizedString(@"Disabled", @"When the user attempts to delete reminder details");
}



- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

@end
