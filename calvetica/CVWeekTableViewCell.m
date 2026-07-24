//
//  CVWeekTableViewCell_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWeekTableViewCell.h"
#import "CVWeekTableViewCellDrawing.h"
#import "CVCalendarItemShape.h"
#import "CVRootViewController.h"


@implementation CVWeekTableViewCell {
    BOOL _dayIsEvenMonth[7];
}

- (void)awakeFromNib
{
    self.backgroundColor = calBackgroundColor();
    [super awakeFromNib];
    self.contentMode = UIViewContentModeRedraw;
    _weekStartDate = nil;
    _selectedDate = nil;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];

    CGRect f = CGRectZero;
    f.origin.x = 0;
    f.origin.y = 1;
    f.size.width = self.bounds.size.width;
    f.size.height = self.bounds.size.height * 0.9f;

    self.drawingView = [[CVWeekTableViewCellDrawing alloc] initWithFrame:f];

    self.drawingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    self.drawingView.contentMode = UIViewContentModeRedraw;
    self.drawingView.opaque = NO;
    self.drawingView.delegate = self;
    [self insertSubview:self.drawingView atIndex:0];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    // Don't nil _weekStartDate — setWeekStartDate: will skip work if the date is unchanged (e.g., during resize)
    _selectedDate = nil;
    self.todayImage.hidden = YES;
}




#pragma mark - Methods

