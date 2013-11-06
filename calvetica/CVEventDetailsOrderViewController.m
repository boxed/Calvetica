//
//  CVEventDetailsOrderViewController.m
//  calvetica
//
//  Created by James Schultz on 5/12/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsOrderViewController.h"

@interface CVEventDetailsOrderViewController ()
+ (NSMutableDictionary *)detailsDictionary:(NSString *)title hidden:(BOOL)isHidden;
@end




@implementation CVEventDetailsOrderViewController


#pragma mark - NSUserDefaults Methods

+ (NSMutableDictionary *)detailsDictionary:(NSString *)title hidden:(BOOL)isHidden {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:title forKey:@"TitleKey"];
    [dictionary setObject:@(isHidden) forKey:@"HiddenKey"];
    
    return dictionary;
}

+ (NSMutableArray *)standardDetailsOrderingArray {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Title" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Calendar" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Notes" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Repeat" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"People" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Location" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Share" hidden:NO],
                             [CVEventDetailsOrderViewController 
                               detailsDictionary:@"Delete" hidden:NO],
                             [CVEventDetailsOrderViewController 
                              detailsDictionary:@"Alarms" hidden:NO],
                             nil];
    return array;
}

- (void)setDetailsOrderArray:(NSMutableArray *)newDetailsOrderArray 
{
    _detailsOrderArray = newDetailsOrderArray;
    PREFS.eventDetailsOrdering = newDetailsOrderArray;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (PREFS.eventDetailsOrdering) {
        self.detailsOrderArray = [[self eventDetailsOrderingArray] mutableCopy];
    }
    else {
        self.detailsOrderArray = [CVEventDetailsOrderViewController standardDetailsOrderingArray];
    }
 
    self.navigationItem.title = NSLocalizedString(@"Event details", @"Navigation item to Event details");
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}




#pragma mark - DATASOURCE table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) {
        return _detailsOrderArray.count;        
    } else {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    cell.textLabel.font         = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:15];

    if (indexPath.section == 0) {        
        NSMutableDictionary *dictionary = [_detailsOrderArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [dictionary objectForKey:@"TitleKey"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    NSMutableDictionary *fromObject = [_detailsOrderArray objectAtIndex:fromIndexPath.row];
    
    [_detailsOrderArray removeObject:fromObject];
    [_detailsOrderArray insertObject:fromObject atIndex:toIndexPath.row];
    
    self.detailsOrderArray = _detailsOrderArray;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        return  YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return NSLocalizedString(@"Event details", @"Table header for Event details");        
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
    return NSLocalizedString(@"Disabled", @"When the user attempts to delete event details");
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_detailsOrderArray objectAtIndex:indexPath.row]];
            [dict setObject:@(NO) forKey:@"HiddenKey"];
            [_detailsOrderArray removeObjectAtIndex:indexPath.row];
            [_detailsOrderArray insertObject:dict atIndex:indexPath.row];
        } 
        else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_detailsOrderArray objectAtIndex:indexPath.row]];
            [dict setObject:@(YES) forKey:@"HiddenKey"];
            [_detailsOrderArray removeObjectAtIndex:indexPath.row];
            [_detailsOrderArray insertObject:dict atIndex:indexPath.row];
        }
        self.detailsOrderArray = _detailsOrderArray;
    } else {
        self.detailsOrderArray = [CVEventDetailsOrderViewController standardDetailsOrderingArray];
        [tableView reloadData];
    }
}



- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - Private

- (BOOL)isAEventDetailBlock:(NSDictionary *)detail
{
    NSArray *standardArray = [CVEventDetailsOrderViewController standardDetailsOrderingArray];
    for (NSDictionary *dict in standardArray) {
        if ([[detail objectForKey:@"TitleKey"] isEqualToString:[dict objectForKey:@"TitleKey"]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)eventDetailBlockIsSaved:(NSDictionary *)detail
{
    NSArray *savedArray = PREFS.eventDetailsOrdering;
    for (NSDictionary *dict in savedArray) {
        if ([[detail objectForKey:@"TitleKey"] isEqualToString:[dict objectForKey:@"TitleKey"]]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)eventDetailsOrderingArray
{
    NSMutableArray *savedArray  = [PREFS.eventDetailsOrdering mutableCopy];
    NSArray *standardArray      = [CVEventDetailsOrderViewController standardDetailsOrderingArray];

    // check for a valid details ordering array
    if (savedArray) {
        // check that each item in the standard array is in the saved array
        // if not add it to the saved array
        for (NSDictionary *dict in standardArray) {
            if (![self eventDetailBlockIsSaved:dict]) {
                [savedArray addObject:dict];
            }
        }

        // check that each item in the saved array is in the standard array
        // if not remove it from the saved array
        for (NSDictionary *dict in savedArray) {
            if (![self isAEventDetailBlock:dict]) {
                [savedArray removeObject:dict];
            }
        }

    }
    // if no valid details ordering array, save the standard ordering array
    else {
        savedArray = [standardArray mutableCopy];
        PREFS.eventDetailsOrdering = standardArray;
    }

    return savedArray;
}


@end
