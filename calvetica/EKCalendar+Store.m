//
//  EKEventStore+Shared.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKCalendar+Store.h"


@implementation EKCalendar (Store)

- (BOOL)saveWithError:(NSError **)error
{
    if (![EKEventStore isPermissionGranted]) return nil;
    self.title  = self.title ?: @"Untitled";
    self.source = self.source ?: [EKSource defaultSource];
	return [[EKEventStore sharedStore] saveCalendar:self commit:YES error:error];
}

- (BOOL)removeWithError:(NSError **)error
{
    if (![EKEventStore isPermissionGranted]) return nil;
    return [[EKEventStore sharedStore] removeCalendar:self commit:YES error:error];
}

@end
