//
//  CVQuickAddViewController_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 4/22/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVQuickAddViewController.h"
#import "geometry.h"
#import "UIView+Utilities.h"
#import "CVRoundedButton.h"
#import "CVSelectionTableViewCell.h"
#import "times.h"
#import "UITableViewCell+Nibs.h"
#import "NSMutableArray+Stack.h"



@interface CVQuickAddViewController ()
@property (nonatomic, strong)          NSMutableArray  *hourDigits;
@property (nonatomic, strong)          NSMutableArray  *minuteDigits;
@property (nonatomic, strong)          NSMutableArray  *hoursArray;
@property (nonatomic, strong)          NSMutableArray  *minutesArray;
@property (nonatomic, strong)          NSMutableArray  *allDayDatesArray;
@property (nonatomic, strong)          NSNumber        *hourInterval;
@property (nonatomic, strong)          NSNumber        *minuteInterval;
@property (nonatomic, weak  ) IBOutlet CVRoundedButton *addButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedButton *moreButton;
@property (nonatomic, weak  ) IBOutlet CVRoundedButton *closeButton;
@property (nonatomic, weak  ) IBOutlet UIView          *containerView;
@property (nonatomic, weak  ) IBOutlet UITextField     *titleTextField;
@property (nonatomic, weak  ) IBOutlet UIButton        *ampmButton;
@property (nonatomic, weak  ) IBOutlet UIControl       *startTimeButton;
@property (nonatomic, weak  ) IBOutlet UILabel         *startLabel;
@property (nonatomic, weak  ) IBOutlet UILabel         *startTimeLabel;
@property (nonatomic, weak  ) IBOutlet UILabel         *startDayLabel;
@property (nonatomic, weak  ) IBOutlet UIControl       *endTimeButton;
@property (nonatomic, weak  ) IBOutlet UILabel         *endLabel;
@property (nonatomic, weak  ) IBOutlet UILabel         *endTimeLabel;
@property (nonatomic, weak  ) IBOutlet UILabel         *endDayLabel;
@property (nonatomic, weak  ) IBOutlet UIView          *allDayEndDayView;
@property (nonatomic, weak  ) IBOutlet UILabel         *allDayEndDayLabel;
@property (nonatomic, weak  ) IBOutlet UILabel         *allDayStartDayLabel;
@property (nonatomic, weak  ) IBOutlet UIView          *durationTablesView;
@property (nonatomic, weak  ) IBOutlet UITableView     *hoursTableView;
@property (nonatomic, weak  ) IBOutlet UITableView     *minutesTableView;
@property (nonatomic, weak  ) IBOutlet UIView          *allDayTableHolderView;
@property (nonatomic, weak  ) IBOutlet UITableView     *allDayTableView;
@property (nonatomic, weak  ) IBOutlet UIScrollView    *allDayScrollView;
@property (nonatomic, weak  ) IBOutlet UIView          *allDayScrollViewPageOne;
@property (nonatomic, weak  ) IBOutlet UIView          *allDayScrollViewPageTwo;
@property (nonatomic, weak  ) IBOutlet UIPageControl   *pageControl;
@end




@implementation CVQuickAddViewController

- (void)dealloc
{
    self.titleTextField.delegate        = nil;
    self.hoursTableView.delegate        = nil;
    self.hoursTableView.dataSource      = nil;
    self.minutesTableView.delegate      = nil;
    self.minutesTableView.dataSource    = nil;
    self.allDayTableView.delegate       = nil;
    self.allDayTableView.dataSource     = nil;
    self.allDayScrollView.delegate      = nil;
}

+ (NSDictionary *)dictionaryFromTitle:(NSString *)title value:(NSNumber *)value {
    return @{@"title": title, @"value": value};
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isAllDay = NO;
		self.isAM = NO;
		
		self.hourDigits = [NSMutableArray array];
		self.minuteDigits = [NSMutableArray array];
    }
    return self;
}



#pragma mark - Properties

- (void)setIsAllDay:(BOOL)allDay 
{
    _isAllDay = allDay;

    if (allDay) {
        self.allDayTableHolderView.hidden = NO;
        self.startDate	= [_startDate mt_startOfCurrentDay];
        self.endDate	= [_endDate mt_endOfCurrentDay];
    }
    else {
        self.allDayTableHolderView.hidden = YES;
    }
    self.hourDigits = [NSMutableArray array];
    self.minuteDigits = [NSMutableArray array];
    [self displayDefault];
}

