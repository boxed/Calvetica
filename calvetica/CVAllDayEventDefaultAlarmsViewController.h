//
//  CVAllDayEventDefaultAlarmsViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "times.h"


@protocol CVAllDayEventDefaultAlarmsViewControllerDelegate;


@interface CVAllDayEventDefaultAlarmsViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, weak) id<CVAllDayEventDefaultAlarmsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *selectedAlarms;
@property (nonatomic, strong) NSMutableArray *alarms;

#pragma mark - Public Methods
+ (NSMutableDictionary *)alarmDictionary:(NSString *)title value:(NSNumber *)value selected:(BOOL)isSelected;

#pragma mark - Notifications

@end
