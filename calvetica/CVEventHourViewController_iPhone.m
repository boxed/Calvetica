//
//  CVEventHourViewController.m
//  calvetica
//
//  Created by Adam Kirk on 5/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVEventHourViewController_iPhone.h"
#import "UIView+Utilities.h"



@interface CVEventHourViewController_iPhone ()
@property (nonatomic, assign)          CVEventHourViewControllerMode mode;
@property (nonatomic, strong  )          NSMutableArray                *unitButtons;
@property (nonatomic, weak  ) IBOutlet CVViewButton                  *startTimeButton;
@property (nonatomic, weak  ) IBOutlet UILabel                       *endTimeLabel;
@property (nonatomic, weak  ) IBOutlet CVViewButton                  *endTimeButton;
@property (nonatomic, weak  ) IBOutlet CVViewButton                  *allDayButton;
@property (nonatomic, weak  ) IBOutlet UIView                        *allDayButtonContainer;
@property (nonatomic, weak  ) IBOutlet UITableView                   *endDateTableView;
@property (nonatomic, weak  ) IBOutlet UILabel                       *AMTitleLabel;
@property (nonatomic, weak  ) IBOutlet UILabel                       *PMTitleLabel;
@end




@implementation CVEventHourViewController_iPhone

- (void)dealloc
{
    self.endDateTableView.delegate      = nil;
    self.endDateTableView.dataSource    = nil;
}

