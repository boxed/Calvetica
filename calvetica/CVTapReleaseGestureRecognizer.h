//
//  CVTapReleaseGestureRecognizer.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CVTapGestureRecognizer.h"

NS_ASSUME_NONNULL_BEGIN



/*!
    @class      CVTapReleaseGestureRecognizer
    @abstract   Recognizes when a tap is released.
    @discussion 
 */
@interface CVTapReleaseGestureRecognizer : UIGestureRecognizer {
    BOOL validGesture;
}


#pragma mark - Properties


#pragma mark - Methods


@end

NS_ASSUME_NONNULL_END
