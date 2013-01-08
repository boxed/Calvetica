//
//  CVDayButton_iPhone.m
//  calvetica
//
//  Created by Adam Kirk on 4/20/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDayButton_iPhone.h"


@interface CVDayButton_iPhone ()
@property NSUInteger dotColumn;
@property NSUInteger dotRow;
@property NSUInteger maxOffset;
@end




@implementation CVDayButton_iPhone


- (void)setIsToday:(BOOL)isTodayBool 
{
    _isToday = isTodayBool;
    if (isTodayBool) {
        if (!_isRootViewController) {
            // customized placement of backgroundImageView for the jumpToDateViewController
            // previously it was misaligned because in RootView the image has a different placement
            CGRect rect1 = CGRectMake(0, 0, 36, 35);
            [_backgroundImageView setFrame:rect1];
        }
        _backgroundImageView.hidden = NO;
        [_label setWhiteWithLightShadow];
    } else {
        _backgroundImageView.hidden = YES;
        [_label setDarkGrayWithLightShadow];
    }
}

- (void)setIsSelected:(BOOL)isSelectedBool 
{
    _isSelected = isSelectedBool;
}

- (void)setDate:(NSDate *)newDate 
{
    _date = newDate;
    self.label.text = [NSString stringWithFormat:@"%d", [newDate dayOfMonth]];
}

- (void)drawDotWithOffset:(NSUInteger)offset shape:(CVColoredShape)shape rect:(CGRect)rect color:(UIColor *)color 
{

    CVColoredDotView *dot = [[CVColoredDotView alloc] initWithFrame:rect];
    dot.shape = shape;
    dot.color = color;
    
    // if its a basic shape, reframe and add it to the dot container
    if (shape == CVColoredShapeCircle || shape == CVColoredShapeTriangle || shape == CVColoredShapeRectangle) {
        rect.origin.x = _dotColumn++ * DOT_LINE_HEIGHT;
        if (rect.origin.x + rect.size.width > self.dotViewContainer.frame.size.width) {
            rect.origin.x = 0;
            _dotRow++;
            _dotColumn = 1;
        }
        rect.origin.y = _dotRow * DOT_LINE_HEIGHT;
        [dot setFrame:rect];
        [self.dotViewContainer addSubview:dot];
    } 
    
    // otherwise, its a bar, so we need to draw it exactly as framed
    else {
        [self.barViewContainer addSubview:dot];

        // move the dot container down for each bar thats added
        if (offset >= _maxOffset) {
            _maxOffset = offset + 1;
            CGRect f = self.dotViewContainer.frame;
            f.origin.y = _barViewContainer.frame.origin.y + (_maxOffset * DOT_LINE_HEIGHT);

            // make sure that we don't push it down past the bottom of the bar container
            CGFloat maxBarContainerY = _barViewContainer.frame.origin.y + _barViewContainer.frame.size.height;
            if (f.origin.y > maxBarContainerY) {
                f.origin.y = maxBarContainerY;
            }

            [self.dotViewContainer setFrame:f];
        }
    }
    
}

- (void)clearDots 
{
    for (UIView *v in self.barViewContainer.subviews) {
        [v removeFromSuperview];
    }
    for (UIView *v in self.dotViewContainer.subviews) {
        [v removeFromSuperview];
    }    
    _dotColumn = 0;
    _dotRow = 0;
    
    CGRect f = self.dotViewContainer.frame;
    f.origin.y = _barViewContainer.frame.origin.y;
    [self.dotViewContainer setFrame:f];
    _maxOffset = 0;
}


    
@end
