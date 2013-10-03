//
//  CVWeekdayTableHeaderView.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWeekdayTableHeaderView.h"
#import "colors.h"
#import "times.h"

#define NUM_LABELS 25
#define TAG_OFFSET 99


@interface CVWeekdayTableHeaderView ()
@property (nonatomic, weak) IBOutlet UIView *redBar;
@end



@implementation CVWeekdayTableHeaderView


- (void)setDate:(NSDate *)newDate 
{
    _date = newDate;
    self.weekNumberLabel.text = [NSString stringWithFormat:@"%d",[newDate mt_weekOfYear]];
}

- (void)didMoveToWindow
{
	CGFloat rowHeight = (self.bounds.size.height - _redBar.frame.size.height) / (float)NUM_LABELS;
	for (NSInteger i = 0; i <= NUM_LABELS; i++) {
		UILabel *hourLabel = (UILabel *)[self viewWithTag:i + TAG_OFFSET];
		if ([CVSettings isTwentyFourHourFormat] && i > 0)
			hourLabel.text = [NSString stringWithFormat:@"%d", i - 1];
		CGRect f		= hourLabel.frame;
		f.size.height	= rowHeight;
		f.size.width	= self.bounds.size.width - 5;
		f.origin.x		= 0;
		f.origin.y		= _redBar.frame.size.height + (rowHeight * i);
		hourLabel.frame = f;
	}
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 0.5f);
    
    // add the heights of the mont hand year label to get
    CGFloat offset = _weekNumberLabel.frame.size.height;
    CGFloat h = self.bounds.size.height;
    CGFloat viewHeight = h - offset;
    
    // DRAW BACKGROUND LINES
	
    // border line
    
    NSInteger numLines = 25;
    CGFloat distanceBetweenLines = viewHeight / numLines;

	for (int i = 1; i < numLines; i++) {
        CGFloat y = offset + floorf(distanceBetweenLines * i) + 0.5f;
        CGContextSetStrokeColorWithColor(context, [patentedBlack CGColor]);
		CGContextMoveToPoint(context, 0, y);
		CGContextAddLineToPoint(context, viewHeight, y);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [patentedVeryDarkGray CGColor]);
		CGContextMoveToPoint(context, 0, y + 0.5f);
		CGContextAddLineToPoint(context, viewHeight, y + 0.5f);
        CGContextStrokePath(context);
	}
}




@end