- (void)setWeekStartDate:(NSDate *)newStartDate
{
    if (_weekStartDate && newStartDate && [_weekStartDate isEqualToDate:newStartDate]) return;
    _weekStartDate = newStartDate;

    if (!newStartDate) return;
    
    _monthLabel.hidden = YES;

    // update day numbers
    NSDate *today = [[NSDate date] mt_startOfCurrentDay];
    for (NSInteger i = 0; i < 7; i++) {
        NSDate *date = [_weekStartDate mt_dateDaysAfter:i];
        NSInteger dayOfMonth = [date mt_dayOfMonth];
        _dayIsEvenMonth[i] = [date mt_monthOfYear] % 2 == 0;
        NSInteger num = i + 100;
        UILabel *label = (UILabel *)[self viewWithTag:num];
        label.text = [NSString stringWithFormat:@"%ld", (long)dayOfMonth];

        // gray out day labels that have passed (adaptive: inverts for dark mode
        // and honors Increase Contrast, unlike the previous hardcoded gray)
        if ([date mt_isBefore:today]) {
            label.textColor = calSecondaryText();
        }
        else {
            label.textColor = calTextColor();
        }

        if (dayOfMonth == 1) {
            _monthLabel.hidden = NO;
            _monthLabel.textColor = calThemeColor();

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
    }
}

- (void)setSelectedDate:(NSDate *)newSelectedDate
{
    _selectedDate = newSelectedDate;
    if (!newSelectedDate) return;
}

- (void)reloadData
{
    // Invalidate the drawing layer's cached events so it refetches from the
    // event store, then redraw. Use this whenever events may have changed.
    self.drawingView.lastFetchedStartDate = nil;
    [self redraw];
}

- (void)redraw
{
    // Update font sizes
    if (PAD) {
        BOOL mac = IS_MAC;
        CGFloat scale = CVGridFontScale();
        UIInterfaceOrientation orientation = self.window.rootViewController.interfaceOrientation;
        CGFloat fontSize;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            fontSize = (mac ? MAC_MONTH_VIEW_FONT_SIZE_PORTRAIT : IPAD_MONTH_VIEW_FONT_SIZE_PORTRAIT) * scale;
        }
        else {
            fontSize = (mac ? MAC_MONTH_VIEW_FONT_SIZE_LANDSCAPE : IPAD_MONTH_VIEW_FONT_SIZE_LANDSCAPE) * scale;
        }

        // Only update fonts if the size actually changed
        if ((NSInteger)_fontSize != (NSInteger)(fontSize * 100)) {
            _fontSize = (NSInteger)(fontSize * 100);
            UIFont *font = [UIFont systemFontOfSize:fontSize];
            for (NSInteger i = 0; i < 7; i++) {
                UILabel *label = (UILabel *)[self viewWithTag:i + 100];
                label.font = font;
            }
            _monthLabel.font = font;
        }
    }
    else {
        // iPhone: scale the day-of-month numbers with Dynamic Type, but more
        // gently than the lists (85% of the excess), capped via CVGridFontScale()
        // so they stay legible within the dense month grid.
        CGFloat dayScale = 1.0f + (CVGridFontScale() - 1.0f) * 0.85f;
        CGFloat fontSize = 12.0f * dayScale;
        if ((NSInteger)_fontSize != (NSInteger)(fontSize * 100)) {
            _fontSize = (NSInteger)(fontSize * 100);
            UIFont *font = [UIFont systemFontOfSize:fontSize];
            // Storyboard day labels are 14pt tall at y=26 (so their bottom sits at
            // the 40pt row bottom). Grow the label upward from that bottom anchor so
            // the bigger number moves up instead of overflowing off the cell bottom.
            CGFloat baseBottom = 26.0f + 14.0f;
            CGFloat newHeight  = 14.0f * dayScale;
            for (NSInteger i = 0; i < 7; i++) {
                UILabel *label = (UILabel *)[self viewWithTag:i + 100];
                label.font = font;
                label.clipsToBounds = NO; // don't clip the larger number in its fixed-height frame
                CGRect f = label.frame;
                f.size.height = newHeight;
                f.origin.y    = baseBottom - newHeight;
                label.frame   = f;
            }
        }
    }

    _monthLabel.textColor = calThemeColor();

    [self.drawingView draw];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        self.backgroundColor = calBackgroundColor();
        NSDate *date = _weekStartDate;
        _weekStartDate = nil;
        self.weekStartDate = date;
        [self redraw];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSDate *today = [NSDate date];
    _todayImage.hidden = YES;
    if ([today mt_isOnOrAfter:_weekStartDate] && [today mt_isBefore:[_weekStartDate mt_endOfCurrentWeek]]) {
        _todayImage.hidden  = NO;
        _todayImage.backgroundColor = calThemeColor();
        CGFloat boxWidth    = self.bounds.size.width / (float)MTDateConstantDaysInWeek;
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
    CGFloat boxWidth = self.bounds.size.width / (float)MTDateConstantDaysInWeek;

    CGColorRef evenColor = PAD ? [calBorderColorLight() CGColor] : [calSeparatorColor() CGColor];
    CGColorRef oddColor = [calBackgroundColor() CGColor];

    for (NSInteger i = 0; i < 7; i++) {
        CGRect grayRect         = CGRectZero;
        grayRect.origin.y       = 0;
        grayRect.origin.x       = floorf(boxWidth * i);
        grayRect.size.height    = floorf(self.bounds.size.height);
        grayRect.size.width     = ceil(boxWidth);
        CGContextSetFillColorWithColor(context, _dayIsEvenMonth[i] ? evenColor : oddColor);
        CGContextFillRect(context, grayRect);
    }


    // DRAW BACKGROUND LINES
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, [calGridLineColor() CGColor]);

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
    NSInteger daysIntoWeek = floor( ( pointOfTouch.x / self.bounds.size.width ) * MTDateConstantDaysInWeek);
    NSDate *date = [self.weekStartDate mt_dateDaysAfter:daysIntoWeek];
    
    [self.delegate weekTableViewCell:self wasPressedOnDate:date];
}

- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    // figure date
    CGPoint pointOfTouch = [gesture locationInView:self];
    NSInteger daysIntoWeek = floor( ( pointOfTouch.x / self.bounds.size.width ) * MTDateConstantDaysInWeek);
    NSDate *date = [self.weekStartDate mt_dateDaysAfter:daysIntoWeek];
    
    CGRect rectOfPlaceHolder = CGRectZero;
    rectOfPlaceHolder.size.width = (self.bounds.size.width / (MTDateConstantDaysInWeek * 1.0f));
    rectOfPlaceHolder.size.height = self.bounds.size.height;
    rectOfPlaceHolder.origin.x = daysIntoWeek * rectOfPlaceHolder.size.width;
    rectOfPlaceHolder.origin.y = 0;
    
    // create view to point to
    UIView *placeholder = [[UIView alloc] initWithFrame:rectOfPlaceHolder];
    placeholder.backgroundColor = calTextColor();
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




