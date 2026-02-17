//
//  CVParticipantCellDataHolder.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVParticipantCellModel.h"



@implementation CVParticipantCellModel

- (instancetype)init 
{
    self = [super init];
    if (self) {
        _participant = nil;
        _email = nil;
        _telephoneNumbers = nil;
        _contactIdentifier = nil;
    }
    return self;
}

@end
