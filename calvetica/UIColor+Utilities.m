//
//  UIColor+Utilities.m
//  calvetica
//
//  Created by Adam Kirk on 6/1/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIColor+Utilities.h"

@implementation UIColor (UIColor_Utilities)

+ (void)componentsOfColor:(UIColor*)color red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha {
    // function by Matt Stoker matt.stoker@gmail.com
    
	int componentCount = CGColorGetNumberOfComponents([color CGColor]);
    if (componentCount < 2)
        return;
    
	const float* components = CGColorGetComponents([color CGColor]);
	if (red != NULL)
        *red = componentCount == 4 ? components[0] : components[0];
	if (green != NULL)
        *green = componentCount == 4 ? components[1] : components[0];
	if (blue != NULL)
        *blue = componentCount == 4 ? components[2] : components[0];
	if (alpha != NULL)
        *alpha = componentCount == 4 ? components[3] : components[1];
}

- (BOOL)shouldUseLightText 
{
    
    /*
     If you're only doing black or white text, use the color brightness calculation above. 
     If it is below 125, use white text. If it is 125 or above, use black text.
     
     edit 1: bias towards black text. :)
     
     edit 2: The formula to use is ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000
    */
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [UIColor componentsOfColor:self red:&red green:&green blue:&blue alpha:&alpha];
    red *= 255;
    green *= 255;
    blue *= 255;
    CGFloat brightness = ((red * 299.0) + (green * 587.0) + (blue * 114.0)) / 1000.0;
    return brightness < 125;
}

+ (NSArray *)calveticaPalette {
    return @[CV_PALETTE_1, 
            CV_PALETTE_2, 
            CV_PALETTE_3, 
            CV_PALETTE_4, 
            CV_PALETTE_5, 
            CV_PALETTE_6, 
            CV_PALETTE_7, 
            CV_PALETTE_8, 
            CV_PALETTE_9, 
            CV_PALETTE_10, 
            CV_PALETTE_11, 
            CV_PALETTE_12, 
            CV_PALETTE_13, 
            CV_PALETTE_14, 
            CV_PALETTE_15, 
            CV_PALETTE_16, 
            CV_PALETTE_17, 
            CV_PALETTE_18, 
            CV_PALETTE_19, 
            CV_PALETTE_20, 
            CV_PALETTE_21];
}

+ (UIColor *)randomCalveticaPaletteColor {
    NSArray *colors = [UIColor calveticaPalette];
    
    int index = arc4random() % 21;
    
    return [colors objectAtIndex:index];
}

- (UIColor *)closestColorInCalveticaPalette 
{
    return [self closestColorInPalette:[UIColor calveticaPalette]];
}

- (UIColor *)closestColorInPalette:(NSArray *)palette 
{
    float bestDifference = MAXFLOAT;
    UIColor *bestColor = nil;
    
    float *lab1 = [self colorToLab];
    float C1 = sqrtf(lab1[1] * lab1[1] + lab1[2] * lab1[2]);
    
    for (UIColor *color in palette) {
        float *lab2 = [color colorToLab];
        float C2 = sqrtf(lab2[1] * lab2[1] + lab2[2] * lab2[2]);
        
        float deltaL = lab1[0] - lab2[0];
        float deltaC = C1 - C2;
        float deltaA = lab1[1] - lab2[1];
        float deltaB = lab1[2] - lab2[2];
        float deltaH = sqrtf(deltaA * deltaA + deltaB * deltaB - deltaC * deltaC);
        
        float deltaE = sqrtf(powf(deltaL / K_L, 2) + powf(deltaC / (1 + K_1 * C1), 2) + powf(deltaH / (1 + K_2 * C1), 2));
        if (deltaE < bestDifference) {
            bestColor = color;
            bestDifference = deltaE;
        }
        
        free(lab2);
    }
    
    free(lab1);
    return bestColor;
}

- (float *)colorToLab 
{
    // Don't allow grayscale colors.
    if (CGColorGetNumberOfComponents(self.CGColor) != 4) {
        return nil;
    }
    
    float *rgb = (float *)malloc(3 * sizeof(float));
    const float *components = CGColorGetComponents(self.CGColor);
    
    rgb[0] = components[0];
    rgb[1] = components[1];
    rgb[2] = components[2];
    
    float *lab = [UIColor rgbToLab:rgb];
    free(rgb);
    
    return lab;
}

+ (float *)rgbToLab:(float *)rgb {
    float *xyz = [UIColor rgbToXYZ:rgb];
    float *lab = [UIColor xyzToLab:xyz];
    
    free(xyz);
    return lab;
}

+ (float *)rgbToXYZ:(float *)rgb {
    float *newRGB = (float *)malloc(3 * sizeof(float));
    
    for (int i = 0; i < 3; i++) {
        float component = rgb[i];
        
        if (component > 0.04045f) {
            component = powf((component + 0.055f) / 1.055f, 2.4f);
        } else {
            component = component / 12.92f;
        }
        
        newRGB[i] = component;
    }
    
    newRGB[0] = newRGB[0] * 100.0f;
    newRGB[1] = newRGB[1] * 100.0f;
    newRGB[2] = newRGB[2] * 100.0f;
    
    float *xyz = (float *)malloc(3 * sizeof(float));
    xyz[0] = (newRGB[0] * 0.4124f) + (newRGB[1] * 0.3576f) + (newRGB[2] * 0.1805f);
    xyz[1] = (newRGB[0] * 0.2126f) + (newRGB[1] * 0.7152f) + (newRGB[2] * 0.0722f);
    xyz[2] = (newRGB[0] * 0.0193f) + (newRGB[1] * 0.1192f) + (newRGB[2] * 0.9505f);
    
    free(newRGB);
    return xyz;
}

+ (float *)xyzToLab:(float *)xyz {
    float *newXYZ = (float *)malloc(3 * sizeof(float));
    newXYZ[0] = xyz[0] / X_REF;
    newXYZ[1] = xyz[1] / Y_REF;
    newXYZ[2] = xyz[2] / Z_REF;
    
    for (int i = 0; i < 3; i++) {
        float component = newXYZ[i];
        
        if (component > 0.008856) {
            component = powf(component, 0.333f);
        } else {
            component = (7.787 * component) + (16 / 116);
        }
        
        newXYZ[i] = component;
    }
    
    float *lab = (float *)malloc(3 * sizeof(float));
    lab[0] = (116 * newXYZ[1]) - 16;
    lab[1] = 500 * (newXYZ[0] - newXYZ[1]);
    lab[2] = 200 * (newXYZ[1] - newXYZ[2]);
    
    free(newXYZ);
    return lab;
}



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
