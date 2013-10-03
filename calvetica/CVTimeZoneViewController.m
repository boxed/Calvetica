//
//  CVTimeZoneViewController.m
//  calvetica
//
//  Created by Adam Kirk on 10/2/13.
//
//

#import "CVTimeZoneViewController.h"
#import "CVSettings.h"


@interface CVTimeZoneViewController () <UISearchBarDelegate>
@end


@implementation CVTimeZoneViewController {
    __weak IBOutlet UISwitch    *_toggleSwitch;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISearchBar *_searchBar;
    NSArray                     *_availableTimeZones;
    NSArray                     *_filteredTimeZones;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _availableTimeZones = [NSTimeZone knownTimeZoneNames];
    _filteredTimeZones  = [_availableTimeZones copy];
    _toggleSwitch.on    = self.selectedTimeZone != nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_toggleSwitch.isOn) {
        [_searchBar becomeFirstResponder];
        if (self.selectedTimeZone) {
            _searchBar.text = [self.selectedTimeZone name];
            _filteredTimeZones = @[self.selectedTimeZone.name];
        }
    }
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}

#pragma mark (rotation)

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}



#pragma mark - Actions

- (IBAction)toggleSwitchWasTapped:(id)sender
{
    if (_toggleSwitch.isOn) {
        _filteredTimeZones = [_availableTimeZones copy];
        if (self.selectedTimeZone) {
            [self.delegate timeZoneViewController:self didSelectTimeZone:self.selectedTimeZone];
        }
    }
    else {
        _filteredTimeZones = [NSMutableArray new];
    }
    [_tableView reloadData];
    [self.delegate timeZoneViewController:self didToggleSupportOn:_toggleSwitch.isOn];
}




#pragma mark - DELEGATE table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_filteredTimeZones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TimeZoneCell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                      forIndexPath:indexPath];

    NSString *timeZoneName      = [_filteredTimeZones objectAtIndex:indexPath.row];
    NSTimeZone *timeZone        = [NSTimeZone timeZoneWithName:timeZoneName];

    cell.textLabel.text         = timeZone.name;
    cell.detailTextLabel.text   = timeZone.abbreviation;

    if ([self.selectedTimeZone isEqualToTimeZone:timeZone]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *timeZoneName = [_filteredTimeZones objectAtIndex:indexPath.row];
    self.selectedTimeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [_tableView reloadData];
    [self.delegate timeZoneViewController:self didSelectTimeZone:[self.selectedTimeZone copy]];
}




#pragma mark - DELEGATE search bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        _filteredTimeZones = [_availableTimeZones copy];
    }
    else {
        _filteredTimeZones = [_availableTimeZones filteredArrayUsingPredicate:
                              [NSPredicate predicateWithBlock:^BOOL(NSString *timeZoneName, NSDictionary *bindings)
                               {
                                   return [[timeZoneName lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound;
                               }]];
    }

    [_tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    _filteredTimeZones = [_availableTimeZones copy];
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
