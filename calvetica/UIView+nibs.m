//
//  UIView+nibs.m
//  calvetica
//
//  Created by Adam Kirk on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Nibs.h"


@implementation UIView (Nibs)

#pragma mark - Convenience Constructors

+ (NSCache *)sharedNibCache
{
    static NSCache *UINibCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UINibCache = [NSCache new];
    });
    return UINibCache;
}



#pragma mark - Public

+ (instancetype)fromNibOfSameName
{
    NSCache *nibCache       = [self sharedNibCache];
    NSString *nibFileName   = [self nibFileName];
    UINib *nib              = [nibCache objectForKey:nibFileName];

    if (!nib) {
        nib = [self nib];
        [nibCache setObject:nib forKey:nibFileName];
    }

    return [self viewFromNib:nib];
}




#pragma mark - Private

+ (id)viewFromNib:(UINib *)nib
{
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    NSAssert2([[nibObjects lastObject] isKindOfClass:[self class]],
              @"Nib '%@' does not appear to contain a valid %@",
              [self nibFileName],
              NSStringFromClass([self class]));
    return [nibObjects lastObject];
}

+ (UINib *)nib
{
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    return [UINib nibWithNibName:[self nibFileName] bundle:classBundle];
}

+ (NSString *)nibFileName
{
    return NSStringFromClass(self);
}

@end
