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


@implementation CVEventDayViewController


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
                                animated:YES
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

    dispatch_async([CVOperationQueue backgroundQueue], ^{
        // layout day buttons
        self.dayButtons = [NSMutableArray array];
        
        NSInteger gridw = 7.0;
        NSInteger gridh = 6.0;
        float containerw = _dayButtonsContainer.frame.size.width;
        float containerh = _dayButtonsContainer.frame.size.height;
        float w = containerw / gridw;
        float h = containerh / gridh;
        
        for (int i = 0; i < gridh * gridw; i++) {
            float x = round((i % gridw) * w);
            float y = round(floor((float)i / (float)gridw) * h);
            
           dispatch_async(dispatch_get_main_queue(), ^{
                
                CVJumpToDayButton *b = [CVJumpToDayButton fromNibOfSameName];
                
                // hide the gray today background
                b.backgroundImageView.hidden = YES;
                
                [b setFrame:CGRectMake(x,y,w,h)];
                b.label.text = [NSString stringWithFormat:@"%d",i+1];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dayButtonWasTapped:)];
                [b addGestureRecognizer:tapGesture];
                
                [_dayButtonsContainer addSubview:b];  
                [self.dayButtons addObject:b];
           });
        }
        
        
        // layout week buttons
        self.weekButtons = [NSMutableArray array];
        
        
        gridh = 6.0;
        containerw = _weekButtonsContainer.frame.size.width;
        containerh = _weekButtonsContainer.frame.size.height;
        w = containerw;
        h = containerh / gridh;
        
        for (int i = 0; i < gridh; i++) {
            float x = 0;
            float y = round((float)i * h);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CVJumpToDayButton *b = [CVJumpToDayButton fromNibOfSameName];
                
                // hide the gray today background
                b.backgroundImageView.hidden = YES;
                
                [b.label setWhiteWithLightShadow];
                [b setFrame:CGRectMake(x,y,w,h)];
                b.label.text = [NSString stringWithFormat:@"%d",i+1];
                [self.weekButtons addObject:b];
                [_weekButtonsContainer addSubview:b];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // update view with date
            self.date = self.initialDate;
        });
    });

    self.containerView.height = MAX(self.containerView.height, 362);
    self.scrollView.contentSize = CGSizeMake(self.containerView.width, self.containerView.height);

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
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.frame = cell.bounds;
    cell.textLabel.textColor = patentedQuiteDarkGray;
    
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
