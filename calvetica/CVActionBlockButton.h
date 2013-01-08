//
//  CVActionBlockButton.h
//  calvetica
//
//  Created by Adam Kirk on 6/6/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVRoundedButton.h"

@class CVAlertViewController;

@interface CVActionBlockButton : CVRoundedButton

@property (nonatomic, strong) void (^actionBlock)(void);
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) CVAlertViewController *alertViewController;

+ (CVActionBlockButton *)buttonWithTitle:(NSString *)title andActionBlock:(void (^)(void))tapActionBlock;

@end
