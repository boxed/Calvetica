//
//  UITableViewCell+Nibs.h
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Nibs)
+ (id)cellWithStyle:(UITableViewCellStyle)style forTableView:(UITableView *)tableView;
+ (id)cellForTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END