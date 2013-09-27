//
//  CVLineButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/13.
//
//

#import "CVLineButton.h"

@implementation CVLineButton

- (void)commonInit
{
    _pencil = [MTPencil pencilWithView:self];
    _pencil.drawsAsynchronously = YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if ([_pencil.steps count] == 0) {
        [self setupPencil];
        [self redrawWithCompletion:nil];
    }
}

- (void)redrawWithCompletion:(void (^)(void))completion
{
    [_pencil erase];
    [_pencil beginWithCompletion:^(MTPencil *pencil) {
        if (completion) completion();
        [_pencil erase];
        [self setNeedsDisplay];
    }];
}

- (void)setupPencil
{

}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_pencil.isDrawing || _pencil.isErasing) {
        return;
    }

    [[self titleColorForState:self.state] set];
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:[_pencil fullPath]];
    MTPencilStep *step = [_pencil.steps lastObject];
    path.lineWidth = step.lineWidth;
    [path stroke];
}

@end
