//
//  CVEventDetailsSubTitleTextOrderViewController.m
//  calvetica
//
//  Created by James Schultz on 5/12/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventSubtitleTextPriorityViewController.h"




@interface CVEventSubtitleTextPriorityViewController ()
+ (NSMutableDictionary *)detailsDictionary:(NSString *)title hidden:(BOOL)isHidden;
@end




@implementation CVEventSubtitleTextPriorityViewController


#pragma mark - NSUserDefaults Methods

+ (NSMutableDictionary *)detailsDictionary:(NSString *)title hidden:(BOOL)isHidden {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:title forKey:@"TitleKey"];
    [dictionary setObject:@(isHidden) forKey:@"HiddenKey"];
    
    return dictionary;
}

+ (NSMutableArray *)standardSubtitleTextPriorityArray {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"End Time" hidden:NO],
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"End Time + Repeat" hidden:NO],
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"Repeat" hidden:NO],
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"End Time (if not default)" hidden:NO],
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"Notes" hidden:NO],
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"Location" hidden:NO],
                             [CVEventSubtitleTextPriorityViewController
                              detailsDictionary:@"People" hidden:NO],
                             nil];
    return array;
}

- (void)setSubtitleTextPriorityArray:(NSMutableArray *)newSubtitleTextPriorityArray 
{
    _subtitleTextPriorityArray = newSubtitleTextPriorityArray;
    PREFS.eventDetailsSubtitleTextPriority = newSubtitleTextPriorityArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (PREFS.eventDetailsSubtitleTextPriority) {
        self.subtitleTextPriorityArray = [PREFS.eventDetailsSubtitleTextPriority mutableCopy];
    }
    else {
        self.subtitleTextPriorityArray = [CVEventSubtitleTextPriorityViewController standardSubtitleTextPriorityArray];
    }
    
    self.navigationItem.title = NSLocalizedString(@"Subtitle text", @"Navigation item to Event details");
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) {
        return _subtitleTextPriorityArray.count;        
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell       = [UITableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    cell.textLabel.font         = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:15];

    if (indexPath.section == 0) {        
        NSMutableDictionary *dictionary = [_subtitleTextPriorityArray objectAtIndex:indexPath.row];
        
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    // do nothing 
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    NSMutableDictionary *fromObject = [_subtitleTextPriorityArray objectAtIndex:fromIndexPath.row];
    
    [_subtitleTextPriorityArray removeObject:fromObject];
    [_subtitleTextPriorityArray insertObject:fromObject atIndex:toIndexPath.row];
    
    self.subtitleTextPriorityArray = _subtitleTextPriorityArray;
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
        return NSLocalizedString(@"Prioritize Event Subtitle Text", @"Table header for Event details");        
    }
    return NSLocalizedString(@"Defaults", @"Defaults");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (section == 0) {
        return NSLocalizedString(@"Prioritize these event details to be displayed in the event subtitle text.  The first one with content will be displayed, so put the most important ones to you at the top.", @"Instructions to the user in a table footer for the event details");    
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
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_subtitleTextPriorityArray objectAtIndex:indexPath.row]];
            [dict setObject:@(NO) forKey:@"HiddenKey"];
            [_subtitleTextPriorityArray removeObjectAtIndex:indexPath.row];
            [_subtitleTextPriorityArray insertObject:dict atIndex:indexPath.row];
        } 
        else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_subtitleTextPriorityArray objectAtIndex:indexPath.row]];
            [dict setObject:@(YES) forKey:@"HiddenKey"];
            [_subtitleTextPriorityArray removeObjectAtIndex:indexPath.row];
            [_subtitleTextPriorityArray insertObject:dict atIndex:indexPath.row];
        }
        self.subtitleTextPriorityArray = _subtitleTextPriorityArray;
    } else {
        self.subtitleTextPriorityArray = [CVEventSubtitleTextPriorityViewController standardSubtitleTextPriorityArray];
        [tableView reloadData];
    }
}



- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


@end
