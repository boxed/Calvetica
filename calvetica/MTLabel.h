//
//  MTLabel.h
//  dialvetica
//
//  Created by Adam Kirk on 11/3/10.
//  Copyright 2010 Wesley Taylor Design, LLC. All rights reserved.
//

@interface MTLabel : UILabel
- (void)reset;
- (void)initCharacterColors;
- (void)changeColor:(UIColor *)color ofCharacterAtIndex:(int)index;
- (void)changeColor:(UIColor *)color ofCharacter:(NSString *)ch;
- (void)changeColor:(UIColor *)color ofSubstring:(NSString *)ss;
@end
