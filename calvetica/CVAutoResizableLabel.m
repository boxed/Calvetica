//
//  CVAutoResizableLabel.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVAutoResizableLabel.h"




@implementation CVAutoResizableLabel


- (void)setText:(NSString *)text 
{
    [super setText:text];
    if (_autoResize) {
        [self sizeToFitWithAnimation];
    }
}




#pragma mark - Constructor

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}




#pragma mark - Memory Management





#pragma mark - View lifecycle

- (void)awakeFromNib 
{
    [super awakeFromNib];
}




#pragma mark - Methods

- (void)setDefaults 
{
    _autoResize = YES;
    _maximumHeight = DEFAULT_MAX;
    _maximumWidth = DEFAULT_MAX;
    _minimumHeight = DEFAULT_MIN;
    _minimumWidth = DEFAULT_MIN;
    _padding = DEFAULT_PADDING;
}

- (CGSize)sizeThatFits:(CGSize)size 
{
    CGSize sizeThatFits = CGSizeMake(self.minimumWidth, self.minimumHeight);

    CGSize textSize = [self.text sizeWithFont:self.font];
    CGFloat availableTextWidth = sizeThatFits.width - (_padding.width * 2);
    CGFloat availableTextHeight = sizeThatFits.height - (_padding.height * 2);
    
    // Check to see if we have enough room for the text, taking the padding into consideration. If we don't, adjust the size.
    if (availableTextWidth < textSize.width) {
        CGFloat addWidth = textSize.width - availableTextWidth;
        sizeThatFits.width += addWidth;
    }
    
    if (availableTextHeight < textSize.height) {
        CGFloat addHeight = textSize.height - availableTextHeight;
        sizeThatFits.height += addHeight;
    }
    
    // Double check that we haven't exceeded our max width/height;
    if (sizeThatFits.width > self.maximumWidth) {
        sizeThatFits.width = self.maximumWidth;
        // @todo: Keep the padding.
    }
    sizeThatFits.height = sizeThatFits.height > self.maximumHeight ? self.maximumHeight : sizeThatFits.height;
    
    return sizeThatFits;
}

- (void)sizeToFitWithAnimation 
{
    [UIView animateWithDuration:0.2f animations:^(void) {
        [self sizeToFit];
    }];
}




@end
