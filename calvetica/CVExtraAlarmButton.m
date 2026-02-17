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

- (instancetype)initWithFrame:(CGRect)frame 
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
	self.textColorSelected = calBackgroundColor();
}




#pragma mark - Methods




@end
