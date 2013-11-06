//
//  EKCalendar+Identity.h
//  calvetica
//
//  Created by Adam Kirk on 11/5/13.
//
//

#import <EventKit/EventKit.h>

@interface EKCalendar (Identity)
@property (nonatomic, strong, readonly) NSString *calendarExternalIdentifier;
@property (nonatomic, strong, readonly) NSString *accountName;
@property (nonatomic, strong, readonly) NSString *sourceString;

+ (instancetype)calendarWithExternalIdentifier:(NSString *)externalIdentifier;
@end
