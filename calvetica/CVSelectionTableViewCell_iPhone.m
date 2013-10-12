//
//  CVYearTableViewCell.m
//  calvetica
//
//  Created by Adam Kirk on 4/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVSelectionTableViewCell_iPhone.h"


@implementation CVSelectionTableViewCell_iPhone

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];

    if (selected) {
        if (_isDarkRed) {
            self.backgroundColor = patentedDarkRed;
        }
        else {
            self.backgroundColor = patentedRed;
        }
        self.textLabel.textColor = patentedWhite;
    } else {
        self.backgroundColor = patentedClear;
        self.textLabel.textColor = patentedQuiteDarkGray;
    }
}


@end
