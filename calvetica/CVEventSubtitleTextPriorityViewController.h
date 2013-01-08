//
//  CVEventDetailsSubtitleTextOrderViewController.h
//  calvetica
//
//  Created by James Schultz on 5/12/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"


@interface CVEventSubtitleTextPriorityViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *subtitleTextPriorityArray;

+ (NSMutableArray *)standardSubtitleTextPriorityArray;

@end
