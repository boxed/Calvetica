//
//  NSString+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "NSString+Utilities.h"


@implementation NSString (NSString_Utilities)

+ (NSString *)stringWithUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
	NSString *s = [NSString stringWithString:(__bridge NSString *)uuidString];
	CFRelease(uuidString);
	CFRelease(uuid);
	
	return s;
}

- (NSInteger)linesOfWordWrapTextWithFont:(UIFont *)font constraintWidth:(CGFloat)width 
{
    CGSize size = [self sizeWithFont:font];
    return ceil(size.width / width);
}

- (CGFloat)totalHeightOfWordWrapTextWithFont:(UIFont *)font constraintWidth:(CGFloat)width 
{
    CGSize size = [self sizeWithFont:font];
    NSInteger lines = ceil(size.width / width);
    
    return (size.height * lines);
}

@end
