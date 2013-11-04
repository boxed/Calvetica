//
//  CVEventDetailsRepeatViewController_iPhone.h
//  calvetica
//
//  Created by Quenton Jones on 5/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVNumericKeyPadViewController.h"
#import "CVMultiToggleButton.h"
#import "CVSelectionTableViewCell.h"
#import "CVViewController.h"
#import "strings.h"






typedef NS_ENUM(NSUInteger, CVEventDetailsRepeatResult) {
    CVEventDetailsRepeatResultDone,
    CVEventDetailsRepeatResultSaved,
    CVEventDetailsRepeatResultCancelled
};




@protocol CVEventDetailsRecurrenceDelegate;




@interface CVEventDetailsRepeatViewController : CVViewController <CVNumericKeyPadDelegate>

@property (nonatomic) NSInteger endType;
@property (nonatomic) NSInteger selectedDay;
@property (nonatomic) NSInteger selectedMonth;
@property (nonatomic) NSInteger selectedYear;


#pragma mark - Constructor

// Initializes the view controller with the given start date and recurrence rule.
- (id)initWithStartDate:(NSDate *)date recurrenceRule:(EKRecurrenceRule *)rule;


#pragma mark - Properties
@property (nonatomic, weak            ) NSObject<CVEventDetailsRecurrenceDelegate> *delegate;
@property (nonatomic, strong          ) NSDate                                     *startDate;
@property (nonatomic, copy            ) EKRecurrenceRule                           *initialRecurrenceRule;
@property (nonatomic, copy            ) NSArray                                    *daySymbols;
@property (nonatomic, copy            ) NSArray                                    *monthSymbols;
@property (nonatomic,         readonly) NSInteger                                  yearCount;


#pragma mark IBOutlets
@property (nonatomic, weak) IBOutlet UITableView         *dateDayTableView;
@property (nonatomic, weak) IBOutlet UITableView         *dateMonth;
@property (nonatomic, weak) IBOutlet UITableView         *dateYear;
@property (nonatomic, weak) IBOutlet UIView              *dateView;
@property (nonatomic, weak) IBOutlet UILabel             *endAfterLabel;
@property (nonatomic, weak) IBOutlet UIView              *endAfterView;
@property (nonatomic, weak) IBOutlet CVMultiToggleButton *endTypeButton;
@property (nonatomic, weak) IBOutlet UILabel             *repeatTimesLabel;
@property (nonatomic, weak) IBOutlet CVViewButton        *frequencyButton;
@property (nonatomic, weak) IBOutlet CVViewButton        *endCountButton;


#pragma mark - Methods

// Returns the number of days in the day table view.
- (NSInteger)dayCount;

// Returns the day of the month for the given index path.
- (NSInteger)dayForIndexPath:(NSIndexPath *)indexPath;

// Returns the end type button's title for the given index.
+ (NSString *)endTypeButtonTitleForIndex:(NSInteger)index;

// Determines the index path for the given day.
- (NSIndexPath *)indexPathForDay:(NSInteger)day;

// Determines the index path for the given month.
- (NSIndexPath *)indexPathForMonth:(NSInteger)month;

// Determines the index path for the given year.
- (NSIndexPath *)indexPathForYear:(NSInteger)year;

// Returns the number of months in the month table view.
- (NSInteger)monthCount;

// Returns the month of the year for the given index path.
- (NSInteger)monthForIndexPath:(NSIndexPath *)indexPath;

// Gets the new recurrence rule.
- (EKRecurrenceRule *)recurrenceRule;

// Updates the currently selected row in the days table view.
- (void)updateSelectedDayWithAnimation:(BOOL)animate;

// Updates the currently selected row in the months table view.
- (void)updateSelectedMonthWithAnimation:(BOOL)animate;

// Updates the currently selected row in the years table view.
- (void)updateSelectedYearWithAnimation:(BOOL)animate;

// Determines the year to display for the given index path.
- (NSInteger)yearForIndexPath:(NSIndexPath *)indexPath;


#pragma mark IBActions

// Called when the end after value button is pressed. Should open a numeric keypad.
- (IBAction)endAfterValueButtonPressed;

// Called when end type button is pressed. Should toggle between the three types.
- (IBAction)endTypeButtonPressed:(CVMultiToggleButton *)button;

// Called when the repeat value button is pressed. Should open a numeric keypad.
- (IBAction)repeatValueButtonPressed;


@end




@protocol CVEventDetailsRecurrenceDelegate <NSObject>

// Called when the recurrence rule is modified.
- (void)recurrenceDialog:(CVEventDetailsRepeatViewController *)dialog updatedRecurrence:(EKRecurrenceRule *)recurrenceRule;
- (void)eventDetailsRepeatViewController:(CVEventDetailsRepeatViewController *)controller didFinish:(CVEventDetailsRepeatResult)result;

@end
