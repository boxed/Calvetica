//
//  CVTapGestureRecognizer.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTapGestureRecognizer.h"



@interface CVTapGestureRecognizer ()
@property CGFloat valid;
@end




@implementation CVTapGestureRecognizer

- (id)init
{
    self = [super init];
    if (self) {
        _valid = NO;
        self.maximumTapDuration = DEFAULT_MAX_TAP_DURATION;
    }
    return self;
}

- (void)setMaximumTapDuration:(CGFloat)maxTapDuration
{
    _maximumTapDuration = maxTapDuration;
    if (self.tapTimer && [self.tapTimer isValid]) {
        [self.tapTimer invalidate];
    }
}

- (id)initWithTarget:(id)target action:(SEL)action 
{
    self = [super initWithTarget:target action:action];
    if (self) {
        _valid = NO;
        self.maximumTapDuration = DEFAULT_MAX_TAP_DURATION;
    }
    return self;
}

- (void)reset 
{
    _valid = NO;
    [self.tapTimer invalidate];
}

- (void)tapOccurred 
{
    if (_valid) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    _valid = YES;
    self.tapTimer = [NSTimer scheduledTimerWithTimeInterval:self.maximumTapDuration target:self selector:@selector(tapOccurred) userInfo:nil repeats:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self reset];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self reset];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self tapOccurred];
}

@end
