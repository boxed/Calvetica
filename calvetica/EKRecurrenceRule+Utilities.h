//
//  EKRecurrenceRule+Utilities.h
//  calvetica
//
//  Created by Quenton Jones on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "strings.h"

NS_ASSUME_NONNULL_BEGIN



@interface EKRecurrenceRule (Utilities)

#pragma mark - Methods

+ (void)appendNewLine:(NSMutableString *)string;
- (BOOL)isValidCalveticaRule;
- (EKRecurrenceRule *)validCalveticaRule;
- (NSString *)naturalDescription;
- (NSString *)recurrenceEndNaturalDescription;

@end

NS_ASSUME_NONNULL_END
