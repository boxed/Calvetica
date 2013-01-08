
#import "CVReminderSquare.h"



@implementation CVReminderSquare




- (id)init 
{
    if ((self = [super init])) {
        _isPassed = NO;
		_appearOnDate = nil;
        _days = malloc(7 * sizeof(NSInteger));
        _shape = CVColoredShapeCircle;
        memset(_days, 0, 7 * sizeof(NSInteger));
    }
    return self;
}





@end