- (void)setStartDate:(NSDate *)date 
{
    if (!self.startDate) {
        _startDate = date;
        [self loadTableViews];
    }
    else {
        _startDate = date;
    }
}




#pragma mark - Methods

- (void)displayDefault 
{
    self.titleTextField.text = self.titleTextField.text ?: self.defaultTitle;

    self.hourDigits = [NSMutableArray new];
    self.minuteDigits = [NSMutableArray new];
    
    // depending on if its 24 hour format, set the hour of the day and the am/pm button text
    NSInteger hourOfDay;
	NSInteger minuteOfHour = [self.startDate mt_minuteOfHour];
	
    if (!PREFS.twentyFourHourFormat) {
        hourOfDay = [self.startDate mt_hourOfDay] % 12;
        self.isAM = [self.startDate mt_isInAM];
        [self.ampmButton setTitle:(self.isAM ? @"pm" : @"am") forState:UIControlStateNormal];
    }
    else {
        hourOfDay = [self.startDate mt_hourOfDay];
        [self.ampmButton setTitle:@"" forState:UIControlStateNormal];
    }
	
	// add hour to array
	NSString *hourString = @"";
	if (PREFS.twentyFourHourFormat) {
		hourString = [NSString stringWithFormat:@"%ld", (long)hourOfDay];
	}
	else {
		hourString = [NSString stringWithFormat:@"%02ld", (long)hourOfDay];
	}

    for (NSInteger i = 0; i < hourString.length; i++) {
        NSString *character = [hourString substringWithRange:NSMakeRange(i, 1)];
        [self.hourDigits push:character];
    }
	
    // add minutes
	if (minuteOfHour > 0) {
		NSString *minuteString = [NSString stringWithFormat:@"%02ld", (long)minuteOfHour];
		for (NSInteger i = 0; i < minuteString.length; i++) {
			NSString *character = [minuteString substringWithRange:NSMakeRange(i, 1)];
            
            // if they tap ":30" in the sub-hour picker, it should let them tap "5" to be ":35"
            // ...only if the second char is "0" otherwise it messes up ":05"
			if (!(i == 1 && [character isEqualToString:@"0"])) {
                [self.minuteDigits push:character];
            }
		}
	}
    
    [self renderEventStartTimeString];
}

- (void)calculateStartDate 
{
	NSInteger hour = [[self hourStringFromHourDigits] intValue];
	NSInteger minute = [[self minuteStringFromMinuteDigits] intValue];
	
	// adjust hour if its 12 hour format
	if (!PREFS.twentyFourHourFormat) {
		hour = _isAM ? hour : (hour % 12) + 12;
	}
	
	// create the start date
	self.startDate = [[self.startDate mt_startOfCurrentDay] mt_dateByAddingYears:0 months:0 weeks:0 days:0 hours:hour minutes:minute seconds:0];
    [self calculateEndDate];
    
    if ([self.startDate mt_isOnOrBefore:[NSDate date]] && [self.endDate mt_isOnOrAfter:[NSDate date]]) {
        self.startDayLabel.text = [[self.endDate stringWithWeekdayMonthDayYearMonthAbbreviated:NO] lowercaseString];
    }
    else {
        self.startDayLabel.text = [[self.endDate stringWithWeekdayAbbreviated:YES monthDayAbbreviated:YES] lowercaseString];
    }
}

- (void)calculateEndDate 
{
    if ([_hourInterval integerValue] >= 0) {
        if ([_minuteInterval integerValue] > 0) {
            _endDate = [_startDate dateByAddingTimeInterval:[_hourInterval integerValue] + [_minuteInterval integerValue]];
        }
        else {
			_endDate = [_startDate dateByAddingTimeInterval:[_hourInterval integerValue]];
        }
    }
    else {
        _endDate = [_startDate dateByAddingTimeInterval:PREFS.defaultDuration];
    }
    [self renderEventEndTimeString];
}

- (void)renderEventStartTimeString 
{
	
	NSMutableString *string = [NSMutableString string];
    
	[string appendString:[self hourStringFromHourDigits]];
	[string appendString:@":"];
	[string appendString:[self minuteStringFromMinuteDigits]];
	
    if (!PREFS.twentyFourHourFormat) {
        // add ampm
        [string appendString:(_isAM ? @"am" : @"pm")];
    }
    
    // do it!
    _startTimeLabel.text = string;
    
    [self calculateStartDate];
}

