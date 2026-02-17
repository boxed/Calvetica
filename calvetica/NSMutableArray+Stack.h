//
//  NSMutableArray+Stack.h
//  calvetica
//
//  Created by Adam Kirk on 10/25/13.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface NSMutableArray (Stack)
- (void)push:(id)obj;
- (id)pop;
- (id)shift;
- (void)unshift:(id)obj;
@end

NS_ASSUME_NONNULL_END
