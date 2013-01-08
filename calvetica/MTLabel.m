//
//  MTLabel.m
//  dialvetica
//
//  Created by Adam Kirk on 11/3/10.
//  Copyright 2010 Wesley Taylor Design, LLC. All rights reserved.
//

#import "MTLabel.h"


@implementation MTLabel


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        characterColors = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)awakeFromNib 
{
    characterColors = [[NSMutableArray alloc] initWithCapacity:0];
}


- (void)reset 
{
	characterColors = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initCharacterColors 
{
	if (characterColors.count < self.text.length) {
		for (int i = characterColors.count; i < self.text.length; i++)
		{
			[characterColors addObject:self.textColor];
		}
	}
}

- (void)changeColor:(UIColor *)color ofCharacterAtIndex:(int)idx 
{
	[self initCharacterColors];
	[characterColors replaceObjectAtIndex:idx withObject:color];
}

- (void)changeColor:(UIColor *)color ofCharacter:(NSString *)ch 
{
	[self initCharacterColors];
	for (int i = 0; i < self.text.length; i++)
	{
		NSString *c = [self.text substringWithRange:NSMakeRange(i, 1)];
		c = [c lowercaseString];
		ch = [ch lowercaseString];
		if ([ch compare:c options:(NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch)] == NSOrderedSame) {
			[characterColors replaceObjectAtIndex:i withObject:color];
		}
	}
}

- (void)changeColor:(UIColor *)color ofSubstring:(NSString *)ss 
{
	[self initCharacterColors];
	NSRange r = [self.text rangeOfString:ss options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)];
	if (r.location != NSNotFound) {
		for (int i = r.location; i < (r.location + r.length) ; i++) {
			[self changeColor:color ofCharacterAtIndex:i];
		}
	}
}

- (void)drawRect:(CGRect)rect 
{
	if ([self.text canBeConvertedToEncoding:NSMacOSRomanStringEncoding]) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSelectFont(context, [self.font.familyName UTF8String], self.font.pointSize, kCGEncodingMacRoman);
		CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
		CGContextSetTextPosition(context, 0, self.frame.size.height / 1.65f);
		CGContextSetTextDrawingMode(context, kCGTextFill);
		
		for (int i = 0; i < self.text.length; i++)
		{
			CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
			
			if (characterColors.count > i && [characterColors objectAtIndex:i]) {
				CGContextSetFillColorWithColor(context, [[characterColors objectAtIndex:i]  CGColor]);
				
			} else {
				CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
				
			}
			
			NSRange range;
			range.location = i;
			range.length = 1;
			NSString *c = [self.text substringWithRange:range];
			CGContextShowText(context, [c cStringUsingEncoding:NSMacOSRomanStringEncoding], 1);
		}
	} else {
		[super drawRect:rect];
	}
}




@end
