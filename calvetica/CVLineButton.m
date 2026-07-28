//
//  CVLineButton.m
//  calvetica
//
//  Created by Adam Kirk on 9/24/13.
//
//

#import "CVLineButton.h"
#import "colors.h"


@interface CVLineButton ()
@property (nonatomic, assign) BOOL isDoneDrawing;
@property (nonatomic, strong) UIColor *glyphColor;
@end


@implementation CVLineButton

- (void)commonInit
{
    _pencil = [MTPencil pencilWithView:self];
    _pencil.drawsAsynchronously = YES;
    _isDoneDrawing = NO;
    _glyphColor = [UIColor whiteColor];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Glyph buttons that baked in the old "patented red" background (e.g. the
    // quick-add ok/cancel/more/backspace keys) should follow the theme color,
    // with a legible glyph drawn on top.
    if (calColorIsLegacyPatentedRed(self.backgroundColor)) {
        CGFloat r, g, b, a;
        [self.backgroundColor getRed:&r green:&g blue:&b alpha:&a];
        UIColor *bg = (r < 0.72f) ? calThemeColorDark() : calThemeColor();
        self.backgroundColor = bg;
        self.glyphColor = calLegibleForegroundForColor(bg);
        [self setTitleColor:self.glyphColor forState:UIControlStateNormal];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
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
    // Under Reduce Motion, skip the animated "drawing" of the glyph and render
    // it immediately (drawRect: strokes the full pencil path once isDoneDrawing).
    if (UIAccessibilityIsReduceMotionEnabled()) {
        self.isDoneDrawing = YES;
        [self setNeedsDisplay];
        if (completion) completion();
        return;
    }

    [_pencil drawWithCompletion:^(MTPencil *pencil) {
        if (completion) completion();
        [self->_pencil erase];
        self.isDoneDrawing = YES;
        [self setNeedsDisplay];
    }];
}

- (void)setupPencil
{
    [[[[_pencil config] strokeColor:self.glyphColor ?: [UIColor whiteColor]] width:1] easingFunction:kMTPencilEaseOutSine];
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
