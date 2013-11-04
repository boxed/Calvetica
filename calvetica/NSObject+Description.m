//
//  NSObject+Description.m
//  calvetica
//
//  Created by Adam Kirk on 11/1/13.
//
//

#ifdef DEBUG

//#import "NSObject+Description.h"
//#import <objc/runtime.h>
//
//
//@implementation NSObject (Description)
//
//+ (void)load
//{
//    Method original = class_getInstanceMethod(self, @selector(description));
//    Method swizzled = class_getInstanceMethod(self, @selector(mys_description));
//    method_exchangeImplementations(original, swizzled);
//}
//
//- (NSString *)mys_description
//{
//    NSString *d = [NSString stringWithFormat:@"%@\n{\n", [self mys_description]];
//
//    unsigned int numberOfProperties = 0;
//    NSUInteger longestNameLength = 0;
//    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
//
//    // First pass: determine the longest name so we can vertically align names and values.
//    for (NSUInteger i = 0; i < numberOfProperties; i++) {
//        objc_property_t property = propertyArray[i];
//        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
//        if (name.length > longestNameLength) {
//            longestNameLength = name.length;
//        }
//    }
//    // Second pass: construct the string
//    for (NSUInteger i = 0; i < numberOfProperties; i++) {
//        objc_property_t property = propertyArray[i];
//        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
//        NSString *paddedName = [name stringByPaddingToLength:longestNameLength withString:@" " startingAtIndex:0];
//
//        id value = [self valueForKey:name];
//        NSString *valueDescrip = nil;
//
//        // If the class supports it, specify the indent level
//        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
//            valueDescrip = [value descriptionWithLocale:[NSLocale currentLocale] indent:1];
//            valueDescrip = [@"\n" stringByAppendingString:valueDescrip];
//        } else {
//            valueDescrip = [value description];
//        }
//
//        // Limit the output of data objects
//        static NSUInteger maxLength = 100;
//        if ([value isKindOfClass:[NSData class]] && valueDescrip.length > maxLength) {
//            // Append the byte count
//            NSString *byteCount = [DOByteCountFormatter stringFromByteCount:[value length]
//                                                                 countStyle:DOByteCountFormatterCountStyleMemory];
//            valueDescrip = [NSString stringWithFormat:@"%@... (%@)",
//                            [valueDescrip substringToIndex:(maxLength - 1)], byteCount];
//        }
//
//        d = [d stringByAppendingFormat:@"\t%@ : %@\n", paddedName, valueDescrip];
//    }
//    free(propertyArray);
//
//    d = [d stringByAppendingString:@"}"];
//
//    return d;
//}
//
//@end
//
//
//
//
//static const char sUnits[] = { '\0', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y' };
//static int sMaxUnits = sizeof sUnits - 1;
//
//@implementation DOByteCountFormatter
//
//+(NSString *)stringFromByteCount:(long long)byteCount countStyle:(DOByteCountFormatterCountStyle)countStyle
//{
//    if ([NSByteCountFormatter class] != nil) {
//        return [NSByteCountFormatter stringFromByteCount:byteCount countStyle:(NSByteCountFormatterCountStyle)countStyle];
//    } else {
//        DOByteCountFormatter *formatter = [[DOByteCountFormatter alloc] init];
//        formatter.countStyle = countStyle;
//        return [formatter stringFromByteCount:byteCount];
//    }
//}
//
//-(BOOL)useDecimalStyle
//{
//    return self.countStyle == DOByteCountFormatterCountStyleDecimal ||
//    self.countStyle == DOByteCountFormatterCountStyleBinary;
//}
//
//-(NSString *)stringForObjectValue:(id)obj
//{
//    if (![obj isKindOfClass:[NSNumber class]])
//        return nil;
//
//    if ([NSByteCountFormatter class] != nil) {
//        return [NSByteCountFormatter stringFromByteCount:[obj longLongValue] countStyle:(NSByteCountFormatterCountStyle)[self countStyle]];
//    } else {
//        NSUInteger decimals = 0;
//        NSUInteger multiplier = [self useDecimalStyle] ? 1000 : 1024;
//        NSUInteger exponent = 0;
//
//        double convertedSize = [obj doubleValue];
//
//        while ((convertedSize >= multiplier) && (exponent < sMaxUnits)) {
//            convertedSize /= multiplier;
//            exponent++;
//        }
//
//        if (exponent == 1) {        // KB
//            if (convertedSize >= 10)
//                decimals = 0;
//            else
//                decimals = 1;
//        } else if (exponent == 2) { // MB
//            decimals = 1;
//        } else {                    // Everything else
//            decimals = 2;
//        }
//
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
//        [formatter setMinimumFractionDigits:0];
//        [formatter setMaximumFractionDigits:decimals];
//
//        NSString *bytesString = [NSString stringWithFormat:@"%@ %cB", [formatter stringFromNumber:[NSNumber numberWithDouble:convertedSize]], sUnits[exponent]];
//
//
//        return bytesString;
//    }
//}
//
//-(NSString *)stringFromByteCount:(long long)byteCount
//{
//    return [self stringForObjectValue:[NSNumber numberWithLongLong:byteCount]];
//}
//
//@end

#endif