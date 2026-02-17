//
//  CVTapGestureRecognizer.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

NS_ASSUME_NONNULL_BEGIN


#define DEFAULT_MAX_TAP_DURATION 0.10f

/*!
    @class      CVTapGestureRecognizer
    @abstract   Recognizes taps.
    @discussion Taps are recognized normally, but a view that is "pressed" on will also register a tap when a specific amount of time (specified by maximumTapDuration) has expired.
*/
@interface CVTapGestureRecognizer : UIGestureRecognizer

/*!
    @property   maximumTapDuration
    @abstract   A tap will be recognized after this amount of time has elasped, even if the user doesn't release their finger.
*/
@property (nonatomic, assign) CGFloat maximumTapDuration;

/*!
    @property   tapTimer
    @abstract   
*/
@property (nonatomic, strong) NSTimer *tapTimer;

/*!
    @method     tapOccurred
    @abstract   Fired when a single tap is recognized.
    @discussion
*/
- (void)tapOccurred;

@end

NS_ASSUME_NONNULL_END
