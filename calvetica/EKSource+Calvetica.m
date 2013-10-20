//
//  EKSource+Calvetica.m
//  calvetica
//
//  Created by Adam Kirk on 10/3/12.
//
//

#import "EKSource+Calvetica.h"

@implementation EKSource (Calvetica)

- (NSString *)localizedTitle
{
	return [self.title isEqualToString:@"Default"] ? @"Local" : self.title;
}


@end
