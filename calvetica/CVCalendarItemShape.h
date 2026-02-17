


NS_ASSUME_NONNULL_BEGIN

@interface CVCalendarItemShape : NSObject

@property (nonatomic, strong) EKCalendarItem *calendarItem;
@property (nonatomic, assign) BOOL           consideredAllDay;
@property (nonatomic, assign) BOOL           isPassed;
@property (nonatomic, assign) NSInteger      startSeconds;
@property (nonatomic, assign) NSInteger      endSeconds;
@property (nonatomic, assign) NSInteger      offset;
@property (nonatomic, assign) NSInteger      overlaps;
@property (nonatomic, assign) CGFloat        x;
@property (nonatomic, assign) CGFloat        y;
@property (nonatomic, assign) CGFloat        width;
@property (nonatomic, assign) CGFloat        height;
@property (nonatomic, assign) NSUInteger     *days;
@property (nonatomic, strong) NSMutableArray<CVCalendarItemShape *> *sharedEvents;

@end

NS_ASSUME_NONNULL_END