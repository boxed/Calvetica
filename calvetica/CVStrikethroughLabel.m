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
@property (nonatomic, strong) MTPencil *pencil;
@end


@implementation CVStrikethroughLabel

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

- (void)toggleStrikeThroughWithCompletion:(void (^)())completion
{
    if (self.isDrawing) {
        return;
    }

    self.isDrawing = YES;

    if ([self.text length] > 0) {

        CGSize size = [self.attributedText size];
        [_pencil reset];
        [[[[_pencil config] strokeColor:[UIColor blackColor]] duration:0.25] width:1];
        [[_pencil move] to:CGPointMake(0, CGRectGetMidY(self.bounds) + 1.5)];
        [[_pencil draw] to:CGPointMake(size.width, CGRectGetMidY(self.bounds) + 1.5)];

        NSAttributedString *attributedString    = self.attributedText;
        NSMutableDictionary *attributes         = [[attributedString attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
        BOOL striked = [attributes[NSStrikethroughStyleAttributeName] boolValue];
        if (!striked) {
            [[_pencil config] easingFunction:kMTEaseOutExpo];
            [_pencil drawWithCompletion:^(MTPencil *pencil) {
                [_pencil reset];
                attributes[NSStrikethroughStyleAttributeName] = @(YES);
                self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
                self.isDrawing = NO;
                if (completion) completion();
            }];
        }
        else {
            [attributes removeObjectForKey:NSStrikethroughStyleAttributeName];
            self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
            [[_pencil config] easingFunction:kMTEaseInExpo];
//            [_pencil finish];
            [_pencil eraseWithCompletion:^(MTPencil *pencil) {
                [_pencil reset];
                self.isDrawing = NO;
                if (completion) completion();
            }];
        }
    }
}

@end
