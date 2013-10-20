//
//  CVParticipantCellDataHolder.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVParticipantCellModel.h"



@implementation CVParticipantCellModel

- (id)init 
{
    self = [super init];
    if (self) {
        _participant = nil;
        _email = nil;
        _telephoneNumbers = nil;
        _recordID = nil;
    }
    return self;
}

@end
