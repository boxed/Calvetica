//
//  UIColor+Serialization.h
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIColor (Serialization)

- (NSData *)archivedColor;

+ (UIColor *)colorUnarchivedFromData:(NSData *)data;

- (NSString *)stringValue;

+ (UIColor *)colorFromString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
