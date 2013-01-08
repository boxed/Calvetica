//
//  CVEventBarWithTitle_iPad.h
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Utilities.h"
#import "CVColoredDotView.h"
#import "CVLabel.h"
#import "colors.h"

@interface CVEventBarWithTitle_iPad : UIView <CVColoredDotViewDelegate> {
    CVColoredDotView *coloredDot;
    CVLabel *titleLabel;  
}

@property (nonatomic, strong) IBOutlet CVColoredDotView *coloredDot;
@property (nonatomic, strong) IBOutlet CVLabel *titleLabel;

@end
