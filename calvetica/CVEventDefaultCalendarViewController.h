//
//  CVEventDefaultCalendarViewController.h
//  calvetica
//
//  Created by James Schultz on 5/19/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CVEventDefaultCalendarViewController : UITableViewController
@property (nonatomic, copy) NSArray<EKCalendar *> *availableCalendars;
@end

NS_ASSUME_NONNULL_END