//
//  CVFriendlyCell.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCell.h"

#define FRIENDLY_CELL_HEIGHT 60.0f;


@interface CVFriendlyCell : CVCell

- (void)setRandomPhrase;
@property (nonatomic, strong) IBOutlet CVLabel *friendlyPhraseLabel;

@end
