//
//  CVSquaresView_iPad.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@protocol CVEventSquaresViewDelegate;


@interface CVEventSquaresView : UIView

@property (nonatomic, nullable, weak  ) id<CVEventSquaresViewDelegate> delegate;
@property (nonatomic, strong) NSDate                         *date;
@property (nonatomic, copy  ) NSArray<CVCalendarItemShape *>                        *squares;

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture;

@end


@protocol CVEventSquaresViewDelegate <NSObject>
- (void)squaresView:(CVEventSquaresView *)view wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder;
- (void)squaresView:(CVEventSquaresView *)view wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder;
@end

NS_ASSUME_NONNULL_END