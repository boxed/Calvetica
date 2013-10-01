//
//  CVWeekTableViewCell_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWeekTableViewCell.h"
#import "CVWeekTableViewCellReminders.h"
#import "CVWeekTableViewCellEvents.h"
#import "CVEventSquare.h"
#import "CVRootViewController.h"


@implementation CVWeekTableViewCell

#pragma mark - View Lifecycle

- (void)awakeFromNib 
{
    [super awakeFromNib];
    _weekStartDate = nil;
    _selectedDate = nil;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _weekStartDate = nil;
    _selectedDate = nil;
    self.todayImage.hidden = YES;
    [self setNeedsDisplay];
}




#pragma mark - Methods

- (void)setMode:(NSInteger)newMode 
{
    _mode = newMode;
    
    if (self.drawingView.window) {
        [self.drawingView removeFromSuperview];
    }
    
    CGRect f = CGRectZero;
    f.origin.x = 0;
    f.origin.y = 1;
    f.size.width = self.bounds.size.width;
    f.size.height = self.bounds.size.height * 0.8f;
    
    if (self.mode == CVRootViewControllerModeEvents) {
        self.drawingView = [[CVWeekTableViewCellEvents alloc] initWithFrame:f];
    }
    else {
        self.drawingView = [[CVWeekTableViewCellReminders alloc] initWithFrame:f];
    }
    
    self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.drawingView.opaque = NO;
    self.drawingView.delegate = self;
    [self addSubview:self.drawingView];
}

- (void)setWeekStartDate:(NSDate *)newStartDate
{
    _weekStartDate = newStartDate;
    
    if (!newStartDate) return;
    
    _monthLabel.hidden = YES;
    
    // update day numbers
    NSDate *today = [[NSDate date] mt_startOfCurrentDay];
    for (NSInteger i = 0; i < 7; i++) {
        NSDate *date = [_weekStartDate mt_dateDaysAfter:i];
        NSInteger dayOfMonth = [date mt_dayOfMonth];
        
        NSInteger num = i + 100;
        UILabel *label = (UILabel *)[self viewWithTag:num];
        label.text = [NSString stringWithFormat:@"%d", dayOfMonth];
        
        // gray out day labels that have passed
        if ([date mt_isBefore:today]) {
            label.textColor = RGBHex(0xCCCCCC);
        }
        else {
            label.textColor = [UIColor blackColor];
        }

        if (dayOfMonth == 1) {
            _monthLabel.hidden = NO;
            
            CGFloat width       = self.frame.size.width;
            CGFloat widthEach   = width / 7.0f;
            
            CGRect frame = _monthLabel.frame;
            frame.origin.x = (widthEach * i) + (PAD ? 5.0f : 2.0f);
            _monthLabel.frame = frame;
            
            if (PAD) {
                _monthLabel.text = [[date stringWithTitleOfCurrentMonthAndYearAbbreviated:YES] uppercaseString];
            }
            else {
                _monthLabel.text = [[date stringWithTitleOfCurrentMonthAbbreviated:YES] uppercaseString];
            }
        }
        else {
            _monthLabel.hidden = YES;
        }
    }
}

- (void)setSelectedDate:(NSDate *)newSelectedDate
{
    _selectedDate = newSelectedDate;
    if (!newSelectedDate) return;
}

