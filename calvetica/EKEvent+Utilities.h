

#import "times.h"
#import "EKEvent+Utilities.h"
#import "EKRecurrenceRule+Utilities.h"
#import "CVEventStore.h"
#import "strings.h"




@interface EKEvent (Utilities)


@property (nonatomic, strong) NSDate *startingDate;
@property (nonatomic, strong) NSDate *endingDate;


#pragma mark - CONSTRUCTORS

+ (EKEvent *)eventWithDefaultsAtDate:(NSDate *)date allDay:(BOOL)isAllDay;
+ (EKEvent *)eventWithDefaultsAtStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)isAllDay;
+ (EKEvent *)eventWithDefaultsAtStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)isAllDay calendar:(EKCalendar *)cal;


#pragma mark - Methods
- (BOOL)hadRecurrenceRuleOnPreviousSave;
- (void)shiftEndDateBySettingStartDate:(NSDate *)newDate;
- (void)saveThenDoActionBlock:(void (^)(void))saveActionBlock cancelBlock:(void (^)(void))cancelBlock;
- (void)saveForThisOccurrence;
- (void)removeThenDoActionBlock:(void (^)(void))removeActionBlock cancelBlock:(void (^)(void))cancelBlock;
- (void)addSnoozeAlarmWithTimeInterval:(NSTimeInterval)interval;
- (void)resetDefaultAlarms;
- (void)resetDurationToDefault;
- (BOOL)isACurrentAlarm:(EKAlarm *)alarm;

#pragma mark - COMPARATORS

- (BOOL)startsOnSameDayAsDate:(NSDate *)dayDate;

#pragma mark - UTILITIES

- (EKCalendar *)readCalendar;
- (NSTimeInterval)eventDuration;
- (CGFloat)percentOfDay;
- (CGFloat)durationBarSecondsForDate:(NSDate *)date;
- (BOOL)occursAtAllOnDate:(NSDate *)date;
- (BOOL)spansEntireDayOfDate:(NSDate *)date;
- (BOOL)spansEntireDayOfOnlyDate:(NSDate *)date;
- (BOOL)fitsWithinDayOfDate:(NSDate *)date;
- (BOOL)fitsWithinWeekOfDate:(NSDate *)date;
- (BOOL)willBeABar;

#pragma mark - STRINGS
- (NSString *)availabilityAsString;
- (NSString *)stringForParticipantStatus: (EKParticipantStatus)status;
- (NSString *)serialize;
- (NSString *)readTitle;

- (NSString *)stringWithRelativeEndTime;
- (NSString *)stringWithRepeat;
- (NSString *)stringWithRelativeEndTimeAndRepeat;
- (NSString *)stringWithLocation;
- (NSString *)stringWithNotes;
- (NSString *)stringWithPeople;

- (NSString *)naturalDescription;
- (NSString *)naturalDescriptionSMS;
- (NSString *)iCalString;

@end
