//
//  UITableViewCell+Nibs.h
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+nibs.h"

@interface UITableViewCell (UITableViewCell_Nibs)

+ (id)cellWithStyle:(UITableViewCellStyle)style forTableView:(UITableView *)tableView;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;

@end
