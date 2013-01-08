//
//  MultiToggleButton_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 6/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVMultiToggleButton.h"


@implementation CVMultiToggleButton

- (void)setup 
{
    [super setup];
    self.selectable = YES;
}

- (void)setCurrentState:(NSInteger)curState 
{
    if (curState < [self.states count]) {
        _currentState = curState;
    }
    
    self.titleLabel.text = [self.states objectAtIndex:_currentState];
}

#pragma mark - Methods

- (NSString *)currentStateAsString 
{
    return [_states objectAtIndex:_currentState];
}

- (NSInteger)nextState 
{
    self.currentState = _currentState + 1 >= [_states count] ? 0 : _currentState + 1;
    return _currentState;
}

@end
