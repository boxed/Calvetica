//
//  CVReminderDetailsOrderViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"


@interface CVReminderDetailsOrderViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *detailsOrderArray;

+ (NSMutableDictionary *)detailsDictionary:(NSString *)title hidden:(BOOL)isHidden;
+ (NSMutableArray *)standardDetailsOrderingArray;

@end
