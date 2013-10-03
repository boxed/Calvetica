//
//  EKReminder+Calvetica.h
//  calvetica
//
//  Created by Adam Kirk on 8/25/12.
//
//



#import "times.h"
#import "EKRecurrenceRule+Utilities.h"
#import "CVEventStore.h"
#import "strings.h"




@interface EKReminder (Calvetica)

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *dueDate;


#pragma mark - CONSTRUCTORS

+ (EKReminder *)reminderWithDefaultsAtDate:(NSDate *)date;
+ (EKReminder *)reminderWithDefaultsAtStartDate:(NSDate *)startDate dueDate:(NSDate *)dueDate;
+ (EKReminder *)reminderWithDefaultsAtStartDate:(NSDate *)startDate dueDate:(NSDate *)dueDate calendar:(EKCalendar *)cal;
+ (EKReminder *)genericReminderWithStartDate:(NSDate *)startDate;


#pragma mark - Methods
- (void)resetNotes;
- (void)resetLocation;
- (void)resetRecurrenceRule;
- (BOOL)hadRecurrenceRuleOnPreviousSave;
- (NSError *)save;
- (NSError *)remove;
- (void)addSnoozeAlarmWithTimeInterval:(NSTimeInterval)interval;
- (void)resetDefaultAlarms;
- (BOOL)isACurrentAlarm:(EKAlarm *)alarm;
- (NSDate *)startDate;
- (NSDate *)dueDate;
- (NSDate *)preferredDate;

#pragma mark - COMPARATORS

- (BOOL)startsOnSameDayAsDate:(NSDate *)dayDate;

#pragma mark - STRINGS
- (NSString *)stringForParticipantStatus: (EKParticipantStatus)status;
- (NSString *)readTitle;

- (NSString *)subTitle;
- (NSString *)stringWithRepeat;
- (NSString *)stringWithRelativeDueDateAndRepeat;
- (NSString *)stringWithLocation;
- (NSString *)stringWithNotes;
- (NSString *)stringWithPeople;

- (NSString *)naturalDescription;
- (NSString *)naturalDescriptionSMS;
- (NSString *)iCalString;

@end

