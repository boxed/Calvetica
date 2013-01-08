

#import "CVColoredDotView.h"


@interface CVReminderSquare : NSObject {}


@property (nonatomic, strong) EKReminder *reminder;
@property (nonatomic) BOOL isPassed;
@property (nonatomic) NSDate *appearOnDate;
@property (nonatomic) CVColoredShape shape;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) NSInteger *days;
@property (nonatomic, strong) NSMutableArray *sharedReminders;


@end