- (id)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay useMilitaryTime:(BOOL)military
{
    self = [super init];
    if (self) {
        _startDate				= startDate;
		_endDate				= endDate;
		_allDay					= allDay;
		_militaryTime			= military;
		_unitButtons			= [NSMutableArray array];
		_startDateUpdatedBlock	= nil;
		_endDateUpdatedBlock	= nil;
		_allDayUpdatedBlock     = nil;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	for (CVViewButton *button in @[ _startTimeButton, _endTimeButton, _allDayButton ]) {
		button.backgroundColorSelected	= patentedRed;
		button.textColorSelected		= patentedWhite;
		button.backgroundColorNormal	= patentedGray;
		button.textColorNormal			= patentedWhite;
	}

	for (UIView *view in self.view.subviews)
		if (view.tag >= HOUR_BUTTON_TAG_OFFSET && view.tag <= HOUR_BUTTON_TAG_OFFSET + 35)
			[_unitButtons addObject:view];

	for (CVViewButton *button in _unitButtons)
		[button addTarget:self action:@selector(unitButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];


	if (!_editable) {
		_startTimeButton.userInteractionEnabled = NO;
		_endTimeButton.userInteractionEnabled	= NO;
		for (CVViewButton *button in _unitButtons) {
			button.userInteractionEnabled = NO;
		}
	}

	// select end date in table view
    NSInteger row   = [[_endDate mt_startOfCurrentDay] mt_daysSinceDate:[_startDate mt_startOfCurrentDay]];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
    [_endDateTableView selectRowAtIndexPath:ip
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionMiddle];

	self.militaryTime	= _militaryTime;
	self.startDate		= _startDate;
	self.endDate		= _endDate;
	self.allDay			= _allDay;

	if (_allDay) {
        self.mode = CVEventHourViewControllerModeAllDay;
    } else {
        self.mode = CVEventHourViewControllerModeStartTime;
    }
}

- (void)setMode:(CVEventHourViewControllerMode)m 
{
    _mode = m;
    
    // update scratch date to start or end date depending on mode
    if (_mode == CVEventHourViewControllerModeStartTime) {
        _startTimeButton.selected	= YES;
        _endTimeButton.selected		= NO;
        _allDayButton.selected		= NO;
		self.startDate				= _startDate;
    }

	else if (_mode == CVEventHourViewControllerModeEndTime) {
        _startTimeButton.selected	= NO;
        _endTimeButton.selected		= YES;
        _allDayButton.selected		= NO;
		self.endDate				= _endDate;
    }

	else if (_mode == CVEventHourViewControllerModeAllDay) {
		_startTimeButton.selected	= NO;
        _endTimeButton.selected		= NO;
        _allDayButton.selected		= YES;
		self.allDay					= _allDay;
    }
}

- (void)setStartDate:(NSDate *)startDate
{
    if (!startDate) return;
	if (_startDateUpdatedBlock && ![_startDate isEqualToDate:startDate]) _startDateUpdatedBlock(startDate);
	_startDate = startDate;

	UILabel *label = [_startTimeButton.subviews lastObject];
	label.text = [startDate stringWithHourMinuteAndAMPM];

	[_startTimeButton bounce];

	[self selectButtonsForDate:startDate];
}

- (void)setEndDate:(NSDate *)endDate
{
    if (!endDate) return;
	if (_endDateUpdatedBlock && ![_endDate isEqualToDate:endDate]) _endDateUpdatedBlock(endDate);
	_endDate = endDate;

	UILabel *label = [_endTimeButton.subviews lastObject];
	label.text = [endDate stringWithHourMinuteAndAMPM];

	[_endTimeButton bounce];

	[self selectButtonsForDate:endDate];
}

- (void)setAllDay:(BOOL)allDay
{
	if (_allDayUpdatedBlock && _allDay != allDay) _allDayUpdatedBlock(allDay);
	_allDay = allDay;

	self.editable = !allDay;
	if (_allDay) {
		self.startDate	= [_startDate mt_startOfCurrentDay];
		self.endDate	= [_endDate mt_endOfCurrentDay];
	}

	[_allDayButton bounce];
}

- (void)setMilitaryTime:(BOOL)militaryTime
{
	_militaryTime = militaryTime;

	for (CVViewButton *button in _unitButtons) {
        NSString *text          = [self textForTag:button.tag];
        button.hidden           = NO;
        button.titleLabel.text  = text;
//        [button setTitle:text forState:UIControlStateNormal];
	}

    if (_militaryTime) {
        _AMTitleLabel.hidden = YES;
        _PMTitleLabel.hidden = YES;
    }
    else {
        _AMTitleLabel.hidden = NO;
        _PMTitleLabel.hidden = NO;
    }
}




#pragma mark - Actions

- (IBAction)unitButtonWasTapped:(CVViewButton *)button
{
    NSInteger tag   = button.tag - HOUR_BUTTON_TAG_OFFSET;
    NSUInteger col  = floor(tag / 12.0);

    NSDate *date    = _mode == CVEventHourViewControllerModeStartTime ? _startDate : _endDate;
    NSUInteger hour = [date mt_hourOfDay];
    NSUInteger min  = [date mt_minuteOfHour];
    BOOL isAM       = [date mt_isInAM];

	if (col == 0) {
		isAM = YES;
        hour = [self intFromString:button.titleLabel.text];
    }
	else if (col == 1) {
		isAM = NO;
        hour = [self intFromString:button.titleLabel.text];
    }
	else if (col == 2)
		min = [self intFromString:button.titleLabel.text];

    if (!_militaryTime) hour = isAM ? hour % 12 : (hour % 12) + 12;

	date = [NSDate mt_dateFromYear:[date mt_year]
                             month:[date mt_monthOfYear]
                               day:[date mt_dayOfMonth]
                              hour:hour
                            minute:min];

	if (_mode == CVEventHourViewControllerModeStartTime)	self.startDate	= date;
	if (_mode == CVEventHourViewControllerModeEndTime)		self.endDate	= date;
}

- (IBAction)startTimeButtonWasTapped:(id)sender 
{
    self.mode = CVEventHourViewControllerModeStartTime;
}

- (IBAction)endTimeButtonWasTapped:(id)sender 
{
    self.mode = CVEventHourViewControllerModeEndTime;
}

- (IBAction)allDayButtonWasTapped:(id)sender 
{
	if (_mode == CVEventHourViewControllerModeAllDay) {
		self.mode = CVEventHourViewControllerModeStartTime;
		self.allDay = NO;
	}
	else {
		self.mode = CVEventHourViewControllerModeAllDay;
		self.allDay = YES;
	}
}




#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 365 * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CVSelectionTableViewCell_iPhone *cell = [CVSelectionTableViewCell_iPhone cellWithStyle:UITableViewCellStyleDefault forTableView:tableView];
    
    NSDate *rowDate = [_startDate mt_dateDaysAfter:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [rowDate stringWithWeekdayAbbreviated:YES monthDayAbbreviated:YES];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    cell.textLabel.textColor = patentedDarkGray;
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSDate *rowDate = [_startDate mt_dateDaysAfter:indexPath.row];
    self.endDate = [NSDate mt_dateFromYear:[rowDate mt_year]
                                     month:[rowDate mt_monthOfYear]
                                       day:[rowDate mt_dayOfMonth]
                                      hour:[_endDate mt_hourOfDay]
                                    minute:[_endDate mt_minuteOfHour]];
}




#pragma mark - Private Methods

- (void)selectButtonsForDate:(NSDate *)d
{
	NSUInteger hour	= [d mt_hourOfDay];
	hour			= _militaryTime ? hour : hour % 12;
	hour			= hour == 0 && !_militaryTime ? 12 : hour;
	NSUInteger min	= [d mt_minuteOfHour];
	NSUInteger isAM	= [d mt_isInAM];
	for (CVViewButton *button in _unitButtons) {
        NSInteger tag       = button.tag - HOUR_BUTTON_TAG_OFFSET;
        NSUInteger col      = floor(tag / 12.0);
        NSString *text      = button.titleLabel.text;
        NSUInteger digit    = [self intFromString:text];
        button.selected     = NO;
        if (col == 2 && digit == min)
			button.selected = YES;
		else if (digit == hour) {
            if (_militaryTime) {
                button.selected = YES;
            }
            else if (isAM && col == 0) {
                button.selected = YES;
            }
            else if (!isAM && col == 1) {
                button.selected = YES;
            }
        }
	}

    NSInteger row = [[_endDate mt_startOfCurrentDay] mt_daysSinceDate:[_startDate mt_startOfCurrentDay]];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
    [_endDateTableView selectRowAtIndexPath:ip
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSString *)textForTag:(NSUInteger)tag
{
	tag -= HOUR_BUTTON_TAG_OFFSET;
	NSUInteger col = floor(tag / 12.0);
	NSUInteger row = tag % 12;

	if (_militaryTime) {
		if (col == 0) {
			return [NSString stringWithFormat:@"%d", row];
		}
		else if (col == 1) {
			return [NSString stringWithFormat:@"%d", row + 12];
		}
		else if (col == 2) {
			return [NSString stringWithFormat:@":%02d", row * 5];
		}
	}
	else {
		if (col == 0) {
			return [NSString stringWithFormat:@"%d", (row == 0 ? 12 : row)];
		}
		else if (col == 1) {
			return [NSString stringWithFormat:@"%d", (row == 0 ? 12 : row)];
		}
		else if (col == 2) {
			return [NSString stringWithFormat:@":%02d", row * 5];
		}
	}

	return nil;
}

- (NSUInteger)intFromString:(NSString *)string
{
	return [[string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] integerValue];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
