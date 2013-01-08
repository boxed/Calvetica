//
//  UITableViewCell+Nibs.m
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCell+Nibs.h"


@implementation UITableViewCell (UITableViewCell_Nibs)

#pragma mark - Convenience Constructors

+ (id)cellWithStyle:(UITableViewCellStyle)style forTableView:(UITableView *)tableView {
    NSString *cellID = [self className];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:cellID];
    }
    
    return cell;
}

+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = [self className];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [self viewFromNib:nib];
    }
    return cell;
}

@end
