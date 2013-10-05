//
//  CVWeekTableViewCell_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "EKEvent+Utilities.h"
#import "NSDate+ViewHelpers.h"
#import "viewtagoffsets.h"
#import "CVTapGestureRecognizer.h"
#import "CVTapReleaseGestureRecognizer.h"
#import "CVWeekTableViewCellDrawing.h"


@protocol CVWeekTableViewCellDelegate;

@interface CVWeekTableViewCell : UITableViewCell <UIGestureRecognizerDelegate, CVWeekTableViewCellDrawingDataSource> {}

@property (nonatomic, weak  )          id<CVWeekTableViewCellDelegate> delegate;
@property (nonatomic, strong)          NSDate                          *weekStartDate;
@property (nonatomic, strong)          NSDate                          *absoluteStartDate;
@property (nonatomic, strong)          NSDate                          *selectedDate;
@property (nonatomic, assign)          NSInteger                       mode;
@property (nonatomic, assign)          NSInteger                       fontSize;
@property (nonatomic, strong)          CVWeekTableViewCellDrawing      *drawingView;
@property (nonatomic, weak  ) IBOutlet UILabel                         *monthLabel;
@property (nonatomic, weak  ) IBOutlet UIImageView                     *todayImage;


#pragma mark - Methods
- (void)redraw;


#pragma mark - IBActions
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture;


@end


@protocol CVWeekTableViewCellDelegate <NSObject>
@required
- (BOOL)isInPortrait;
- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasPressedOnDate:(NSDate *)date;
- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasLongPressedOnDate:(NSDate *)date withPlaceholder:(UIView *)placeholder;
@end
