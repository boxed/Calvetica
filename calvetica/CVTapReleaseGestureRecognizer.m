//
//  CVTapReleaseGestureRecognizer.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVTapReleaseGestureRecognizer.h"




@implementation CVTapReleaseGestureRecognizer




#pragma mark - Properties




#pragma mark - Constructor

- (id)init 
{
    self = [super init];
    if (self) {
        validGesture = NO;
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action 
{
    self = [super initWithTarget:target action:action];
    if (self) {
        validGesture = NO;
    }
    return self;
}




#pragma mark - Memory Management





#pragma mark - Methods

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer 
{
    if ([preventingGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [preventingGestureRecognizer isKindOfClass:[CVTapGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer 
{
    return NO;
}

- (void)reset 
{
    validGesture = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    validGesture = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self reset];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (validGesture) {
        self.state = UIGestureRecognizerStateEnded;
    }
}




@end
