//
//  CVAllDayEventDefaultAlarmsViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "times.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVAllDayEventDefaultAlarmsViewControllerDelegate;


@interface CVAllDayEventDefaultAlarmsViewController : UITableViewController {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, nullable, weak) id<CVAllDayEventDefaultAlarmsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<NSNumber *>                                       *selectedAlarms;
@property (nonatomic, strong) NSMutableArray<NSDictionary *>                                       *alarms;

#pragma mark - Public Methods
+ (NSMutableDictionary *)alarmDictionary:(NSString *)title value:(NSNumber *)value selected:(BOOL)isSelected;

#pragma mark - Notifications

@end

NS_ASSUME_NONNULL_END
