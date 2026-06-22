//
//  CVThemeViewController.m
//  calvetica
//

#import "CVThemeViewController.h"
#import "CVSharedSettings.h"
#import "CVAppDelegate.h"


@interface CVThemeViewController ()
@property (nonatomic, strong) NSArray<NSString *> *titles;
@end


@implementation CVThemeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Theme", @"Title for the appearance theme picker");
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;

    self.titles = @[
        NSLocalizedString(@"Auto",  @"Theme option following the system light/dark setting"),
        NSLocalizedString(@"Light", @"Theme option forcing light mode"),
        NSLocalizedString(@"Dark",  @"Theme option forcing dark mode")
    ];

    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];

    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.adjustsFontForContentSizeCategory = YES;
    cell.textLabel.text = self.titles[indexPath.row];

    if (indexPath.row == (NSInteger)PREFS.themeStyle)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = UIColor.secondarySystemGroupedBackgroundColor;
    cell.textLabel.textColor = UIColor.labelColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PREFS.themeStyle = (CVThemeStyle)indexPath.row;
    [CVAppDelegate applyThemeStyle];
    [self.tableView reloadData];
}

@end
