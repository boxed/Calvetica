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

// Animates the strikethrough on/off. `expectedText` is the title of the item the
// caller thinks this label is showing: if the label has since been handed to a
// different calendar item (cell reuse, a reload landing between the tap and this
// call) the animation is skipped so the line can never end up on the wrong item.
- (void)toggleStrikeThroughForText:(nullable NSString *)expectedText
                        completion:(nullable void (^)(void))completion;

// Stops any in-flight animation and removes a partially drawn line. Called
// automatically whenever the label's text is replaced.
- (void)cancelStrikeThroughAnimation;

@end

NS_ASSUME_NONNULL_END
