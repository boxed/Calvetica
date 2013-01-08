//
//  UIView+nibs.m
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+nibs.h"


@implementation UIView (UIView_Nibs)

#pragma mark - Convenience Constructors

+ (id)viewFromNib:(UINib *)nib {
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        NSAssert2(([nibObjects count] > 0) && 
                  [[nibObjects objectAtIndex:0] isKindOfClass:[self class]],
                  @"Nib '%@' does not appear to contain a valid %@", 
                  [self nibName], NSStringFromClass([self class]));
    return [nibObjects objectAtIndex:0];
}

+ (id)viewFromNib:(UINib *)nib withPosition:(CGPoint)position {
    UIView *view = [UIView viewFromNib:nib];
    view.frame = CGRectMake(position.x, position.y, view.bounds.size.width, view.bounds.size.height);
    return view;
}

#pragma mark - Methods

+ (UINib *)nib  {
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+ (NSString *)viewIdentifier {
    return NSStringFromClass(self);
}

+ (NSString *)nibName  {
    return [self viewIdentifier];
}

+ (NSString *)className {
    return NSStringFromClass(self);
}

@end
