//
//  CVTextView.h
//  calvetica
//
//  Created by Adam Kirk on 5/6/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CVTextView;

@protocol CVTextViewDelegate <NSObject, UITextViewDelegate>
@optional
- (void)textViewWasTappedWhenUneditable:(CVTextView *)textView;
@end

@interface CVTextView : UITextView {
    id<CVTextViewDelegate> __weak delegate;
}

@property (nonatomic, weak) id<CVTextViewDelegate> delegate;

@end

