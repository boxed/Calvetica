//
//  CVThemeColorViewController.m
//  calvetica
//

#import "CVThemeColorViewController.h"
#import "CVSharedSettings.h"
#import "UIColor+Serialization.h"
#import "UIColor+Calvetica.h"
#import "colors.h"


@interface CVThemeColorViewController ()
@property (nonatomic, strong) NSArray<UIColor *> *colors;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@end


@implementation CVThemeColorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Theme Color", @"Title for the theme (accent) color picker");
    self.tableView.backgroundColor = UIColor.systemGroupedBackgroundColor;

    // The patented Calvetica red is always the first (default) option, followed
    // by the standard Calvetica palettes.
    NSMutableArray<UIColor *> *colors = [NSMutableArray array];
    NSMutableArray<NSString *> *titles = [NSMutableArray array];

    [colors addObject:patentedDefaultRed];
    [titles addObject:NSLocalizedString(@"Calvetica Red", @"Default theme color name")];

    for (UIColor *color in [UIColor primaryPalette]) {
        [colors addObject:color];
        [titles addObject:color.mys_title ?: @""];
    }
    for (UIColor *color in [UIColor secondaryPalette]) {
        [colors addObject:color];
        [titles addObject:color.mys_title ?: @""];
    }

    self.colors = colors;
    self.titles = titles;

    [self.tableView reloadData];
}


#pragma mark - Helpers

- (UIImage *)swatchForColor:(UIColor *)color
{
    CGSize size = CGSizeMake(28, 28);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        CGRect rect = CGRectMake(0.5, 0.5, size.width - 1, size.height - 1);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:6];
        [color setFill];
        [path fill];
        [UIColor.separatorColor setStroke];
        path.lineWidth = 1;
        [path stroke];
    }];
}

- (BOOL)colorIsSelected:(UIColor *)color
{
    return [color.stringValue isEqualToString:PREFS.themeColorString];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeColorCell"];

    UIColor *color = self.colors[indexPath.row];

    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.adjustsFontForContentSizeCategory = YES;
    cell.textLabel.text = self.titles[indexPath.row];
    cell.imageView.image = [self swatchForColor:color];

    cell.accessoryType = [self colorIsSelected:color] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

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
    PREFS.themeColorString = self.colors[indexPath.row].stringValue;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

@end
