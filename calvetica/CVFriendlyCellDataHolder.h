//
//  CVFriendlyCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "strings.h"
#import "CVDataHolder.h"

@interface CVFriendlyCellDataHolder : CVDataHolder

@property (nonatomic, copy) NSString *friendlyText;
+ (NSArray *)phrases;
+ (NSString *)randomPhrase;

@end