//
//  MYSStack.m
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//

#import "MYSStack.h"


@interface MYSStack ()
@property (nonatomic, strong) NSMutableArray *stack;
@end


@implementation MYSStack

- (id)init
{
    self = [super init];
    if (self) {
        _stack = [NSMutableArray new];
    }
    return self;
}

- (void)push:(id)obj
{
    [self.stack addObject:obj];
}

- (id)pop
{
    id obj = [self.stack lastObject];
    if (obj) {
        [self.stack removeLastObject];
    }
    return obj;
}

- (id)shift
{
    if ([self.stack count] > 0) {
        id obj = self.stack[0];
        [self.stack removeObjectAtIndex:0];
        return obj;
    }
    return nil;
}

- (void)unshift:(id)obj
{
    [self.stack insertObject:obj atIndex:0];
}

- (id)firstObject
{
    if ([self.stack count] > 0) {
        return self.stack[0];
    }
    return nil;
}

- (id)lastObject
{
    return [self.stack lastObject];
}

@end
