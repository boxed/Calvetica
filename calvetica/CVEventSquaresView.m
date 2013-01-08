//
//  CVSquaresView_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKCalendar+Utilities.h"
#import "CVLandscapeWeekView.h"
#import "CVEventSquaresView.h"
#import "EKEvent+Utilities.h"
#import "CVEventSquare.h"
#import "dimensions.h"
#import "geometry.h"
#import "colors.h"
#import "times.h"




@implementation CVEventSquaresView

- (void)setSquares:(NSArray *)newSquares 
{
    _squares = newSquares;
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}




#pragma mark - Constructor

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}




#pragma mark - Memory Management





#pragma mark - View lifecycle

- (void)awakeFromNib 
{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
    
    [super awakeFromNib];
}




#pragma mark - Methods

- (void)drawRect:(CGRect)rect 
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 0.5f);
    
    
    // DRAW BACKGROUND LINES
    
    NSInteger numLines = 24;
    CGFloat distanceBetweenLines = self.bounds.size.height / numLines;
    
	for (int i = 0; i < numLines; i++) {
        CGFloat y = round(distanceBetweenLines * i);
        CGContextSetStrokeColorWithColor(context, [patentedLightGray CGColor]);
		CGContextMoveToPoint(context, 0, y);
		CGContextAddLineToPoint(context, self.bounds.size.width, y);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [patentedWhite CGColor]);
		CGContextMoveToPoint(context, 0, y + 0.5f);
		CGContextAddLineToPoint(context, self.bounds.size.width, y);
        CGContextStrokePath(context);
	}
    
    // border line
    CGContextSetStrokeColorWithColor(context, [patentedLightGray CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextSetShouldAntialias(context, YES);
    
    
    // DRAW SQAURES
	CGFloat padding = 1.0f;
    
    for (CVEventSquare *e in _squares) {
        
        NSInteger startSecondsIntoDay;
        NSInteger endSecondsIntoDay;
        
        // set the Y COORD
        
        // if it starts before this day
        if (e.startSeconds <= 0) {
            startSecondsIntoDay = 0;
            e.y = 0;
            
            // otherwise it starts on this day
        } else {
            startSecondsIntoDay = e.startSeconds % SECONDS_IN_DAY;
            e.y = (startSecondsIntoDay / (float)SECONDS_IN_DAY) * self.frame.size.height;	
        }
        
        
        // set the height
        
        // if it ends after the end of this day
        if (e.endSeconds >= SECONDS_IN_DAY) {
            e.height = self.frame.size.height - e.y;
        } 
        
        // otherise, it ends within this day
        else {
            endSecondsIntoDay = e.endSeconds % SECONDS_IN_DAY;
            e.height = ((endSecondsIntoDay - startSecondsIntoDay) / (float)SECONDS_IN_DAY) * self.frame.size.height;	
        }
        
        e.width = (self.bounds.size.width / e.overlaps);
        e.x = e.offset * e.width;
        
        e.x += padding;
        e.y += padding;
        e.width -= (padding * 2.0f);
        e.height -= (padding * 2.0f);
        
        //        // bring it up a pixel so the box fill color lines up with the horizontal line
        //        e.y--;
        //        e.height++;
        
        // if this is the far left or far right, bring it in from the edge
        if (e.offset == 0) {
            e.x += 1;
            e.width -= 1;
        }
        
        // make sure square is tall enough to contain its title text
        if (e.height < EVENT_SQUARE_MIN_HEIGHT_IPHONE) {
            e.height = EVENT_SQUARE_MIN_HEIGHT_IPHONE;
        }
        
        UIColor *calendarColor = [e.event.calendar customColor];
        CGColorRef c = [calendarColor CGColor];
        
        CGRect boxFrame = CGRectMake(e.x, e.y, e.width, e.height);
        
        CGContextSetFillColorWithColor(context, c);
        CGContextSetStrokeColorWithColor(context, [patentedVeryLightGray CGColor]);
        CGContextSetLineWidth(context, 2.0f);
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5, [patentedVeryLightGray CGColor]);
        
        if (PAD) {
            CVContextFillRoundedRect(context, boxFrame, 4.0f);
        }
        else {
            CVContextFillRoundedRect(context, boxFrame, 2.0f);
        }
        CGContextRestoreGState(context);
        
        
        
        // event text color
        if([calendarColor shouldUseLightText]) {
            CGContextSetFillColorWithColor(context, [patentedWhite CGColor]);
        }
        else {
            CGContextSetFillColorWithColor(context, [patentedBlack CGColor]);
        }
        
        CGRect textFrame = boxFrame;
        textFrame.origin.x += 3.0f;
        textFrame.size.width -= 6.0f;
        
        if (PAD) {
            textFrame.origin.y += 1.0f;
            textFrame.size.height -= 2.0f;
        }
        else {
            //textFrame.origin.y += 1.0f;
            //textFrame.size.height -= 2.0f;
        }
        
        NSString *title = [e.event readTitle];
        [title drawInRect:textFrame withFont:[UIFont systemFontOfSize:9.0f]];
    }
}




#pragma mark - IBActions

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateEnded) return;
    
    // figure event
    CGPoint pointOfTouch = [gesture locationInView:self];
    for (CVEventSquare *e in _squares) {
        CGRect rectOfEvent = CGRectMake(e.x, e.y, e.width, e.height);
        if (CGRectContainsPoint(rectOfEvent, pointOfTouch)) {
            
            // create view to point to
            UIView *placeholder = [[UIView alloc] initWithFrame:rectOfEvent];
            placeholder.backgroundColor = patentedBlack;
            placeholder.alpha = 0.3f;
            [self addSubview:placeholder];
            
            [_delegate squaresView:self wasPressedOnEvent:e.event withPlaceholder:placeholder];
            break;
        }
    }
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    // figure the date
    CGPoint pointOfTouch = [gesture locationInView:self];
    CGFloat percentThroughDay = pointOfTouch.y / self.bounds.size.height;
    CGFloat nearestHour = floorf(percentThroughDay * HOURS_IN_DAY);
    NSDate *dateToReturn = [[self.date startOfCurrentDay] dateByAddingYears:0 months:0 weeks:0 days:0 hours:nearestHour minutes:0 seconds:0];
    
    // figure placholder rect
    CGFloat hourHeight = self.bounds.size.height / HOURS_IN_DAY;
    CGFloat bottomY = hourHeight * nearestHour;
    CGFloat topY = hourHeight * (nearestHour + 1);
    CGRect placeholderRect = CGRectMake(0, bottomY, self.bounds.size.width, (topY - bottomY));
    
    // create view to point to
    UIView *placeholder = [[UIView alloc] initWithFrame:placeholderRect];
    placeholder.backgroundColor = patentedBlack;
    placeholder.alpha = 0.3f;
    [self addSubview:placeholder];
    
    [_delegate squaresView:self wasLongPressedAtDate:dateToReturn allDay:NO withPlaceholder:placeholder];
}



@end
