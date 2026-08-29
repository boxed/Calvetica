//
//  CVStrikethroughLabel.m
//  calvetica
//
//  Created by Adam Kirk on 10/19/13.
//
//

#import "CVStrikethroughLabel.h"


@interface CVStrikethroughLabel ()
@property (nonatomic, assign) BOOL     isDrawing;
@property (nonatomic, assign) BOOL     isApplyingStrikeThrough;
@property (nonatomic, strong) MTPencil *pencil;
- (void)applyAttributedText:(NSAttributedString *)attributedText;
@end


@implementation CVStrikethroughLabel

- (void)commonInit
{
    _pencil = [MTPencil pencilWithView:self];
    _pencil.drawsAsynchronously = YES;
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


#pragma mark - Text

// The label lives in a reused cell, so the text can be swapped out from under an
// animation at any time. Any new text means the pencil's line (and the "drawing"
// state that goes with it) belongs to an item that isn't in this label anymore.

- (void)setText:(NSString *)text
{
    if (!self.isApplyingStrikeThrough) {
        [self cancelStrikeThroughAnimation];
    }
    [super setText:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if (!self.isApplyingStrikeThrough) {
        [self cancelStrikeThroughAnimation];
    }
    [super setAttributedText:attributedText];
}


#pragma mark - Strikethrough

- (void)cancelStrikeThroughAnimation
{
    [_pencil reset];
    self.isDrawing = NO;
}

- (void)toggleStrikeThroughForText:(NSString *)expectedText completion:(void (^)(void))completion
{
    if (self.isDrawing) {
        // A reload still has to happen, or the row keeps showing the old state.
        if (completion) completion();
        return;
    }

    NSString *text = self.text;

    // Nothing to strike, or this label has moved on to a different calendar item.
    if ([text length] == 0 || (expectedText && ![text isEqualToString:expectedText])) {
        if (completion) completion();
        return;
    }

    self.isDrawing = YES;

    CGSize size = [self.attributedText size];
    [_pencil reset];
    [[[[_pencil config] strokeColor:self.textColor] duration:0.25] width:1];
    [[_pencil move] to:CGPointMake(0, CGRectGetMidY(self.bounds) + 1.5)];
    [[_pencil draw] to:CGPointMake(size.width, CGRectGetMidY(self.bounds) + 1.5)];

    NSAttributedString *attributedString    = self.attributedText;
    NSMutableDictionary *attributes         = [[attributedString attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
    BOOL striked = [attributes[NSStrikethroughStyleAttributeName] boolValue];
    if (!striked) {
        [[_pencil config] easingFunction:kMTEaseOutExpo];
        [_pencil drawWithCompletion:^(MTPencil *pencil) {
            [self->_pencil reset];
            self.isDrawing = NO;

            // The cell may have been reconfigured while the line was being drawn.
            // Striking through whatever text landed here in the meantime is how
            // unrelated events ended up with a line through them.
            if ([self.text isEqualToString:text]) {
                attributes[NSStrikethroughStyleAttributeName] = @(YES);
                [self applyAttributedText:[[NSAttributedString alloc] initWithString:text attributes:attributes]];
            }

            if (completion) completion();
        }];
    }
    else {
        [attributes removeObjectForKey:NSStrikethroughStyleAttributeName];
        [self applyAttributedText:[[NSAttributedString alloc] initWithString:text attributes:attributes]];
        [[_pencil config] easingFunction:kMTEaseInExpo];
        [_pencil eraseWithCompletion:^(MTPencil *pencil) {
            [self->_pencil reset];
            self.isDrawing = NO;
            if (completion) completion();
        }];
    }
}

// Sets text the label itself owns, without treating it as a new calendar item.
- (void)applyAttributedText:(NSAttributedString *)attributedText
{
    self.isApplyingStrikeThrough = YES;
    self.attributedText = attributedText;
    self.isApplyingStrikeThrough = NO;
}

@end
