//
//  CVCalendarTableViewCell_iPhone.m
//  calvetica
//
//  Created by James Schultz on 5/15/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCalendarTableViewCell_iPhone.h"


@implementation CVCalendarTableViewCell_iPhone

- (id)init 
{
    self = [super init];
    if (self) {
        self.disabled = NO;
    }
    return self;
}

- (void)awakeFromNib 
{
	self.disabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
	
    if (selected) {
        self.checkmarkImageButton.hidden = NO;
    }
    else {
        self.checkmarkImageButton.hidden = YES;
    }
}

- (void)setDisabled:(BOOL)newDisabled 
{
	_disabled = newDisabled;
	
	if (newDisabled) {
		self.userInteractionEnabled = NO;
		_coloredDotView.alpha = 0.5;
		_calendarTitleLabel.alpha = 0.5;
		_calendarTypeLabel.alpha = 0.5;
	}
	else {
		self.userInteractionEnabled = YES;
		_coloredDotView.alpha = 1;
		_calendarTitleLabel.alpha = 1;
		_calendarTypeLabel.alpha = 1;		
	}
}




@end
