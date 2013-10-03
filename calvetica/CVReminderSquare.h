

#import "CVColoredDotView.h"


@interface CVReminderSquare : NSObject {}
@property (nonatomic, strong) EKReminder     *reminder;
@property (nonatomic, assign) BOOL           isPassed;
@property (nonatomic, strong) NSDate         *appearOnDate;
@property (nonatomic, assign) CVColoredShape shape;
@property (nonatomic, assign) CGFloat        x;
@property (nonatomic, assign) CGFloat        y;
@property (nonatomic, assign) CGFloat        width;
@property (nonatomic, assign) CGFloat        height;
@property (nonatomic, assign) NSInteger      *days;
@property (nonatomic, strong  ) NSMutableArray *sharedReminders;
@end