//
//  CVEventDetailsOrderViewController.h
//  calvetica
//
//  Created by James Schultz on 5/12/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVEventDetailsOrderViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *detailsOrderArray;


+ (NSMutableArray *)standardDetailsOrderingArray;

@end

NS_ASSUME_NONNULL_END
