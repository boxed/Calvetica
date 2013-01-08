
#import "CVEventSquare.h"



@implementation CVEventSquare


- (id)init 
{
    if ((self = [super init])) {
		_consideredAllDay = NO;
        _isPassed = NO;
		_startSeconds = -1;
		_endSeconds = -1;
		_offset = 0;
		_overlaps = 1;
        _days = malloc(7 * sizeof(NSInteger));
        memset(_days, 0, 7 * sizeof(NSInteger));
    }
    return self;
}





@end
