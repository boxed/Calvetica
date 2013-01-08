//
//  CVGestureHowToViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UILabel+Utilities.h"
#import "CVModalProtocol.h"
#import "CVViewController.h"


@protocol CVGestureHowToViewControllerDelegate;


@interface CVGestureHowToViewController : CVViewController <UIScrollViewDelegate, CVModalProtocol>

@property (nonatomic, unsafe_unretained) id<CVGestureHowToViewControllerDelegate> delegate;

@end




@protocol CVGestureHowToViewControllerDelegate <NSObject>
@required
- (void)gestureControllerDidFinish:(CVGestureHowToViewController *)controller;
@end