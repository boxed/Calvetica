//
//  CVEventDetailsRepeatViewController_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 5/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventDetailsRepeatViewController.h"
#import "UITableViewCell+Nibs.h"

#define MIN_YEAR_COUNT 50


@implementation CVEventDetailsRepeatViewController




#pragma mark - Object Lifecycle

- (id)init
{
    return nil;
}

- (id)initWithStartDate:(NSDate *)date recurrenceRule:(EKRecurrenceRule *)rule 
{
    self = [super init];
    if (self) {
        _endType = 0;
        self.startDate = date;
        self.initialRecurrenceRule = rule;

        _selectedDay = [self.startDate mt_dayOfMonth];
        _selectedMonth = [self.startDate mt_monthOfYear];
        _selectedYear = [self.startDate mt_year];
    }
    return self;
}

- (void)dealloc
{
    self.dateDayTableView.delegate       = nil;
    self.dateDayTableView.dataSource     = nil;
    self.dateMonth.delegate     = nil;
    self.dateMonth.dataSource   = nil;
    self.dateYear.delegate      = nil;
    self.dateYear.dataSource    = nil;
}

- (NSArray *)daySymbols 
{
    if (!_daySymbols) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        self.daySymbols = [formatter weekdaySymbols];
    }
    
    return _daySymbols;
}

- (NSArray *)monthSymbols 
{
    if (!_monthSymbols) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        self.monthSymbols = [formatter monthSymbols];
    }
    
    return _monthSymbols;
}

- (NSInteger)yearCount 
{
    // We'll throw an exception if the recurrence end date is greater than the number of years we're allowing.
    if (self.initialRecurrenceRule.recurrenceEnd && self.initialRecurrenceRule.recurrenceEnd.endDate) {
        NSInteger recurrenceEndYear = [self.initialRecurrenceRule.recurrenceEnd.endDate mt_year];
        NSInteger currentYearCount = [self.startDate mt_year] + MIN_YEAR_COUNT;
        if (recurrenceEndYear >= currentYearCount) {
            // Add 11 to give a small buffer. For example, if the end date is 2065, we'll allow years up to 2075.
            return (recurrenceEndYear - currentYearCount) + MIN_YEAR_COUNT + 11;
        }
    }
    
    return MIN_YEAR_COUNT;
}



#pragma mark - Methods


- (NSInteger)dayCount
{
    NSDate *date = [NSDate mt_dateFromYear:_selectedYear month:_selectedMonth day:1];
    
    // The user isn't allowed to select a day in the past.
    if (_selectedYear == [self.startDate mt_year] && _selectedMonth == [self.startDate mt_monthOfYear]) {
        return [date mt_daysInCurrentMonth] - [self.startDate mt_dayOfMonth] + 1;
    }
    
    return [date mt_daysInCurrentMonth];
}

- (NSInteger)dayForIndexPath:(NSIndexPath *)indexPath 
{
    NSDate *date = [NSDate mt_dateFromYear:_selectedYear month:_selectedMonth day:1];
    NSInteger offset = [date mt_daysInCurrentMonth] - ([self dayCount] - 1);
    return indexPath.row + offset;
}

+ (NSString *)endTypeButtonTitleForIndex:(NSInteger)index {
    NSString *buttonTitle = nil;
    if (index == 0) {
        buttonTitle = NSLocalizedString(@"Never", @"Never");
    } else if (index == 1) {
        buttonTitle = NSLocalizedString(@"On Date", @"On Date");
    } else if (index == 2) {
        buttonTitle = NSLocalizedString(@"After", @"After");
    }
    
    return buttonTitle;
}

- (NSIndexPath *)indexPathForDay:(NSInteger)day 
{
    NSDate *date = [NSDate mt_dateFromYear:_selectedYear month:_selectedMonth day:1];
    NSInteger offset = [date mt_daysInCurrentMonth] - ([self dayCount] - 1);
    NSInteger row = day - offset;
    
    // A negative value means the selected day is in the past.
    if (row < 0) {
        row = 0;
    }
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSIndexPath *)indexPathForMonth:(NSInteger)month 
{
    NSInteger offset = 12 - ([self monthCount] - 1);
    NSInteger row = month - offset;
    
    if (row < 0) {
        row = 0;
    }
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSIndexPath *)indexPathForYear:(NSInteger)year 
{
    NSInteger row = year - [self.startDate mt_year];
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSInteger)monthCount 
{
    // The user isn't allowed to select a month in the past.
    if (_selectedYear == [self.startDate mt_year]) {
        // Ex: startDate.monthOfYear = 3. 12 - (3 - 1) = 10. 
        return 12 - ([self.startDate mt_monthOfYear] - 1);
    }
    
    return 12;
}

- (NSInteger)monthForIndexPath:(NSIndexPath *)indexPath 
{
    NSInteger offset = 12 - ([self monthCount] - 1);
    return indexPath.row + offset;
}

- (EKRecurrenceRule *)recurrenceRule 
{
    // Should be implemented by each base class.
    return nil;
}

