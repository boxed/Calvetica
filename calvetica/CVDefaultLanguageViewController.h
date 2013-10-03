//
//  CVDefaultLanguageViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"


@protocol CVDefaultLanguageViewControllerDelegate;


@interface CVDefaultLanguageViewController : UITableViewController

@property (nonatomic, copy) NSArray *availableLanguages;

- (NSString *)languageStringFromCode:(NSString *)languageCode;
- (NSArray *)getTranslatedLanguages;

@end