- (void)renderEventEndTimeString 
{
    _endTimeLabel.text = [self.endDate stringWithHourMinuteAndLowercaseAMPM];
    //If today was Tuesday this makes it so it says ENDS:Tomorrow instead of ENDS:Wednesday
    if ([self.startDate mt_isOnOrBefore:[NSDate date]] && [_endDate mt_isOnOrAfter:[NSDate date]]) {
        _endDayLabel.hidden = NO;
        _endDayLabel.text = [[_endDate stringWithWeekdayMonthDayYearMonthAbbreviated:YES] lowercaseString];
    }
    else {
        _endDayLabel.hidden = YES;
    }
}

- (void)loadTableViews 
{
    NSArray *hoursTitles = @[NSLocalizedString(@"0hr", @"0hr"),
                            NSLocalizedString(@"1hr", @"1hr"), 
                            NSLocalizedString(@"2hr", @"2hr"),
                            NSLocalizedString(@"3hr", @"3hr"),
                            NSLocalizedString(@"4hr", @"4hr"),
                            NSLocalizedString(@"5hr", @"5hr"),
                            NSLocalizedString(@"6hr", @"6hr"),
                            NSLocalizedString(@"7hr", @"7hr"),
                            NSLocalizedString(@"8hr", @"8hr"),
                            NSLocalizedString(@"9hr", @"9hr"),
                            NSLocalizedString(@"10hr", @"10hr"),
                            NSLocalizedString(@"11hr", @"11hr"),
                            NSLocalizedString(@"12hr", @"12hr")];
    
    NSArray *hoursValues = @[@0,                     // 0hr
                            @(MTDateConstantSecondsInHour),       // 1hr
                            @(MTDateConstantSecondsInHour * 2),   // 2hr
                            @(MTDateConstantSecondsInHour * 3),   // 3hr
                            @(MTDateConstantSecondsInHour * 4),   // 4hr
                            @(MTDateConstantSecondsInHour * 5),   // 5hr
                            @(MTDateConstantSecondsInHour * 6),   // 6hr
                            @(MTDateConstantSecondsInHour * 7),   // 7hr
                            @(MTDateConstantSecondsInHour * 8),   // 8hr
                            @(MTDateConstantSecondsInHour * 9),   // 9hr
                            @(MTDateConstantSecondsInHour * 10),  // 10hr
                            @(MTDateConstantSecondsInHour * 11),  // 11hr
                            @(MTDateConstantSecondsInHour * 12)];
    
    NSArray *minutesTitles = @[NSLocalizedString(@"0min", @"0min"),
                              NSLocalizedString(@"5min", @"5min"), 
                              NSLocalizedString(@"10min", @"10min"),
                              NSLocalizedString(@"15min", @"15min"),
                              NSLocalizedString(@"20min", @"20min"),
                              NSLocalizedString(@"25min", @"25min"),
                              NSLocalizedString(@"30min", @"30min"),
                              NSLocalizedString(@"35min", @"35min"),
                              NSLocalizedString(@"40min", @"40min"),
                              NSLocalizedString(@"45min", @"45min"),
                              NSLocalizedString(@"50min", @"50min"),
                              NSLocalizedString(@"55min", @"55min")];
    
    NSArray *minutesValues = @[@0,                          // 0m
                              @(MTDateConstantSecondsInMinute * 5),      // 5m
                              @(MTDateConstantSecondsInMinute * 10),     // 10m
                              @(MTDateConstantSecondsInMinute * 15),     // 15m
                              @(MTDateConstantSecondsInMinute * 20),     // 20m
                              @(MTDateConstantSecondsInMinute * 25),     // 25m
                              @(MTDateConstantSecondsInMinute * 30),     // 30m
                              @(MTDateConstantSecondsInMinute * 35),     // 35m
                              @(MTDateConstantSecondsInMinute * 40),     // 40m
                              @(MTDateConstantSecondsInMinute * 45),     // 45m
                              @(MTDateConstantSecondsInMinute * 50),     // 50m
                              @(MTDateConstantSecondsInMinute * 55)];
    
    _hoursArray = [NSMutableArray array];
    _minutesArray = [NSMutableArray array];
    
    NSDate *from = [self.startDate mt_startOfCurrentDay];
    NSDate *to = [[self.startDate mt_startOfCurrentDay] mt_dateByAddingYears:0 months:6 weeks:0 days:0 hours:0 minutes:0 seconds:0];
    
    _allDayDatesArray = [NSMutableArray arrayWithArray:[NSDate mt_datesCollectionFromDate:from untilDate:to]];
    
    // build the hoursArray
    for (int i = 0; i < [hoursTitles count]; i++) {
        [_hoursArray push:[CVQuickAddViewController dictionaryFromTitle:[hoursTitles objectAtIndex:i] value:[hoursValues objectAtIndex:i]]];
    }
    
    // build the minutesArray
    for (int i = 0; i < [minutesTitles count]; i++) {
        [_minutesArray push:[CVQuickAddViewController dictionaryFromTitle:[minutesTitles objectAtIndex:i] value:[minutesValues objectAtIndex:i]]];
    }
    
    NSInteger defaultDuration = PREFS.defaultDuration;
    NSInteger flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDate *fromDate = [NSDate date];
    NSDate *toDate = [NSDate dateWithTimeInterval:defaultDuration sinceDate:fromDate];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:flags fromDate:fromDate toDate:toDate options:0];
    
    NSInteger hour = [comps hour] * MTDateConstantSecondsInHour;
    NSInteger minute = [comps minute] * MTDateConstantSecondsInMinute;

    _hourInterval = @(hour);
    _minuteInterval = @(minute);
}