- (void)updateSelectedDayWithAnimation:(BOOL)animate 
{
    // If the month or year changes, the max number of days might be less than our currently selected day.
    NSDate *date = [NSDate mt_dateFromYear:_selectedYear month:_selectedMonth day:1];
    if (_selectedDay > [date mt_daysInCurrentMonth]) {
        _selectedDay = [date mt_daysInCurrentMonth];
    }
    
    [self.dateDayTableView reloadData];
    
    NSIndexPath *newPath = [self indexPathForDay:_selectedDay];
    // It's possible that the day value was the past.
    _selectedDay = [self dayForIndexPath:newPath];
    [self.dateDayTableView selectRowAtIndexPath:newPath animated:animate scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)updateSelectedMonthWithAnimation:(BOOL)animate 
{
    [self.dateMonth reloadData];
    
    NSIndexPath *newPath = [self indexPathForMonth:_selectedMonth];
    // It's possible that the month value was in the past.
    _selectedMonth = [self monthForIndexPath:newPath];
    [self.dateMonth selectRowAtIndexPath:newPath animated:animate scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)updateSelectedYearWithAnimation:(BOOL)animate 
{
    [self.dateYear reloadData];
    [self.dateYear selectRowAtIndexPath:[self indexPathForYear:_selectedYear] animated:animate scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSInteger)yearForIndexPath:(NSIndexPath *)indexPath 
{
    return [self.startDate mt_year] + indexPath.row;
}




#pragma mark CVNumericKeyPadDelegate

- (void)keyPad:(CVNumericKeyPadViewController *)keyPad didUpdateNumber:(NSString *)number
{
    if (keyPad.targetView == self.endCountButton) {
        self.endAfterLabel.text = number;
    } else if (keyPad.targetView == self.frequencyButton) {
        self.repeatTimesLabel.text = number;
    }

    [self.delegate recurrenceDialog:self updatedRecurrence:[self recurrenceRule]];
}

- (void)keyPadWillClose:(CVNumericKeyPadViewController *)keyPad
{
    [self dismissFullScreenModalViewControllerAnimated:YES];
}




#pragma mark IBActions

- (void)endAfterValueButtonPressed 
{
    CVNumericKeyPadViewController *keyPad = [[CVNumericKeyPadViewController alloc] initWithTargetView:self.endCountButton];
    keyPad.delegate = self;
    keyPad.minValue = 1;
    [keyPad setKeyPadValue:[self.endAfterLabel.text intValue]];
    [self presentFullScreenModalViewController:keyPad animated:YES];
    
}

- (void)endTypeButtonPressed:(CVMultiToggleButton *)button 
{
    _endType = [button nextState];
    if (_endType == 0) {
        self.dateView.hidden = YES;
        self.endAfterView.hidden = YES;
    } else if (_endType == 1) {
        self.dateView.hidden = NO;
    } else if (_endType == 2) {
        self.endAfterView.hidden = NO;
        self.dateView.hidden = YES;
    }
    
    [self.delegate recurrenceDialog:self updatedRecurrence:[self recurrenceRule]];
}

- (void)repeatValueButtonPressed 
{
    CVNumericKeyPadViewController *keyPad = [[CVNumericKeyPadViewController alloc] initWithTargetView:self.frequencyButton];
    keyPad.delegate = self;
    keyPad.minValue = 1;
    [keyPad setKeyPadValue:[self.repeatTimesLabel.text intValue]];
    [self presentFullScreenModalViewController:keyPad animated:YES];
    
}




#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (tableView == self.dateDayTableView) {
        return [self dayCount];
    } else if (tableView == self.dateMonth) {
        return [self monthCount];
    } else if (tableView == self.dateYear) {
        return self.yearCount;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVSelectionTableViewCell *cell = [CVSelectionTableViewCell cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = patentedQuiteDarkGray();
    
    if (tableView == self.dateDayTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%li", (long)[self dayForIndexPath:indexPath]];
    } else if (tableView == self.dateMonth) {
        NSDate *date = [NSDate mt_dateFromYear:_selectedYear month:[self monthForIndexPath:indexPath] day:1];
        cell.textLabel.text = [date stringWithTitleOfCurrentMonthAbbreviated:NO];
    } else if (tableView == self.dateYear) {
        cell.textLabel.text = [NSString stringWithFormat:@"%li", (long)[self yearForIndexPath:indexPath]];
    }
    
    return cell;
}




#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (tableView == self.dateDayTableView) {
        _selectedDay = [self dayForIndexPath:indexPath];
    } else if (tableView == self.dateMonth) {
        _selectedMonth = [self monthForIndexPath:indexPath];
        [self updateSelectedDayWithAnimation:YES];
    } else if (tableView == self.dateYear) {
        _selectedYear = [self yearForIndexPath:indexPath];
        [self updateSelectedMonthWithAnimation:YES];
        [self updateSelectedDayWithAnimation:YES];
    }
    
    [self.delegate recurrenceDialog:self updatedRecurrence:[self recurrenceRule]];
}




#pragma mark UIView

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.repeatTimesLabel.text = [NSString stringWithFormat:@"%li", (long)self.initialRecurrenceRule.interval];
    
    self.endTypeButton.states = @[END_NEVER, END_ON_DATE, END_AFTER];
    
    EKRecurrenceEnd *end = self.initialRecurrenceRule.recurrenceEnd;
    if (end && end.endDate) {
        _selectedDay = [end.endDate mt_dayOfMonth];
        _selectedMonth = [end.endDate mt_monthOfYear];
        _selectedYear = [end.endDate mt_year];
        self.dateView.hidden = NO;
        _endType = 1;
    } else if (end && end.occurrenceCount != 0) {
        self.endAfterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)end.occurrenceCount];
        self.endAfterView.hidden = NO;
        _endType = 2;
    }
    
    self.endTypeButton.currentState = _endType;
    
    [self updateSelectedYearWithAnimation:YES];
    [self updateSelectedMonthWithAnimation:YES];
    [self updateSelectedDayWithAnimation:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