- (void)redraw
{
    // Update font sizes
    if (PAD) {
        for (NSInteger i = 0; i < 7; i++) {
            NSInteger num = i + 100;
            UILabel *label = (UILabel *)[self viewWithTag:num];
            if ([self.delegate isInPortrait]) {
                label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:IPAD_MONTH_VIEW_FONT_SIZE_PORTRAIT];
                _monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:IPAD_MONTH_VIEW_FONT_SIZE_PORTRAIT];
            }
            else {
                label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:IPAD_MONTH_VIEW_FONT_SIZE_LANDSCAPE];
                _monthLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:IPAD_MONTH_VIEW_FONT_SIZE_LANDSCAPE];
            }
        }
    }

    [self.drawingView draw];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSDate *today = [NSDate date];
    _todayImage.hidden = YES;
    if ([today mt_isOnOrAfter:_weekStartDate] && [today mt_isBefore:[_weekStartDate mt_endOfCurrentWeek]]) {
        _todayImage.hidden  = NO;
        CGFloat boxWidth    = self.bounds.size.width / (float)DAYS_IN_WEEK;
        CGRect f            = _todayImage.frame;
        f.origin.x          = floorf(boxWidth * ([today mt_weekdayOfWeek] - 1));
        f.origin.y          = 0;
        f.size.width        = floorf(boxWidth);
        f.size.height       = floorf(self.height);
        _todayImage.frame   = f;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGFloat boxWidth = self.bounds.size.width / (float)DAYS_IN_WEEK;

    // gray out every other month
    if (PAD) {
        CGContextSetFillColorWithColor(context, [patentedVeryLightGray CGColor]);
    }
    else {
        CGContextSetFillColorWithColor(context, [patentedPrettyLightGray CGColor]);
    }
    
    for (NSInteger i = 0; i < 7; i++) {
        NSDate *date = [_weekStartDate mt_dateDaysAfter:i];
        if ([date mt_monthOfYear] % 2 == 0) {
            CGRect grayRect         = CGRectZero;
            grayRect.origin.y       = 0;
            grayRect.origin.x       = floorf(boxWidth * i);
            grayRect.size.height    = floorf(self.bounds.size.height);
            grayRect.size.width     = ceil(boxWidth);
            CGContextFillRect(context, grayRect);
        }
    }

    
    // DRAW BACKGROUND LINES
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, [patentedLightGray CGColor]);

    // horizontal line
    CGContextMoveToPoint(context, 0, 0.5);
    CGContextAddLineToPoint(context, self.width, 0.5);
    CGContextStrokePath(context);

    // vertical lines
	for (int i = 0; i < 7; i++) {
        CGFloat x = floorf(boxWidth * i);
		CGContextMoveToPoint(context, x, 0);
		CGContextAddLineToPoint(context, x, self.bounds.size.height);
        CGContextStrokePath(context);
	}
}




#pragma mark - IBActions

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateEnded) return;
    
    // figure date
    CGPoint pointOfTouch = [gesture locationInView:self];
    NSInteger daysIntoWeek = floor( ( pointOfTouch.x / self.bounds.size.width ) * DAYS_IN_WEEK);
    NSDate *date = [self.weekStartDate mt_dateDaysAfter:daysIntoWeek];
    
    [self.delegate weekTableViewCell:self wasPressedOnDate:date];
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    // figure date
    CGPoint pointOfTouch = [gesture locationInView:self];
    NSInteger daysIntoWeek = floor( ( pointOfTouch.x / self.bounds.size.width ) * DAYS_IN_WEEK);
    NSDate *date = [self.weekStartDate mt_dateDaysAfter:daysIntoWeek];
    
    CGRect rectOfPlaceHolder = CGRectZero;
    rectOfPlaceHolder.size.width = (self.bounds.size.width / (DAYS_IN_WEEK * 1.0f));
    rectOfPlaceHolder.size.height = self.bounds.size.height;
    rectOfPlaceHolder.origin.x = daysIntoWeek * rectOfPlaceHolder.size.width;
    rectOfPlaceHolder.origin.y = 0;
    
    // create view to point to
    UIView *placeholder = [[UIView alloc] initWithFrame:rectOfPlaceHolder];
    placeholder.backgroundColor = patentedBlack;
    placeholder.alpha = 0.3f;
    [self addSubview:placeholder];
    
    [self.delegate weekTableViewCell:self wasLongPressedOnDate:date withPlaceholder:placeholder];
}




#pragma mark - CVWeekTableViewCellDrawingDataSource

- (NSDate *)startDateForDrawingView:(CVWeekTableViewCellDrawing *)view
{
    return self.weekStartDate;
}




#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // We allow taps and long presses to occur at the same time. This lets us select a day when the user is long pressing on a day.
    if ([gestureRecognizer isKindOfClass:[CVTapGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}




@end
