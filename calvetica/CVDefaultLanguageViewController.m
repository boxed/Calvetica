//
//  CVDefaultLanguageViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDefaultLanguageViewController.h"



@implementation CVDefaultLanguageViewController


#pragma mark - Constructor

- (id)init 
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.availableLanguages = [self getTranslatedLanguages];
    }
    return self;
}



#pragma mark - View lifecycle

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Default Language", @"Navigation item to Default Language");
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}




#pragma mark - Public Methods
- (NSString *)languageStringFromCode:(NSString *)languageCode 
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:languageCode];
    
    return [locale displayNameForKey:NSLocaleIdentifier value:[locale localeIdentifier]];
}

- (NSArray *)getTranslatedLanguages 
{
    
    NSString *path = [[NSBundle mainBundle] bundlePath];    
    NSError *error;
    NSArray *pathComps = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    NSMutableArray *availableLanguageCodes = [NSMutableArray array];
    
    for (NSString *file in pathComps) {
        if ([file hasSuffix:@"lproj"]) {
            [availableLanguageCodes addObject:[file stringByDeletingPathExtension]];
        }
    }
    
    return [NSArray arrayWithArray:availableLanguageCodes];
}


#pragma mark - Private Methods




#pragma mark - IBActions




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.availableLanguages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleSubtitle forTableView:tableView];
    
    NSString *languageCode = [self.availableLanguages objectAtIndex:indexPath.row];
    NSString *languageString = [self languageStringFromCode:languageCode];

    cell.textLabel.font         = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font   = [UIFont systemFontOfSize:15];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = languageString;
    
    if ([languageCode isEqualToString:[CVSettings defaultLanguage]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *selectedCode = [self.availableLanguages objectAtIndex:indexPath.row];
    NSString *languageCode = [NSString stringWithString:selectedCode];
    
    // alert user that app restart is required
    if (![languageCode isEqualToString:[CVSettings defaultLanguage]]) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Application restart required!"
                                   message:@"Please restart Calvetica for the changes to take effect"
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
    }
    
    // save this as the new preferred languages list
    NSMutableArray *newLangPrefs = [NSMutableArray arrayWithArray:self.availableLanguages];
    [newLangPrefs removeObjectAtIndex:indexPath.row];
    [newLangPrefs insertObject:languageCode atIndex:0];
    [CVSettings setDefaultLanguage:newLangPrefs];
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Available languages", @"The header of a table with a list of available languages");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    return NSLocalizedString(@"Select a language to set the default language", @"Instructions to the user as a footer on a table");
}

@end
