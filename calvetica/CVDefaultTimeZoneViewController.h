//
//  CVDefaultTimeZoneViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"

// calv4.3 lots of changes in this file can keep all

@protocol CVDefaultTimeZoneViewControllerDelegate;


@interface CVDefaultTimeZoneViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, strong) NSArray *availableTimeZones;
@property (nonatomic, strong) UISwitch *timeZonesSwitch;

#pragma mark - Public Methods
- (void)timeZoneSwitchToggled:(id)sender;

#pragma mark - Notifications

@end