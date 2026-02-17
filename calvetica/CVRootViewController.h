//
//  CVRootViewController.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVViewController.h"
#import "CVMonthTableViewController.h"
#import "CVRootTableViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVRootViewController : CVViewController

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *todaysDate;

- (void)showQuickAddWithTitle:(NSString *)title date:(NSDate *)date;
- (void)showSnoozeDialogForEvent:(EKEvent *)snoozeEvent;
- (void)refreshUIAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
