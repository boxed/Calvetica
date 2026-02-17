//
//  CVWeekTableViewCell_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSDate+ViewHelpers.h"
#import "viewtagoffsets.h"
#import "CVTapGestureRecognizer.h"
#import "CVTapReleaseGestureRecognizer.h"
#import "CVWeekTableViewCellDrawing.h"

NS_ASSUME_NONNULL_BEGIN



@protocol CVWeekTableViewCellDelegate;


@interface CVWeekTableViewCell : UITableViewCell <UIGestureRecognizerDelegate, CVWeekTableViewCellDrawingDataSource> {}

@property (nonatomic, nullable, weak  )          id<CVWeekTableViewCellDelegate> delegate;
@property (nonatomic, strong)          NSDate                          *weekStartDate;
@property (nonatomic, strong)          NSDate                          *selectedDate;
@property (nonatomic, assign)          NSInteger                       mode;
@property (nonatomic, assign)          NSInteger                       fontSize;
@property (nonatomic, strong)          CVWeekTableViewCellDrawing      *drawingView;
@property (nonatomic, nullable, weak  ) IBOutlet UILabel                         *monthLabel;
@property (nonatomic, nullable, weak  ) IBOutlet UIImageView                     *todayImage;

- (void)redraw;

@end


@protocol CVWeekTableViewCellDelegate <NSObject>
- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasPressedOnDate:(NSDate *)date;
- (void)weekTableViewCell:(CVWeekTableViewCell *)cell wasLongPressedOnDate:(NSDate *)date withPlaceholder:(UIView *)placeholder;
@end

NS_ASSUME_NONNULL_END
