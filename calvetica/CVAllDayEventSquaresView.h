//
//  CVAllDayEventSquareView_iPad.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@class CVCalendarItemShape;
@protocol CVAllDayEventSquaresViewDelegate;


@interface CVAllDayEventSquaresView : UIView {
}


#pragma mark - Properties
@property (nonatomic, nullable, weak  ) id<CVAllDayEventSquaresViewDelegate> delegate;
@property (nonatomic, strong) NSDate                               *date;
@property (nonatomic, copy  ) NSArray<CVCalendarItemShape *>                              *squares;


#pragma mark - Methods


#pragma mark - IBActions
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture;


@end




@protocol CVAllDayEventSquaresViewDelegate <NSObject>
@required
- (void)allDaySquaresView:(CVAllDayEventSquaresView *)view wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder;
- (void)allDaySquaresView:(CVAllDayEventSquaresView *)view wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder;
@end

NS_ASSUME_NONNULL_END