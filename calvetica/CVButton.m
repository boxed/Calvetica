//
//  CVCustomButton.m
//  calvetica
//
//  Created by James Schultz on 4/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVButton.h"
#import "colors.h"

@implementation CVButton


- (void)setup 
{
    self.textColorNormal = patentedQuiteDarkGray;
    self.textColorHighlighted = patentedWhite;
    self.textColorSelected = patentedWhite;
    self.backgroundColorSelected = patentedRed;
    self.backgroundColorHighlighted = patentedBlack;
    self.backgroundColorNormal = patentedClear;
    self.selectable = NO;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];    
        self.selected = NO;
    }
    return self;
}

- (void)awakeFromNib 
{
    [self setup];
    
    self.textColorNormal = self.titleLabel.textColor;
    self.backgroundColorNormal = self.backgroundColor;
    
    self.selected = NO;
    
    [super awakeFromNib];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled 
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (userInteractionEnabled) {
        self.alpha = 1;
    } else {
        self.alpha = 0.3;
    }
}

- (void)setSelected:(BOOL)selected 
{
    super.selected = selected;
    if (selected) {
        self.backgroundColor = self.backgroundColorSelected;
        self.titleLabel.textColor = self.textColorSelected;
    } else {
        self.backgroundColor = self.backgroundColorNormal;
        self.titleLabel.textColor = self.textColorNormal;
    }
}

- (void)setHighlighted:(BOOL)highlighted 
{
    if (_selectable) return;
    
    super.highlighted = highlighted;
    if (highlighted) {
        self.backgroundColor = self.backgroundColorHighlighted;
        self.titleLabel.textColor = self.textColorHighlighted;
    } else {
        if (self.selected) {
            self.backgroundColor = self.backgroundColorSelected;
            self.titleLabel.textColor = self.textColorSelected;
        }
        else {
            self.backgroundColor = self.backgroundColorNormal;
            self.titleLabel.textColor = self.textColorNormal;            
        }
    }
}

- (void)setEnabled:(BOOL)enabled 
{
    super.enabled = enabled;
    self.userInteractionEnabled = enabled;
}



#pragma mark - Actions
/*
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if (!selectable) {
        self.highlighted = YES;
        return [super beginTrackingWithTouch:touch withEvent:event];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{
    if (!selectable) {
        self.highlighted = NO;       
    }
    
    [super endTrackingWithTouch:touch withEvent:event];
}
 */

@end
