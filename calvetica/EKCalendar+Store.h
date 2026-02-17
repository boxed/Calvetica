//
//  EKEventStore+Shared.h
//  calvetica
//
//  Created by Adam Kirk on 4/21/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@interface EKCalendar (Store)
- (BOOL)saveWithError:(NSError **)error;
- (BOOL)removeWithError:(NSError **)error;
@end

NS_ASSUME_NONNULL_END