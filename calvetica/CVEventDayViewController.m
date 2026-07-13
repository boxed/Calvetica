//
//  CVDateViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 4/25/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDayViewController.h"
#import "CVJumpToDateViewController.h"
#import "CVSelectionTableViewCell.h"
#import "colors.h"
#import "viewtagoffsets.h"
#import "NSDate+ViewHelpers.h"
#import "CVJumpToDayButton.h"
#import "UIView+Nibs.h"


// Layout metrics for the jump-to-date calendar. Kept as constants so -viewDidLayoutSubviews and
// +preferredContentHeight stay in sync.
static const CGFloat kTopPad      = 12;   // above the year table / month buttons
static const CGFloat kTopAreaH    = 96;   // height of the year table + month button block
static const CGFloat kWeekdayGap  = 18;   // between the month block and the weekday titles
static const CGFloat kWeekdayBarH = 16;   // weekday title row
static const CGFloat kGridGap     = 2;    // between weekday titles and the day grid
static const CGFloat kDayRowH     = 42;   // height of one week row
static const CGFloat kBottomPad   = 10;
static const NSInteger kNumWeeks  = 6;
static const CGFloat kWeekColW    = 40;   // week-number column width
static const CGFloat kSidePad     = 12;
static const CGFloat kYearMonthGap = 10;


@implementation CVEventDayViewController

+ (CGFloat)preferredContentHeight
{
    return kTopPad + kTopAreaH + kWeekdayGap + kWeekdayBarH + kGridGap + (kNumWeeks * kDayRowH) + kBottomPad;
}


- (void)dealloc
{
    self.yearTableView.delegate = nil;
    self.yearTableView.dataSource = nil;
    self.scrollView.delegate = nil;
}


#pragma mark - Methods

- (void)containerWasSwiped:(UISwipeGestureRecognizer *)gesture 
{
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.date = [self.date mt_oneMonthNext];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        self.date = [self.date mt_oneMonthPrevious];
    }
}

- (void)setDate:(NSDate *)newDate 
{
    _date = newDate;
    
	NSInteger row = [self tableIndexFromYear:[self.date mt_year]];
	
	// check if row is valid
    if ([_yearTableView numberOfRowsInSection:0] < row || row < 0) return;
	
    // select year row
    [_yearTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionMiddle];
    
    
    // select month button
    for (int i = 1; i < 13 ; i++) {
        UIView *monthButton = [self.monthButtonsContainer viewWithTag:i];
        if (i == [self.date mt_monthOfYear]) {
            monthButton.backgroundColor = patentedRed;
            UILabel *label = [monthButton.subviews lastObject];
            [label setWhiteWithLightShadow];
        } else {
            monthButton.backgroundColor = patentedClear;
            UILabel *label = [monthButton.subviews lastObject];
            [label setDarkGrayWithLightShadow];
        }
    }
    
    // set month days
    NSInteger selectedDayIndex = [self.date calendarMonth:[self.date mt_startOfCurrentMonth] squareIndexShiftedToBottom:NO];
    
    for (int i = 0; i < self.dayButtons.count; i++) {
        CVJumpToDayButton *b = [self.dayButtons objectAtIndex:i];
        NSDate *dateForButton = [self.date dateForCalendarSquare:i shiftedToBottom:NO];
        NSString *dateString = [NSString stringWithFormat:@"%lu", (unsigned long)[dateForButton mt_dayOfMonth]];
        b.label.text = dateString;
        
        if ([dateForButton mt_isWithinSameMonth:self.date]) {
            b.label.alpha = 1;
        } else {
            b.label.alpha = 0.45f;
        }
		
		b.isToday = NO;
        b.isRootViewController = NO; 
		b.backgroundColor = patentedClear;
		[b.label setDarkGrayWithLightShadow];
		
		if ([dateForButton mt_isWithinSameDay:[NSDate date]]) {
            b.isToday = YES;
        }
		
        if (i == selectedDayIndex) {
			b.isToday = NO;
            b.backgroundColor = patentedRed;
            [b.label setWhiteWithLightShadow];
        }
    }
    
    // set weekday labels
    for (int i = 0; i < 7; i++) {
        UILabel *l = (UILabel *)[self.weekdayLabelContainer viewWithTag:WEEKDAY_TITLES_OFFSET + i];
        l.text = [[NSDate stringWithWeekDayAbbreviated:YES forWeekdayIndex:i+1] uppercaseString];
    }
    
    // set month week numbers
    for (int i = 0; i < self.weekButtons.count; i++) {
        CVJumpToDayButton *b = [self.weekButtons objectAtIndex:i];
        b.label.text = [NSString stringWithFormat:@"%ld", (long)[self.date weekNumberForSquareIndex:i]];
    }
    
    [self.delegate eventDayViewController:self didUpdateDate:self.date];
}

