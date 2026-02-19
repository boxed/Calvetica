//
//  CVEventDefaultAlarmsViewController.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN



@interface CVEventDefaultAlarmsViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedAlarms;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *alarms;
@end

NS_ASSUME_NONNULL_END
