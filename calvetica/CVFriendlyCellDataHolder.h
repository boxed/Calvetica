//
//  CVFriendlyCellDataHolder.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "strings.h"
#import "CVDataHolder.h"

@interface CVFriendlyCellDataHolder : CVDataHolder

@property (nonatomic, strong) NSString *friendlyText;
+ (NSArray *)phrases;
+ (NSString *)randomPhrase;

@end