- (NSInteger)yearFromTableIndex:(NSInteger)index 
{
    return ([self.initialDate mt_year] - 50) + index;
}

- (NSInteger)tableIndexFromYear:(NSInteger)year 
{
    return (year + 50) - [self.initialDate mt_year];
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    // We want to swipe on the calendar to change the month.
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(containerWasSwiped:)];
    [self.dayButtonsContainer addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(containerWasSwiped:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dayButtonsContainer addGestureRecognizer:leftSwipe];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.dayButtons) {
        return;
    }

    // Create the day and week buttons once. Their frames are assigned in -viewDidLayoutSubviews,
    // so the whole grid reflows to whatever width the (now wider) dialog gives us.
    self.dayButtons = [NSMutableArray array];
    for (int i = 0; i < 6 * 7; i++) {
        CVJumpToDayButton *b = [CVJumpToDayButton fromNibOfSameName];
        b.backgroundImageView.hidden = YES;
        b.label.text = [NSString stringWithFormat:@"%d", i + 1];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayButtonWasTapped:)];
        [b addGestureRecognizer:tapGesture];

        [self->_dayButtonsContainer addSubview:b];
        [self.dayButtons addObject:b];
    }

    self.weekButtons = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        CVJumpToDayButton *b = [CVJumpToDayButton fromNibOfSameName];
        b.backgroundImageView.hidden = YES;
        [b.label setWhiteWithLightShadow];
        b.label.text = [NSString stringWithFormat:@"%d", i + 1];
        [self.weekButtons addObject:b];
        [self->_weekButtonsContainer addSubview:b];
    }

    [self.view setNeedsLayout];

    // update view with date
    self.date = self.initialDate;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGFloat W = self.view.bounds.size.width;
    CGFloat H = self.view.bounds.size.height;
    if (W <= 0 || H <= 0) return;

    // Year column: wide enough to show a full four-digit year (with headroom for Dynamic Type),
    // but a sensible fraction of the overall width.
    CGFloat yearColW = MIN(120, MAX(88, W * 0.22));

    self.scrollView.frame = self.view.bounds;

    // Year table (the "input" for the year)
    self.yearTableView.frame = CGRectMake(kSidePad, kTopPad, yearColW, kTopAreaH);

    // Month buttons fill the rest of the top row
    CGFloat monthX = kSidePad + yearColW + kYearMonthGap;
    CGFloat monthW = W - monthX - kSidePad;
    self.monthButtonsContainer.frame = CGRectMake(monthX, kTopPad, monthW, kTopAreaH);
    CGFloat mbW = monthW / 4.0;
    CGFloat mbH = kTopAreaH / 3.0;
    for (int i = 1; i <= 12; i++) {
        UIView *monthButton = [self.monthButtonsContainer viewWithTag:i];
        int col = (i - 1) % 4;
        int row = (i - 1) / 4;
        monthButton.frame = CGRectMake(round(col * mbW), round(row * mbH), round(mbW), round(mbH));
        UILabel *label = (UILabel *)[monthButton.subviews lastObject];
        label.frame = monthButton.bounds;
        label.textAlignment = NSTextAlignmentCenter;
    }

    // Weekday title bar spans the full width
    CGFloat weekdayY = kTopPad + kTopAreaH + kWeekdayGap;
    self.weekdayLabelContainer.frame = CGRectMake(0, weekdayY, W, kWeekdayBarH);
    CGFloat dayColW = (W - kWeekColW) / 7.0;
    for (UIView *sub in self.weekdayLabelContainer.subviews) {
        if (sub.tag >= WEEKDAY_TITLES_OFFSET && sub.tag <= WEEKDAY_TITLES_OFFSET + 6) {
            int idx = (int)(sub.tag - WEEKDAY_TITLES_OFFSET);
            sub.frame = CGRectMake(round(kWeekColW + idx * dayColW), 0, round(dayColW), kWeekdayBarH);
        } else {
            // the "WK" label
            sub.frame = CGRectMake(0, 0, kWeekColW, kWeekdayBarH);
        }
    }

    // Calendar grid (fixed comfortable row height, six weeks)
    CGFloat gridY = weekdayY + kWeekdayBarH + kGridGap;
    CGFloat gridH = kNumWeeks * kDayRowH;
    UIView *grid = self.dayButtonsContainer.superview;
    grid.frame = CGRectMake(0, gridY, W, gridH);
    self.weekButtonsContainer.frame = CGRectMake(0, 0, kWeekColW, gridH);
    self.dayButtonsContainer.frame = CGRectMake(kWeekColW, 0, W - kWeekColW, gridH);

    // Day buttons (7 x 6 grid), with the day number centred in each cell
    CGFloat dayW = self.dayButtonsContainer.frame.size.width / 7.0;
    for (int i = 0; i < (int)self.dayButtons.count; i++) {
        CVJumpToDayButton *b = self.dayButtons[i];
        CGFloat x = round((i % 7) * dayW);
        CGFloat y = round((i / 7) * kDayRowH);
        b.frame = CGRectMake(x, y, round(dayW), round(kDayRowH));
        b.label.frame = b.bounds;
        b.label.textAlignment = NSTextAlignmentCenter;
    }

    // Week-number buttons (1 x 6)
    for (int i = 0; i < (int)self.weekButtons.count; i++) {
        CVJumpToDayButton *b = self.weekButtons[i];
        b.frame = CGRectMake(0, round(i * kDayRowH), kWeekColW, round(kDayRowH));
        b.label.frame = b.bounds;
        b.label.textAlignment = NSTextAlignmentCenter;
    }

    CGFloat contentH = gridY + gridH + kBottomPad;
    self.containerView.frame = CGRectMake(0, 0, W, MAX(contentH, H));
    self.scrollView.contentSize = self.containerView.frame.size;

    // keep the selected year centred now that the table has been resized
    NSInteger row = [self tableIndexFromYear:[self.date mt_year]];
    if (row >= 0 && row < [self.yearTableView numberOfRowsInSection:0]) {
        [self.yearTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:NO];
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVSelectionTableViewCell *cell = [CVSelectionTableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)[self yearFromTableIndex:indexPath.row]];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    cell.textLabel.adjustsFontForContentSizeCategory = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.frame = cell.bounds;
    cell.textLabel.textColor = calQuaternaryText();
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // set year
    NSInteger year = [self yearFromTableIndex:indexPath.row];
    NSDate *date = [NSDate mt_dateFromYear:year month:[self.date mt_monthOfYear] day:[self.date mt_dayOfMonth]];
    self.date = date;
}




#pragma mark - Actions

- (IBAction)monthButtonWasTapped:(id)sender 
{

    // set month
    UIView *s = (UIView *)sender;
    NSDate *newDate = [NSDate mt_dateFromYear:[self.date mt_year] month:s.tag day:1];
    
    
    // if the selected day of the month is greater than the number of days in the new month, change the selected day to 
    // the last day of the new month
    if ([newDate mt_daysInCurrentMonth] < [self.date mt_dayOfMonth]) {
        self.date = [NSDate mt_dateFromYear:[self.date mt_year] month:[newDate mt_monthOfYear] day:[newDate mt_daysInCurrentMonth]];
    } else {
        self.date = [NSDate mt_dateFromYear:[self.date mt_year] month:[newDate mt_monthOfYear] day:[self.date mt_dayOfMonth]];
    }
}

- (IBAction)dayButtonWasTapped:(UITapGestureRecognizer *)sender 
{
    // set day
    self.date = [self.date dateForCalendarSquare:[self.dayButtons indexOfObject:sender.view] shiftedToBottom:NO];    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
