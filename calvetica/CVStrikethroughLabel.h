//
//  CVStrikethroughLabel.h
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

#import <UIKit/UIKit.h>

@interface CVStrikethroughLabel : UILabel
- (void)toggleStrikeThroughWithCompletion:(void (^)(void))completion;
@end
