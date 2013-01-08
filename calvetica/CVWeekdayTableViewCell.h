//
//  CVWeekdayTableViewCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAllDayEventSquaresView.h"
#import "CVEventSquaresView.h"


@protocol CVWeekdayTableViewCellDelegate;


@interface CVWeekdayTableViewCell : UITableViewCell <CVEventSquaresViewDelegate, CVAllDayEventSquaresViewDelegate>


#pragma mark - Properties
@property (nonatomic, unsafe_unretained) id<CVWeekdayTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) IBOutlet UILabel *weekdayTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *monthDayTitleLabel;
@property (nonatomic, strong) IBOutlet UIView *redBarView;
@property (nonatomic, strong) IBOutlet CVEventSquaresView *squaresView;
@property (nonatomic, strong) IBOutlet CVAllDayEventSquaresView *allDaySquaresView;


#pragma mark - Methods
- (void)drawEventSquares;


#pragma mark - IBActions
- (IBAction)headerBarWasTapped:(id)sender;


@end




@protocol CVWeekdayTableViewCellDelegate <NSObject>
@required
- (void)weekdayCellHeaderWasTapped:(CVWeekdayTableViewCell *)cell;
- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder;
- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder;
@end
