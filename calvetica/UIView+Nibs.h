//
//  UIView+nibs.h
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface UIView (UIView_Nibs)

#pragma mark - Convenience Constructors
+ (id)viewFromNib:(UINib *)nib;
+ (id)viewFromNib:(UINib *)nib withPosition:(CGPoint)position;

#pragma mark - Methods
+ (UINib *)nib;
+ (NSString *)nibName;
+ (NSString *)viewIdentifier;
+ (NSString *)className;

@end
