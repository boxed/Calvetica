//
//  CVExtraAlarmButton.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVExtraAlarmButton.h"
#import "colors.h"



@implementation CVExtraAlarmButton




#pragma mark - Properties




#pragma mark - Constructor

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}



#pragma mark - Memory Management





#pragma mark - View lifecycle

- (void)awakeFromNib 
{
	[super awakeFromNib];
	
	self.backgroundColorSelected = patentedDarkRed;
	self.textColorSelected = patentedWhite;
}




#pragma mark - Methods




@end
