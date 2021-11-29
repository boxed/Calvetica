//
//  UIImage+Clear.m
//  calvetica
//
//  Created by Adam Kirk on 10/18/13.
//
//

#import "UIImage+Clear.h"

@implementation UIImage (Clear)

+ (UIImage *)clearImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [patentedClear CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blankImage;
}

@end
