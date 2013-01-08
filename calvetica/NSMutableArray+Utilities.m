//
//  NSMutableArray+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSMutableArray+Utilities.h"

@implementation NSMutableArray (Utilities)

- (void)push:(id)object 
{
	[self addObject:object];	
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
	id obj = [self firstObject];
	if (obj) {
		[self removeObjectAtIndex:0];
	}
	return obj;
}

@end
