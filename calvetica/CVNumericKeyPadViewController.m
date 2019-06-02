//
//  CVNumericKeyPad_iPhone.m
//  calvetica
//
//  Created by Quenton Jones on 5/18/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVNumericKeyPadViewController.h"
#import "geometry.h"


@interface CVNumericKeyPadViewController()
@property (nonatomic, strong  ) NSMutableArray *number;
@property (nonatomic, assign) BOOL           append;
@end




@implementation CVNumericKeyPadViewController

- (id)init 
{
    self = [super init];
    if (self) {
        self.maxValue = NSIntegerMax;
        self.number = [NSMutableArray array];
    }
    return self;
}

- (id)initWithTargetView:(UIView *)view 
{
    self = [self init];
    if (self) {
        self.targetView = view;
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Methods

- (int)numberAsInteger 
{
    return [[self numberAsString] intValue];
}

- (NSString *)numberAsString 
{
    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSNumber *num in self.number) {
        [string appendString:[NSString stringWithFormat:@"%i", [num intValue]]];
    }
    
    return string;
}

- (void)setKeyPadValue:(int)value 
{
    NSString *num = [NSString stringWithFormat:@"%i", value];
    for (int i = 0; i < [num length]; i++) {
        [self.number addObject:[NSString stringWithFormat:@"%c", [num characterAtIndex:i]]];
    }
    
    [self updateKeypadValue];
}

- (void)updateKeypadValue 
{
    NSString *newValue = [self numberAsString];
    if (self.keypadValue) {
        self.keypadValue.text = newValue;
    }
    [self.delegate keyPad:self didUpdateNumber:newValue];
}

#pragma mark IBActions

- (void)closeButtonTapped 
{
    [self.delegate keyPadWillClose:self];
}

- (void)backgroundTapped 
{
    [self.delegate keyPadWillClose:self];
}

- (void)buttonTapped:(CVViewButton *)button 
{
    if (!_append) {
        [self.number removeAllObjects];
    }
    
    if (button.tag == 0 && self.number.count == 0) {
        return;
    }
	
    _append = YES;
    [self.number addObject:@(button.tag)];
    
    [self updateKeypadValue];
}

- (void)clearButtonTapped; 
{
    [self.number removeAllObjects];
    _append = NO;
    [self.number addObject:@(self.minValue)];
    
    [self updateKeypadValue];
}

#pragma mark UIView

- (void)viewDidLoad 
{
    self.keypadValue.text = [self numberAsString];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated 
{
    CGRect keyPadFrame = self.keypadView.frame;

    // @hack: hacked way of displaying keypad until we find a better way
    
    // places keypad over button in top left in all repeat viewControllers
    if (self.targetView.frame.origin.x == 53) {
        keyPadFrame.origin.x = self.targetView.frame.origin.x;
        keyPadFrame.origin.y = self.targetView.frame.origin.y;
    }
    // places keypad over button in "Ends" in all repeat viewControllers except Yearly
    else if (self.targetView.superview.frame.origin.x == 139) {
        keyPadFrame.origin.x = self.targetView.superview.frame.origin.x;
        keyPadFrame.origin.y = self.targetView.superview.frame.origin.y;
    }
    // places keypad over button in "Ends" in Yearly ViewController
    else if (self.targetView.superview.frame.origin.x == 129) {
        keyPadFrame.origin.x = self.targetView.superview.frame.origin.x + self.targetView.superview.superview.frame.origin.x;
        keyPadFrame.origin.y = self.targetView.superview.superview.frame.origin.y;
    }
    // if all else fails place it in top left
    else {
        keyPadFrame.origin.x = 0;
        keyPadFrame.origin.y = 0;
    }
    self.keypadView.frame = keyPadFrame;
    
    [super viewWillAppear:animated];
}

@end
