//
//  CVSettingNavigationController.m
//  calvetica
//
//  Created by Adam Kirk on 9/25/12.
//
//

#import "CVSettingNavigationController.h"



@implementation CVSettingNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        [[UITableView appearanceWhenContainedIn:[CVSettingNavigationController class], nil] setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1]];
		[[UILabel appearanceWhenContainedIn:[UITableViewCell class], [CVSettingNavigationController class], nil] setTextColor:[UIColor colorWithWhite:0.32 alpha:1]];
		[[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], [CVSettingNavigationController class], nil] setTextColor:[UIColor colorWithWhite:0.32 alpha:1]];
    }
    return self;
}

@end
