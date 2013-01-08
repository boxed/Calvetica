//
//  CVDefaultLanguageViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"


@protocol CVDefaultLanguageViewControllerDelegate;


@interface CVDefaultLanguageViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, strong) NSArray *availableLanguages;

#pragma mark - Public Methods
- (NSString *)languageStringFromCode:(NSString *)languageCode;
- (NSArray *)getTranslatedLanguages;



@end
