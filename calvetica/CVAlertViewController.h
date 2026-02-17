//
//  CVAlertViewController.h
//  calvetica
//
//  Created by Adam Kirk on 5/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVViewController.h"
#import "CVActionBlockButton.h"

NS_ASSUME_NONNULL_BEGIN



@interface CVAlertViewController : CVViewController {
}


#pragma mark - Properties
@property (nonatomic, copy) void (^closeButtonAction)(void);


#pragma mark - IBOutlets
@property (nonatomic, nullable, weak) IBOutlet UILabel        *titleLabel;
@property (nonatomic, nullable, weak) IBOutlet UITextView     *messageTextView;
@property (nonatomic, nullable, weak) IBOutlet UIView         *buttonContainerView;
@property (nonatomic, strong)          NSMutableArray<CVActionBlockButton *> *buttons;
@property (nonatomic, strong)          void           (^completion)(void);


#pragma mark - Methods
- (void)addButton:(CVActionBlockButton *)button;
- (void)dismiss;
- (void)setMessageText:(NSString *)message resizeDialog:(BOOL)resize;


#pragma mark - Actions
- (IBAction)closeButtonWasTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
