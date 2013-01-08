
@interface EKCalendar (Utilities)

- (NSString *)account;
- (BOOL)isASelectedCalendar;
- (UIColor *)customColor;
- (void)setCustomColor:(UIColor *)color;
- (NSString *)sourceString;
- (NSInteger)indexOfCalendarEditable:(BOOL)editable;
- (BOOL)canAddAttendees;
- (BOOL)save;
- (BOOL)remove;

@end
