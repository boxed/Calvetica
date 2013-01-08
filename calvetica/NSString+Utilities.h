//
//  NSString+Utilities.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

@interface NSString (NSString_Utilities)

+ (NSString *)stringWithUUID;
- (NSInteger)linesOfWordWrapTextWithFont:(UIFont *)font constraintWidth:(CGFloat)width;
- (CGFloat)totalHeightOfWordWrapTextWithFont:(UIFont *)font constraintWidth:(CGFloat)width;

@end
