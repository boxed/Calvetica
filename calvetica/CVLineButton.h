//
//  CVLineButton.h
//  calvetica
//
//  Created by Adam Kirk on 9/24/13.
//
//

#import <UIKit/UIKit.h>

@interface CVLineButton : UIButton {
    @protected
    MTPencil *_pencil;
}
- (void)commonInit;
- (void)setupPencil;
- (void)redrawWithCompletion:(void (^)(void))completion;
@end