- (NSString *)hourStringFromHourDigits 
{
	NSMutableString *s = [NSMutableString string];
    
	if (PREFS.twentyFourHourFormat) {
		if (self.hourDigits.count == 0) {
			[s appendString:@"00"];
		}
		else if (self.hourDigits.count == 1) {
			[s appendString:@"0"];
		}		
	}
	else {
		if (self.hourDigits.count == 0) {
			[s appendString:@"0"];
		}
	}
    
    
	for (NSString *c in self.hourDigits) {
        [s appendString:c];
    }
    
	return s;
}

- (NSString *)minuteStringFromMinuteDigits 
{
	NSMutableString *s = [NSMutableString string];
    
	for (NSString *c in self.minuteDigits) {
        [s appendString:c];
    }
    
	if (s.length == 0) {
		[s appendString:@"00"];
	}
	else if (s.length == 1) {
		[s appendString:@"0"];
	}
	
	// truncate the minutes tens digit if too large
	if ([s intValue] > 59) {
		[s replaceCharactersInRange:NSMakeRange(0, 1) withString:@"5"];
	}
    
	return s;	
}

- (void)createNewEventAndRequestMore:(BOOL)more 
{
    self.calendarItem = [EKEvent eventWithDefaultsAtStartDate:self.startDate endDate:self.endDate allDay:self.isAllDay calendar:self.calendar];

    if (![self.titleTextField.text isEqualToString:@""]) {
        self.calendarItem.title = _titleTextField.text;
    }
    
    if (!more && self.calendarItem.calendar.isHidden) {
        self.calendarItem.calendar.hidden = NO;
    }
    
    if (more) {
        // notify delegate
        [self.delegate quickAddViewController:self didCompleteWithAction:CVQuickAddResultMore];
    }
    else {
        // save
        [(EKEvent *)self.calendarItem saveThenDoActionBlock:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate quickAddViewController:self didCompleteWithAction:CVQuickAddResultSaved];
            });
        } cancelBlock:^(void) {}];
    }
}

- (void)showCalendarPicker
{
    [self.titleTextField resignFirstResponder];
    CVCalendarPickerViewController *picker = [[CVCalendarPickerViewController alloc] init];
    picker.delegate = self;
    [self presentFullScreenModalViewController:picker animated:YES];
}




