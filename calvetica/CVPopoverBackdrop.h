//
//  CVPopoverBackdrop.h
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "dimensions.h"
#import "colors.h"
#import "geometry.h"

typedef enum {
	CVPopoverArrowDirectionNone			= 0,
    CVPopoverArrowDirectionTopLeft		= 1UL << 0,
    CVPopoverArrowDirectionTopMiddle	= 1UL << 1,
    CVPopoverArrowDirectionTopRight		= 1UL << 2,
    CVPopoverArrowDirectionBottomLeft	= 1UL << 3,
    CVPopoverArrowDirectionBottomMiddle = 1UL << 4,
    CVPopoverArrowDirectionBottomRight	= 1UL << 5,
    CVPopoverArrowDirectionLeftTop		= 1UL << 6,
    CVPopoverArrowDirectionLeftMiddle	= 1UL << 7,
    CVPopoverArrowDirectionLeftBottom	= 1UL << 8,
    CVPopoverArrowDirectionRightTop		= 1UL << 9,
    CVPopoverArrowDirectionRightMiddle	= 1UL << 10,
    CVPopoverArrowDirectionRightBottom	= 1UL << 11,
	CVPopoverArrowDirectionAny			= CVPopoverArrowDirectionTopLeft | CVPopoverArrowDirectionTopMiddle | CVPopoverArrowDirectionTopRight | CVPopoverArrowDirectionBottomLeft | CVPopoverArrowDirectionBottomMiddle | CVPopoverArrowDirectionBottomRight | CVPopoverArrowDirectionLeftTop | CVPopoverArrowDirectionLeftMiddle | CVPopoverArrowDirectionLeftBottom | CVPopoverArrowDirectionRightTop | CVPopoverArrowDirectionRightMiddle | CVPopoverArrowDirectionRightBottom
} CVPopoverArrowDirection;


typedef enum {
	CVPopoverModalAttachToSideNone,
	CVPopoverModalAttachToSideTop,
    CVPopoverModalAttachToSideRight,
    CVPopoverModalAttachToSideBottom,
    CVPopoverModalAttachToSideLeft,
	CVPopoverModalAttachToSideCenter
} CVPopoverModalAttachToSide;


@interface CVPopoverBackdrop : UIView

@property (nonatomic, assign) CVPopoverArrowDirection arrowDirection;
@property (nonatomic, strong) UIColor                 *backdropColor;

@end
