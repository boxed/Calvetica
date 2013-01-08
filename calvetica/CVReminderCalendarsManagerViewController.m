//
//  CVReminderCalendarManagerViewController.m
//  calvetica
//
//  Created by James Schultz on 7/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVReminderCalendarsManagerViewController.h"
#import "private.h"



@implementation CVReminderCalendarsManagerViewController


- (void)awakeFromNib
{
	[super awakeFromNib];
	self.type = EKEntityTypeReminder;
}


@end
