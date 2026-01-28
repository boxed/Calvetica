//
//  CVAllDayEventSquareView_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAllDayEventSquaresView.h"
#import "CVCalendarItemShape.h"
#import "UIColor+Calvetica.h"
#import "colors.h"
#import "geometry.h"
#import "times.h"
#import "UIColor+Compare.h"


@implementation CVAllDayEventSquaresView

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
    // Gestures temporarily disabled for debugging scrolling issues
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleTapGesture:)];
//    [self addGestureRecognizer:tapGesture];
//
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(handleLongPressGesture:)];
//    [self addGestureRecognizer:longPressGesture];

	[super awakeFromNib];
}




#pragma mark - Methods

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 0.5f);

    // In rotated mode (height > width), squares stack vertically
    // In normal mode (width > height), squares stack horizontally
    BOOL isRotated = self.bounds.size.height > self.bounds.size.width;

    // DRAW BACKGROUND LINES

    // border line
    CGContextSetStrokeColorWithColor(context, [calTertiaryText() CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    if (isRotated) {
        CGContextAddLineToPoint(context, self.bounds.size.width, 0);
        CGContextMoveToPoint(context, self.bounds.size.width, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    } else {
        CGContextAddLineToPoint(context, 0, self.bounds.size.height);
        CGContextMoveToPoint(context, 0, self.bounds.size.height);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    }
    CGContextStrokePath(context);


    // DRAW SQAURES
	CGFloat padding = 1.0f;
    NSInteger squareCount = _squares.count > 0 ? _squares.count : 1;
    NSInteger offset = 0;

    for (CVCalendarItemShape *e in _squares) {

        if (isRotated) {
            CGFloat squareHeight = self.bounds.size.height / squareCount;
            e.width = self.bounds.size.width;
            e.x = 0;
            e.height = squareHeight;
            e.y = offset++ * e.height;
        } else {
            CGFloat squareWidth = self.bounds.size.width / squareCount;
            e.height = self.bounds.size.height;
            e.y = 0;
            e.width = squareWidth;
            e.x = offset++ * e.width;
        }

        // apply padding
        e.x += padding;
        e.y += padding;
        e.width -= (padding * 2.0f);
        e.height -= (padding * 2.0f);

        // if this is the first square, bring it in from the edge
        if (e.offset == 0) {
            if (isRotated) {
                e.y += 1;
                e.height -= 1;
            } else {
                e.x += 1;
                e.width -= 1;
            }
        }

        
        UIColor *calendarColor = [e.calendarItem.calendar customColor];
        CGColorRef c = [calendarColor CGColor];
        
        CGRect boxFrame = CGRectMake(e.x, e.y, e.width, e.height);
        
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, c);
        
        if (PAD) {
            CVContextFillRoundedRect(context, boxFrame, 4.0f);
        }
        else {
            CVContextFillRoundedRect(context, boxFrame, 2.0f);
        }
        
        CGContextRestoreGState(context);
        
        
        // event text
        // event text color
        if([calendarColor shouldUseLightText]) {
            CGContextSetFillColorWithColor(context, [calBackgroundColor() CGColor]);
        }
        else {
            CGContextSetFillColorWithColor(context, [calTextColor() CGColor]);
        }
        
        CGRect textFrame = boxFrame;
        textFrame.origin.x += 3.0f;
        textFrame.size.width -= 6.0f;
        
//        if (PAD) {
//            textFrame.origin.y += 1.0f;
//            textFrame.size.height -= 2.0f;
//        }
//        else {
//            //textFrame.origin.y += 1.0f;
//            //textFrame.size.height -= 2.0f;
//        }
        
        NSString *title = [e.calendarItem mys_title];
        [title drawInRect:textFrame withFont:[UIFont systemFontOfSize:9.0f]];
    }
}




#pragma mark - IBActions

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture 
{
	if (gesture.state != UIGestureRecognizerStateEnded) return;
    
    // figure event
    CGPoint pointOfTouch = [gesture locationInView:self];
    for (CVCalendarItemShape *e in _squares) {
        CGRect rectOfEvent = CGRectMake(e.x, e.y, e.width, e.height);
        if (CGRectContainsPoint(rectOfEvent, pointOfTouch)) {
            
            // create view to point to
            UIView *placeholder = [[UIView alloc] initWithFrame:rectOfEvent];
            placeholder.backgroundColor = calTextColor();
            placeholder.alpha = 0.3f;
            [self addSubview:placeholder];
            
            [_delegate allDaySquaresView:self wasPressedOnEvent:(EKEvent *)e.calendarItem withPlaceholder:placeholder];
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
    CGFloat nearestHour = floorf(percentThroughDay * MTDateConstantHoursInDay);
    NSDate *dateToReturn = [[self.date mt_startOfCurrentDay] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:nearestHour minutes:0 seconds:0];

    // create view to point to
    UIView *placeholder = [[UIView alloc] initWithFrame:self.bounds];
    placeholder.backgroundColor = calTextColor();
    placeholder.alpha = 0.3f;
    [self addSubview:placeholder];
    
    [_delegate allDaySquaresView:self wasLongPressedAtDate:dateToReturn allDay:YES withPlaceholder:placeholder];
}



@end
