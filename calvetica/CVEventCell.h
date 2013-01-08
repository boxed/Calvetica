//
//  CVEventCell.h
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"
#import "EKEvent+Utilities.h"

typedef enum {
    CVEventCellSwipedDirectionLeft,
    CVEventCellSwipedDirectionRight
} CVEventCellSwipedDirection;

@protocol CVEventCellDelegate;
@class CVSearchViewController_iPhone;

@interface CVEventCell : CVCell

#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVEventCellDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic) BOOL isAllDay;
@property (nonatomic) CGFloat durationBarPercent;
@property (nonatomic) CGFloat secondaryDurationBarPercent;
@property (nonatomic, strong) UIColor *durationBarColor;
@property (nonatomic, strong) UIColor *secondaryDurationBarColor;

#pragma mark - Outlets
@property (nonatomic, strong) IBOutlet UILabel *noEventLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dividerLine;
@property (nonatomic, strong) IBOutlet UIView *durationBarView;
@property (nonatomic, strong) IBOutlet UIView *secondaryDurationBarView;
@property (nonatomic, strong) IBOutlet UILabel *hourAndMinuteLabel;
@property (nonatomic, strong) IBOutlet UILabel *AMPMLabel;
@property (nonatomic, strong) IBOutlet UILabel *allDayLabel;
@property (nonatomic, strong) IBOutlet UIControl *timeTextHitArea;
@property (nonatomic, strong) IBOutlet UIImageView *repeatTinyIcon;
@property (nonatomic, strong) IBOutlet UIImageView *notesTinyIcon;
@property (nonatomic, strong) IBOutlet UIImageView *locationTinyIcon;
@property (nonatomic, strong) IBOutlet UIImageView *attendeesTinyIcon;

#pragma mark - Methods
- (void)drawDurationBarAnimated:(BOOL)animated;


#pragma mark - IBActions
- (IBAction)hourTimeWasTapped:(id)sender;


@end



@protocol CVEventCellDelegate <NSObject>
@optional
- (void)searchController:(CVSearchViewController_iPhone *)controller cellWasTapped:(CVEventCell *)cell;
@required
- (void)cellHourTimeWasTapped:(CVEventCell *)cell;
- (void)cellWasTapped:(CVEventCell *)cell;
- (void)cellWasLongPressed:(CVEventCell *)cell;
- (void)cell:(CVEventCell *)cell wasSwipedInDirection:(CVEventCellSwipedDirection)direction;
- (void)cell:(CVCell *)cell alarmButtonWasTappedForCalendarItem:(EKCalendarItem *)calendarItem;
- (void)cellEventWasDeleted:(CVEventCell *)cell;
@end