#pragma mark - Accessibility

// The week/month grid is drawn with CoreGraphics and is tapped by touch
// coordinate, so it is invisible to VoiceOver. Vend one accessible element per
// day: focusing a day reads its date + event count, double-tap selects it
// (routed through the existing tap gesture via the element's activation point),
// and a custom action creates an event (the long-press equivalent).
- (NSArray *)accessibilityElements
{
    if (!_weekStartDate) return @[];

    CGFloat boxWidth = self.bounds.size.width / (CGFloat)MTDateConstantDaysInWeek;
    NSDate *today    = [[NSDate date] mt_startOfCurrentDay];

    NSUInteger eventsPerDay[7] = {0};
    for (CVCalendarItemShape *e in self.drawingView.calendarItems) {
        if (e.days == NULL) continue;
        for (NSInteger d = 0; d < MTDateConstantDaysInWeek; d++) {
            if (e.days[d]) eventsPerDay[d]++;
        }
    }

    NSMutableArray<UIAccessibilityElement *> *elements = [NSMutableArray arrayWithCapacity:MTDateConstantDaysInWeek];
    for (NSInteger i = 0; i < MTDateConstantDaysInWeek; i++) {
        NSDate *date = [_weekStartDate mt_dateDaysAfter:i];

        UIAccessibilityElement *element = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];

        CGRect dayRect        = CGRectMake(floorf(boxWidth * i), 0, ceilf(boxWidth), self.bounds.size.height);
        element.accessibilityFrame = UIAccessibilityConvertFrameToScreenCoordinates(dayRect, self);

        NSMutableArray<NSString *> *parts = [NSMutableArray array];
        if ([date mt_isWithinSameDay:today]) {
            [parts addObject:NSLocalizedString(@"Today", @"VoiceOver prefix for today's date in the calendar grid")];
        }
        [parts addObject:[NSDateFormatter localizedStringFromDate:date
                                                        dateStyle:NSDateFormatterFullStyle
                                                        timeStyle:NSDateFormatterNoStyle]];
        NSUInteger count = eventsPerDay[i];
        if (count == 1) {
            [parts addObject:NSLocalizedString(@"1 event", @"VoiceOver: one event on a day")];
        }
        else if (count > 1) {
            [parts addObject:[NSString stringWithFormat:NSLocalizedString(@"%lu events", @"VoiceOver: number of events on a day"), (unsigned long)count]];
        }
        element.accessibilityLabel = [parts componentsJoinedByString:@", "];

        UIAccessibilityTraits traits = UIAccessibilityTraitButton;
        if (_selectedDate && [date mt_isWithinSameDay:_selectedDate]) {
            traits |= UIAccessibilityTraitSelected;
        }
        element.accessibilityTraits = traits;

        __weak typeof(self) weakSelf = self;
        UIAccessibilityCustomAction *newEvent =
            [[UIAccessibilityCustomAction alloc] initWithName:NSLocalizedString(@"New event", @"VoiceOver action to create an event on a day")
                                                actionHandler:^BOOL(UIAccessibilityCustomAction *action) {
            [weakSelf accessibilityCreateEventOnDate:date dayIndex:i];
            return YES;
        }];
        element.accessibilityCustomActions = @[newEvent];

        [elements addObject:element];
    }
    return elements;
}

- (void)accessibilityCreateEventOnDate:(NSDate *)date dayIndex:(NSInteger)dayIndex
{
    CGFloat boxWidth     = self.bounds.size.width / (CGFloat)MTDateConstantDaysInWeek;
    CGRect placeholderFrame = CGRectMake(dayIndex * boxWidth, 0, boxWidth, self.bounds.size.height);
    UIView *placeholder  = [[UIView alloc] initWithFrame:placeholderFrame];
    placeholder.backgroundColor = calTextColor();
    placeholder.alpha    = 0.3f;
    [self addSubview:placeholder];
    [self.delegate weekTableViewCell:self wasLongPressedOnDate:date withPlaceholder:placeholder];
}




@end