#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.addButton.layer.cornerRadius       = 6;
    self.addButton.layer.masksToBounds      = YES;
    self.closeButton.layer.cornerRadius     = 6;
    self.closeButton.layer.masksToBounds    = YES;
    self.moreButton.layer.cornerRadius      = 6;
    self.moreButton.layer.masksToBounds     = YES;


    if (PREFS.twentyFourHourFormat) {
        self.startTimeLabel.text = @"00:00";
    } else {
        [self.ampmButton setTitle:(self.isAM ? @"pm" : @"am") forState:UIControlStateNormal];
    }
    
    if (self.isDurationMode) {
        [self endTimeButtonWasHit:nil];
    }
    
    // select the rows that reflect the default duration
    for (int i = 0; i < _hoursArray.count; i++) {
        NSDictionary *hourDict = [self.hoursArray objectAtIndex:i];
        NSNumber *hour = [hourDict objectForKey:@"value"];
        if ([hour isEqualToNumber:self.hourInterval]) {
            NSIndexPath *hourIndex = [NSIndexPath indexPathForRow:i inSection:0];
            [self.hoursTableView selectRowAtIndexPath:hourIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    for (int i = 0; i < _minutesArray.count; i++) {
        NSDictionary *minuteDict = [self.minutesArray objectAtIndex:i];
        NSNumber *minute = [minuteDict objectForKey:@"value"];
        if ([minute isEqualToNumber:self.minuteInterval]) {
            NSIndexPath *minIndex = [NSIndexPath indexPathForRow:i inSection:0];
            [self.minutesTableView selectRowAtIndexPath:minIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
    
    // set the all day table and end date    
    for (NSInteger i = 0; i < self.allDayDatesArray.count; i++) {
        NSDate *date = [self.allDayDatesArray objectAtIndex:i];
        if ([date mt_isWithinSameDay:self.startDate]) {
            [self.allDayTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
			self.allDayEndDayLabel.text = [[date stringWithWeekdayAbbreviated:YES monthDayAbbreviated:YES] lowercaseString];
			self.allDayStartDayLabel.text = [[self.startDate stringWithWeekdayAbbreviated:YES monthDayAbbreviated:YES] lowercaseString];
        }
    }
    
    // set up long press button on the quick add
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addButtonWasLongPressed:)];
    [self.addButton addGestureRecognizer:longPressGesture];

    if (PAD) {
        for (UIView *v in self.view.subviews) {
            v.y -= 20;
        }
    }
    if ([[UIScreen mainScreen] nativeBounds].size.height == 2436) {
        for (UIView *v in self.view.subviews) {
            v.y += 20;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [self.titleTextField becomeFirstResponder];
    
    CGFloat width = self.allDayScrollViewPageOne.bounds.size.width + self.allDayScrollViewPageTwo.bounds.size.width;
    CGFloat height = self.allDayScrollViewPageOne.bounds.size.height;
    
    self.allDayScrollView.contentSize = CGSizeMake(width, height);
    
    if (self.isAllDay) {
        [self.allDayScrollView scrollRectToVisible:CGRectMake(width/2, 0, width/2, height) animated:NO];
        self.allDayTableHolderView.hidden = NO;
        self.pageControl.currentPage = 1;
    }
    else {
        self.pageControl.currentPage = 0;
    }
}




#pragma mark - Actions

- (IBAction)startTimeButtonWasHit:(id)sender 
{
    self.startLabel.textColor = patentedWhite;
    self.startTimeLabel.textColor = patentedWhite;
    
    self.endLabel.textColor = patentedDarkerRed;
    self.endTimeLabel.textColor = patentedDarkerRed;
    
    self.durationTablesView.hidden = YES;
}

- (IBAction)endTimeButtonWasHit:(id)sender 
{    
    self.startLabel.textColor = patentedDarkerRed;
    self.startTimeLabel.textColor = patentedDarkerRed;
    
    self.endLabel.textColor = patentedWhite;
    self.endTimeLabel.textColor = patentedWhite;
    
    self.durationTablesView.hidden = NO;
}

- (IBAction)closeButtonWasHit:(id)sender 
{
    [self.delegate quickAddViewController:self didCompleteWithAction:CVQuickAddResultCancelled];
}

- (IBAction)addButtonWasHit:(id)sender 
{
    if (PREFS.alwaysAskForCalendar) {
        [self showCalendarPicker];
    }
    else {
        [self createNewEventAndRequestMore:NO];
    }    
}

- (IBAction)addButtonWasLongPressed:(UILongPressGestureRecognizer *)sender 
{
    if (sender.state != UIGestureRecognizerStateBegan) return;
    [self showCalendarPicker];
}

- (IBAction)numberButtonWasHit:(id)sender 
{
	// get character
    UIView *v = (UIView *)sender;
    NSInteger tag = v.tag;	
	NSString *c = [NSString stringWithFormat:@"%ld",(long)tag];
	
	// if our digits is empty, add the first typed key to it.
	if (self.hourDigits.count == 0 || (self.hourDigits.count == 1 && [[self.hourDigits firstObject] intValue] == 0)) {
		[self.hourDigits push:c];
	}
	
	// otherwise, if the minute string is not full, add it
	else if (self.minuteDigits.count < 2) {
        //in 24 hr format if the user types 6,7,8,9 for the second integer it is inserted directly into the hours place.
		if (tag > 5 && PREFS.twentyFourHourFormat &&
            self.hourDigits.count < 2 &&
            self.minuteDigits.count == 0 &&
            [[self.hourDigits firstObject] intValue] == 1)
        {
            [self.hourDigits push:c];
        }
        else {
            [self.minuteDigits push:c];
        }
	}
	
	// if minutes is full, hours is not full and it would be a valid hour, shift it over into the hour digits
	else if (self.minuteDigits.count == 2 && self.hourDigits.count == 1) {
		NSString *potentialHourString = [NSString stringWithFormat:@"%@%@", [self.hourDigits lastObject], [self.minuteDigits firstObject]];
		
		// see if it would be valid if we shifted it to a double digit hour
		if (PREFS.twentyFourHourFormat) {
			if ([potentialHourString intValue] > 23) return;
		}
		else {
			if ([potentialHourString intValue] > 12) return;
		}
		
		// do the shift
		// pop the ten digit off the minutes and add the new char to the end
		NSString *tensDigit = [self.minuteDigits shift];
		[self.minuteDigits push:c];
		
		// push the tens digit to the ones digit on the hour
		[self.hourDigits push:tensDigit];
		
	}
	
	// otherwise, both are full, so just return
	else {
		return;
	}


	
	[self.startTimeButton bounce];
	
    [self renderEventStartTimeString];
}

- (IBAction)clearButtonWasHit:(id)sender 
{
    self.hourDigits = [NSMutableArray new];
	self.minuteDigits = [NSMutableArray new];
    [self renderEventStartTimeString];
}

- (IBAction)ampmToggleButtonWasHit:(id)sender 
{
    if (!PREFS.twentyFourHourFormat) {
        self.isAM = !self.isAM;
        [self.ampmButton setTitle:(self.isAM ? @"pm" : @"am") forState:UIControlStateNormal];
        [self renderEventStartTimeString];
    }
    else {
		[self clearButtonWasHit:sender];
    }
}

- (IBAction)moreButtonWasTapped:(id)sender 
{
	[self.titleTextField resignFirstResponder];
    [self createNewEventAndRequestMore:YES];
}




#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (tableView == self.hoursTableView) {
        return self.hoursArray.count;
    }
    else if (tableView == self.minutesTableView) {
        return self.minutesArray.count;
    }
    else if (tableView == self.allDayTableView) {
        return self.allDayDatesArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVSelectionTableViewCell *cell = [CVSelectionTableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = patentedQuiteDarkGray;
    cell.isDarkRed = YES;
    
    if (tableView == self.hoursTableView) {
        NSDictionary *hourDict = [self.hoursArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [hourDict objectForKey:@"title"];
    }
    else if (tableView == self.minutesTableView) {
        NSDictionary *minDict = [self.minutesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [minDict objectForKey:@"title"];
    }
    if (tableView == self.allDayTableView) {
        NSDate *date = [self.allDayDatesArray objectAtIndex:indexPath.row];
		cell.textLabel.text = [date stringWithWeekdayMonthDayYearMonthAbbreviated:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView == self.hoursTableView) {
        NSDictionary *hourDict = [self.hoursArray objectAtIndex:indexPath.row];
        self.hourInterval = [hourDict objectForKey:@"value"];
    }
    else if (tableView == self.minutesTableView) {
        NSDictionary *minDict = [self.minutesArray objectAtIndex:indexPath.row];
        self.minuteInterval = [minDict objectForKey:@"value"];
    }
    else if (tableView == self.allDayTableView) {
        self.endDate = [self.allDayDatesArray objectAtIndex:indexPath.row];
    }
    
    if (self.isAllDay) {
        NSDate *date = [self.allDayDatesArray objectAtIndex:indexPath.row];
		self.allDayEndDayLabel.text = [[date stringWithWeekdayAbbreviated:YES monthDayAbbreviated:YES] lowercaseString];
        [self.allDayEndDayView bounce];
    }
    else {
        [self.endTimeButton bounce];
        [self calculateEndDate];
    }
}




#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.allDayScrollView.frame.size.width;
    NSInteger page = floor((self.allDayScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    self.isAllDay = self.pageControl.currentPage;
}




#pragma mark - Calendar Picker VC

- (void)calendarPickerController:(CVCalendarPickerViewController *)controller didPickCalendar:(EKCalendar *)cal 
{
    [self dismissFullScreenModalViewControllerAnimated:YES];
    
    if (cal) {
        self.calendar = cal;
        [self createNewEventAndRequestMore:NO];
    }
}

#pragma mark - CVModalProtocal

- (void)modalBackdropWasTouched
{
    [_delegate quickAddViewController:self didCompleteWithAction:CVQuickAddResultCancelled];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self addButtonWasHit:nil];
	return NO;
}


@end
