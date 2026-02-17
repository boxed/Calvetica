//
//  CVWeekdayTableViewCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAllDayEventSquaresView.h"
#import "CVEventSquaresView.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVWeekdayTableViewCellDelegate;


@interface CVWeekdayTableViewCell : UITableViewCell <CVEventSquaresViewDelegate, CVAllDayEventSquaresViewDelegate>


@property (nonatomic, nullable, weak  )          id<CVWeekdayTableViewCellDelegate> delegate;
@property (nonatomic, strong)          NSDate                             *date;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                            *weekdayTitleLabel;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                            *monthDayTitleLabel;
@property (nonatomic, nullable, weak  ) IBOutlet UIView                             *redBarView;
@property (nonatomic, nullable, weak  ) IBOutlet CVEventSquaresView                 *squaresView;
@property (nonatomic, nullable, weak  ) IBOutlet CVAllDayEventSquaresView           *allDaySquaresView;

- (void)drawEventSquares;

- (IBAction)headerBarWasTapped:(id)sender;

@end




@protocol CVWeekdayTableViewCellDelegate <NSObject>
@required
- (void)weekdayCellHeaderWasTapped:(CVWeekdayTableViewCell *)cell;
- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder;
- (void)weekdayCell:(CVWeekdayTableViewCell *)cell wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder;
@end

NS_ASSUME_NONNULL_END
