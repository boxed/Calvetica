

@interface CVEventSquare : NSObject

@property (nonatomic, strong) EKEvent *event;
@property (nonatomic) BOOL consideredAllDay;
@property (nonatomic) BOOL isPassed;
@property (nonatomic) NSInteger startSeconds;
@property (nonatomic) NSInteger endSeconds;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger overlaps;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) NSInteger *days;
@property (nonatomic, strong) NSMutableArray *sharedEvents;

@end