//
//  UIColor+Serialization.m
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import "UIColor+Serialization.h"

@implementation UIColor (Serialization)

- (NSData *)archivedColor
{
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (UIColor *)colorUnarchivedFromData:(NSData *)data {
	return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSString *)colorToString
{
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	return [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
}

+ (UIColor *)colorFromString:(NSString *)string {
	NSArray *components = [string componentsSeparatedByString:@","];
	CGFloat r = [[components objectAtIndex:0] floatValue];
	CGFloat g = [[components objectAtIndex:1] floatValue];
	CGFloat b = [[components objectAtIndex:2] floatValue];
	CGFloat a = [[components objectAtIndex:3] floatValue];
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
