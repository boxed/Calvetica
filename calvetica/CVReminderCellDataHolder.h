//
//  CVReminderCellDataHolder.h
//  calvetica
//
//  Created by Adam Kirk on 5/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDataHolder.h"
#import "CVReminderCell.h"


@interface CVReminderCellDataHolder : CVDataHolder

@property (nonatomic, strong) EKReminder *reminder;
@property (nonatomic, strong) id cell;
@property (nonatomic, strong) NSDate *date;

@end
