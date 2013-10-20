//
//  EKEvent+Sorting.h
//  calvetica
//
//  Created by Adam Kirk on 10/16/13.
//
//

#import <EventKit/EventKit.h>

@interface EKEvent (Sorting)
- (NSComparisonResult)compareWithEvent:(EKEvent *)event;
@end
