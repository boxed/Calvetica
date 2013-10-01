//
//  CVMonthTableViewController_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVWeekTableViewCell.h"
#import "CVTodayBoxView.h"


@interface CVMonthTableViewController : UITableViewController {}


@property (nonatomic, weak) id<CVWeekTableViewCellDelegate> delegate;
@property (nonatomic, strong) UINib *weekCellNib;
@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) NSInteger mode;
@property (nonatomic, strong) NSMutableArray *loadedCells;


#pragma mark - Outlets
@property (nonatomic, weak) IBOutlet CVTodayBoxView *selectedDayView;


#pragma mark - Methods
- (void)drawDotsForVisibleRows;
- (void)reloadRowForDate:(NSDate *)date;
- (void)scrollToRowForDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)position;
- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated;
- (void)scrollToSelectedDay;
- (NSInteger)rowInMiddleOfVisibleRegion;
- (void)reframeRedSelectedDaySquareAnimated:(BOOL)animated;

@end
