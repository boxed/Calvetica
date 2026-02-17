//
//  EKEventStore+Events.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface EKEventStore (Events)

+ (NSArray *)eventsFromDate:(NSDate *)startDate toDate:(NSDate *)endDate forActiveCalendars:(BOOL)activeCalsOnly;

//+ (NSArray *)chainedEventModelsFromDate:(NSDate *)startDate
//                                 toDate:(NSDate *)endDate
//                     forActiveCalendars:(BOOL)activeCalsOnly
//                    includeAllDayEvents:(BOOL)includeAllDayEvents;

+ (NSArray *)eventsSearchedWithText:(NSString *)text
                          startDate:(NSDate *)startDate
                            endDate:(NSDate *)endDate
                 forActiveCalendars:(BOOL)activeCalsOnly;

@end

NS_ASSUME_NONNULL_END
