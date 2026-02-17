//
//  CVCustomButton.h
//  calvetica
//
//  Created by James Schultz on 4/26/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIView+Nibs.h"

NS_ASSUME_NONNULL_BEGIN


@interface CVButton : UIButton

- (void)setup;

@property (nonatomic) BOOL selectable;
@property (nonatomic, strong) UIColor *backgroundColorNormal;
@property (nonatomic, strong) UIColor *backgroundColorHighlighted;
@property (nonatomic, strong) UIColor *backgroundColorSelected;
@property (nonatomic, strong) UIColor *textColorNormal;
@property (nonatomic, strong) UIColor *textColorHighlighted;
@property (nonatomic, strong) UIColor *textColorSelected;


@end

NS_ASSUME_NONNULL_END
