//
//  UILabel+Utilities.h
//  calvetica
//
//  Created by Adam Kirk on 5/31/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "colors.h"
#import "CVDebug.h"

NS_ASSUME_NONNULL_BEGIN


@interface UILabel (Utilities)


#pragma mark - Methods
- (CGSize)sizeOfTextInLabel;
- (NSInteger)linesOfWordWrapTextInLabelWithConstraintWidth:(CGFloat)width;
- (CGFloat)totalHeightOfWordWrapTextInLabelWithConstraintWidth:(CGFloat)width;

- (void)setWhiteWithLightShadow;
- (void)setWhiteWithDarkShadow;

- (void)setBlackWithLightShadow;
- (void)setBlackWithDarkShadow;

- (void)setDarkGrayWithLightShadow;
- (void)setDarkGrayWithDarkShadow;

- (void)setWhiteNoShadow;
- (void)setBlackNoShadow;
- (void)setDarkGrayNoShadow;

@end

NS_ASSUME_NONNULL_END
