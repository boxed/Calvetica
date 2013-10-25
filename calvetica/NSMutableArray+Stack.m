//
//  NSMutableArray+Stack.m
//  calvetica
//
//  Created by Adam Kirk on 10/25/13.
//
//

#import "NSMutableArray+Stack.h"


@implementation NSMutableArray (Stack)

- (void)push:(id)obj
{
    [self addObject:obj];
}

- (id)pop
{
    id obj = [self lastObject];
    if (obj) {
        [self removeLastObject];
    }
    return obj;
}

- (id)shift
{
    if ([self count] > 0) {
        id obj = self[0];
        [self removeObjectAtIndex:0];
        return obj;
    }
    return nil;
}

- (void)unshift:(id)obj
{
    [self insertObject:obj atIndex:0];
}

@end
