//
//  CVAgendaDateCell.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAgendaDateCell.h"
#import "colors.h"
#import "UILabel+Utilities.h"


@implementation CVAgendaDateCell

- (void)setDate:(NSDate *)newDate 
{
	_date = newDate;
	
	// set label text
	_weekdayLabel.text = [[_date stringWithTitleOfCurrentWeekDayAbbreviated:NO] lowercaseString];
	self.dateLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[_date mt_dayOfMonth]];
	
	if ([_date mt_isWithinSameDay:[NSDate date]]) {
		self.weekdayLabel.textColor = patentedRed;
	}
	else {
		self.weekdayLabel.textColor = calQuaternaryText();	
	}
	
	// move day label over
	CGRect f = self.dateLabel.frame;
	f.origin.x = self.weekdayLabel.frame.origin.x + [self.weekdayLabel sizeOfTextInLabel].width + 10;
	[self.dateLabel setFrame:f];
}



#pragma mark - Constructor

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)cellWasTapped:(id)sender
{
    
}


#pragma mark - Memory Management





#pragma mark - View lifecycle

- (void)awakeFromNib 
{
	[super awakeFromNib];
}




#pragma mark - Methods




@end
