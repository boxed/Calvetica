//
//  MYSStack.h
//  calvetica
//
//  Created by Adam Kirk on 10/17/13.
//
//


@interface MYSStack : NSObject
- (void)push:(id)obj;
- (id)pop;
- (id)shift;
- (void)unshift:(id)obj;
- (id)firstObject;
- (id)lastObject;
@end
