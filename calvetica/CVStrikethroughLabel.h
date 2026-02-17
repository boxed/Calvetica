//
//  CVStrikethroughLabel.h
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CVStrikethroughLabel : UILabel
- (void)toggleStrikeThroughWithCompletion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
