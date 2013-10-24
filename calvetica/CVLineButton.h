//
//  CVLineButton.h
//  calvetica
//
//  Created by Adam Kirk on 9/24/13.
//
//

#import <UIKit/UIKit.h>


static CGFloat const CVStackedBarButtonSpacing  = 4;
static CGFloat const CVStackedBarButtonDuration = 0.2;


@interface CVLineButton : UIButton {
    @protected
    MTPencil *_pencil;
}
- (void)commonInit;
- (void)setupPencil;
- (void)redrawWithCompletion:(void (^)(void))completion;
@end
