//
//  CVSquaresView_iPad.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//


@protocol CVEventSquaresViewDelegate;


@interface CVEventSquaresView : UIView

#pragma mark - Properties
@property (nonatomic, weak) id<CVEventSquaresViewDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *squares;

#pragma mark - IBActions
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture;

@end




@protocol CVEventSquaresViewDelegate <NSObject>
@required
- (void)squaresView:(CVEventSquaresView *)view wasLongPressedAtDate:(NSDate *)datePressed allDay:(BOOL)allDay withPlaceholder:(UIView *)placeholder;
- (void)squaresView:(CVEventSquaresView *)view wasPressedOnEvent:(EKEvent *)event withPlaceholder:(UIView *)placeholder;
@end
