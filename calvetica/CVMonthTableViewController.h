//
//  CVMonthTableViewController_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 5/28/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTodayBoxView.h"
#import "CVWeekTableViewCell.h"


@protocol CVMonthTableViewControllerDelegate;


@interface CVMonthTableViewController : UITableViewController {}

@property (nonatomic, weak  )          id<CVMonthTableViewControllerDelegate> delegate;
@property (nonatomic, strong)          NSDate                                 *startDate;
@property (nonatomic, strong)          NSDate                                 *selectedDate;
@property (nonatomic, strong)          NSMutableArray                         *loadedCells;
@property (nonatomic, weak  ) IBOutlet CVTodayBoxView                         *selectedDayView;

- (void)reloadTableView;
- (void)reloadRowForDate:(NSDate *)date;
- (void)scrollToRowForDate:(NSDate *)date animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)position;
- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated;
- (void)scrollToSelectedDay;
- (NSInteger)rowInMiddleOfVisibleRegion;
- (void)reframeRedSelectedDaySquareAnimated:(BOOL)animated;

@end



@protocol CVMonthTableViewControllerDelegate <NSObject>
- (void)monthTableViewController:(CVMonthTableViewController *)controller
                      tappedCell:(CVWeekTableViewCell *)cell
                          onDate:(NSDate *)date;
- (void)monthTableViewController:(CVMonthTableViewController *)controller
               longPressedOnCell:(CVWeekTableViewCell *)cell
                          onDate:(NSDate *)date
                 placeholderView:(UIView *)placeholder;
@end
