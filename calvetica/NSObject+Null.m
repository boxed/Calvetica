//
//  NSObject+Null.m
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import "NSObject+Null.h"

@implementation NSObject (Null)

- (BOOL)isNull
{
    return [self isKindOfClass:[NSNull class]];
}

@end
