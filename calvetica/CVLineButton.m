//
//  CVLineButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/13.
//
//

#import "CVLineButton.h"


@interface CVLineButton ()
@property (nonatomic, assign) BOOL isDoneDrawing;
@end


@implementation CVLineButton

- (void)commonInit
{
    _pencil = [MTPencil pencilWithView:self];
    _pencil.drawsAsynchronously = YES;
    _isDoneDrawing = NO;
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
        UITableViewDelegate
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
    [_pencil drawWithCompletion:^(MTPencil *pencil) {
        if (completion) completion();
        [_pencil erase];
        self.isDoneDrawing = YES;
        [self setNeedsDisplay];
    }];
}

- (void)setupPencil
{
    [[[[_pencil config] strokeColor:[UIColor whiteColor]] width:1] easingFunction:kMTPencilEaseOutSine];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!self.isDoneDrawing) {
        return;
    }

    [[self titleColorForState:self.state] set];
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:[_pencil CGPath]];
    MTPencilStep *step = [_pencil.steps lastObject];
    path.lineWidth = step.lineWidth;
    [path stroke];
}

@end
