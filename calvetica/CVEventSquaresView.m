//
//  CVSquaresView_iPad.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVLandscapeWeekView.h"
#import "CVEventSquaresView.h"
#import "CVCalendarItemShape.h"
#import "UIColor+Calvetica.h"
#import "UIColor+Compare.h"
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

- (instancetype)initWithFrame:(CGRect)frame 
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
    CGContextSetShouldAntialias(context, NO);
	CGContextSetLineWidth(context, 0.5f);

    // In rotated mode, width is the time dimension; in normal mode, height is
    BOOL isRotated = self.bounds.size.width > self.bounds.size.height;
    CGFloat timeDimension = isRotated ? self.bounds.size.width : self.bounds.size.height;
    CGFloat columnDimension = isRotated ? self.bounds.size.height : self.bounds.size.width;

    // DRAW BACKGROUND LINES

    NSInteger numLines = 24;
    CGFloat distanceBetweenLines = timeDimension / numLines;

	for (int i = 0; i < numLines; i++) {
        CGFloat pos = floorf(distanceBetweenLines * i);
        CGContextSetStrokeColorWithColor(context, [calGridLineColor() CGColor]);
        if (isRotated) {
            CGContextMoveToPoint(context, pos, 0);
            CGContextAddLineToPoint(context, pos, columnDimension);
        } else {
            CGContextMoveToPoint(context, 0, pos);
            CGContextAddLineToPoint(context, columnDimension, pos);
        }
        CGContextStrokePath(context);
	}

    // border line
    CGContextSetStrokeColorWithColor(context, [calGridLineColor() CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    if (isRotated) {
        CGContextAddLineToPoint(context, 0, columnDimension);
    } else {
        CGContextAddLineToPoint(context, 0, timeDimension);
    }
    CGContextStrokePath(context);

    CGContextSetShouldAntialias(context, YES);


    // DRAW SQAURES
	CGFloat padding = 1.0f;

    for (CVCalendarItemShape *e in _squares) {

        NSInteger startSecondsIntoDay;
        NSInteger endSecondsIntoDay;
        CGFloat eventTimePos;   // position along time axis (x in rotated, y in normal)
        CGFloat eventTimeSize;  // size along time axis (width in rotated, height in normal)

        // set the time position

        // if it starts before this day
        if (e.startSeconds <= 0) {
            startSecondsIntoDay = 0;
            eventTimePos = 0;

            // otherwise it starts on this day
        } else {
            startSecondsIntoDay = e.startSeconds % MTDateConstantSecondsInDay;
            eventTimePos = (startSecondsIntoDay / (float)MTDateConstantSecondsInDay) * timeDimension;
        }


        // set the time size

        // if it ends after the end of this day
        if (e.endSeconds >= MTDateConstantSecondsInDay) {
            eventTimeSize = timeDimension - eventTimePos;
        }

        // otherise, it ends within this day
        else {
            endSecondsIntoDay = e.endSeconds % MTDateConstantSecondsInDay;
            eventTimeSize = ((endSecondsIntoDay - startSecondsIntoDay) / (float)MTDateConstantSecondsInDay) * timeDimension;
        }

        CGFloat eventColumnSize = (columnDimension / e.overlaps);
        CGFloat eventColumnPos = e.offset * eventColumnSize;

        if (isRotated) {
            e.x = eventTimePos;
            e.y = eventColumnPos;
            e.width = eventTimeSize;
            e.height = eventColumnSize;
        } else {
            e.x = eventColumnPos;
            e.y = eventTimePos;
            e.width = eventColumnSize;
            e.height = eventTimeSize;
        }
        
        e.x += padding;
        e.y += padding;
        e.width -= (padding * 2.0f);
        e.height -= (padding * 2.0f);

        // if this is the first in the column, bring it in from the edge
        if (e.offset == 0) {
            if (isRotated) {
                e.y += 1;
                e.height -= 1;
            } else {
                e.x += 1;
                e.width -= 1;
            }
        }

        // make sure square is big enough to contain its title text
        if (isRotated) {
            if (e.width < EVENT_SQUARE_MIN_HEIGHT_IPHONE) {
                e.width = EVENT_SQUARE_MIN_HEIGHT_IPHONE;
            }
        } else {
            if (e.height < EVENT_SQUARE_MIN_HEIGHT_IPHONE) {
                e.height = EVENT_SQUARE_MIN_HEIGHT_IPHONE;
            }
        }
        
        UIColor *calendarColor = [e.calendarItem.calendar customColor];
        CGColorRef c = [calendarColor CGColor];
        
        CGRect boxFrame = CGRectMake(e.x, e.y, e.width, e.height);
        
        CGContextSetFillColorWithColor(context, c);
        CGContextSetStrokeColorWithColor(context, [calBorderColorLight() CGColor]);
        CGContextSetLineWidth(context, 2.0f);
        
        CGContextSaveGState(context);
        
        if (PAD) {
            CVContextFillRoundedRect(context, boxFrame, 4.0f);
        }
        else {
            CVContextFillRoundedRect(context, boxFrame, 2.0f);
        }
        CGContextRestoreGState(context);
        
        
        
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
        
        if (PAD) {
            textFrame.origin.y += 1.0f;
            textFrame.size.height -= 2.0f;
        }
        else {
            //textFrame.origin.y += 1.0f;
            //textFrame.size.height -= 2.0f;
        }
        
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
            
            [_delegate squaresView:self wasPressedOnEvent:(EKEvent *)e.calendarItem withPlaceholder:placeholder];
            break;
        }
    }
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;

    BOOL isRotated = self.bounds.size.width > self.bounds.size.height;
    CGFloat timeDimension = isRotated ? self.bounds.size.width : self.bounds.size.height;
    CGFloat columnDimension = isRotated ? self.bounds.size.height : self.bounds.size.width;

    // figure the date
    CGPoint pointOfTouch = [gesture locationInView:self];
    CGFloat touchTimePos = isRotated ? pointOfTouch.x : pointOfTouch.y;
    CGFloat percentThroughDay = touchTimePos / timeDimension;
    CGFloat nearestHour = (percentThroughDay * MTDateConstantHoursInDay);
    NSDate *dateToReturn = [[self.date mt_startOfCurrentDay] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:nearestHour minutes:0 seconds:0];

    // figure placeholder rect
    CGFloat hourSize = timeDimension / MTDateConstantHoursInDay;
    CGFloat startPos = hourSize * nearestHour;
    CGFloat endPos = hourSize * (nearestHour + 1);
    CGRect placeholderRect;
    if (isRotated) {
        placeholderRect = CGRectMake(startPos, 0, (endPos - startPos), columnDimension);
    } else {
        placeholderRect = CGRectMake(0, startPos, columnDimension, (endPos - startPos));
    }

    // create view to point to
    UIView *placeholder = [[UIView alloc] initWithFrame:placeholderRect];
    placeholder.backgroundColor = calTextColor();
    placeholder.alpha = 0.3f;
    [self addSubview:placeholder];

    [_delegate squaresView:self wasLongPressedAtDate:dateToReturn allDay:NO withPlaceholder:placeholder];
}



@end
