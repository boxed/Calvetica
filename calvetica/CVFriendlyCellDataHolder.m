//
//  CVFriendlyCellDataHolder.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVFriendlyCellDataHolder.h"




@implementation CVFriendlyCellDataHolder

- (id)init 
{
    self = [super init];
    if (self) {
        self.friendlyText = [CVFriendlyCellDataHolder randomPhrase];
    }
    return self;
}

+ (NSArray *)phrases {
    return @[FRIENDLY_TEXT_1, FRIENDLY_TEXT_2, FRIENDLY_TEXT_3, FRIENDLY_TEXT_4, FRIENDLY_TEXT_5, FRIENDLY_TEXT_6, FRIENDLY_TEXT_7, FRIENDLY_TEXT_8, FRIENDLY_TEXT_9, FRIENDLY_TEXT_10, FRIENDLY_TEXT_11, FRIENDLY_TEXT_12, FRIENDLY_TEXT_13, FRIENDLY_TEXT_14, FRIENDLY_TEXT_15, FRIENDLY_TEXT_16, FRIENDLY_TEXT_17, FRIENDLY_TEXT_18, FRIENDLY_TEXT_19];
}

+ (NSString *)randomPhrase {
    NSArray *phrases = [CVFriendlyCellDataHolder phrases];
    
    int randNumber = arc4random() % (phrases.count - 1);
    return [phrases objectAtIndex:randNumber];
}

@end
