NS_ASSUME_NONNULL_BEGIN

@interface EKEvent (Utilities)

@property (nonatomic, strong) NSDate *startingDate;
@property (nonatomic, strong) NSDate *endingDate;

+ (EKEvent *)eventWithDefaultsAtDate:(NSDate *)date allDay:(BOOL)isAllDay;
+ (EKEvent *)eventWithDefaultsAtStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)isAllDay;
+ (EKEvent *)eventWithDefaultsAtStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)isAllDay calendar:(EKCalendar *)cal;


- (BOOL)hadRecurrenceRuleOnPreviousSave;
- (void)shiftEndDateBySettingStartDate:(NSDate *)newDate;
- (void)addSnoozeAlarmWithTimeInterval:(NSTimeInterval)interval;
- (void)resetDefaultAlarms;
- (void)resetDurationToDefault;
- (BOOL)isACurrentAlarm:(EKAlarm *)alarm;

- (EKCalendar *)readCalendar;
- (NSTimeInterval)eventDuration;
- (BOOL)fitsWithinWeekOfDate:(NSDate *)date;
#pragma mark - STRINGS
- (NSString *)availabilityAsString;
- (NSString *)stringForParticipantStatus: (EKParticipantStatus)status;
- (NSString *)serialize;

- (NSString *)stringWithRelativeEndTime;
- (NSString *)stringWithRepeat;
- (NSString *)stringWithRelativeEndTimeAndRepeat;
- (NSString *)stringWithLocation;
- (NSString *)stringWithNotes;
- (NSString *)stringWithPeople;
- (NSString *)stringWithVideoLink;
- (NSURL *)videoConferenceURL;

- (NSString *)naturalDescription;
- (NSString *)naturalDescriptionSMS;
- (NSString *)iCalString;

@end

NS_ASSUME_NONNULL_END