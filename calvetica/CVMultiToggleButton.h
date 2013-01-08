//
//  MultiToggleButton_iPhone.h
//  calvetica
//
//  Created by Quenton Jones on 6/2/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//
//  CVMultiToggleButton makes the assumption that it has a single subview of type UILabel.
//

#import "CVViewButton.h"


@interface CVMultiToggleButton : CVViewButton

@property (nonatomic, assign) NSInteger currentState;
@property (nonatomic, strong) NSArray *states;

// Returns the button's currently displayed state.
- (NSString *)currentStateAsString;

// Displays the next state. The new state number is returned.
- (NSInteger)nextState;

@end
