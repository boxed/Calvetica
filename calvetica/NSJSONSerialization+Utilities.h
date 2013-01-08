//
//  NSJSONSerialization+Utilities.h
//  calvetica
//
//  Created by Adam Kirk on 12/14/11.
//  Copyright (c) 2011 Mysterious Trousers. All rights reserved.
//

@interface NSJSONSerialization (Utilities)

+ (NSString *)serialize:(id)obj;
+ (id)unserializeData:(NSData *)JSONData;
+ (id)unserializeString:(NSString *)JSONString;

@end
