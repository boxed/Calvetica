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
    id<CVTextViewDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, unsafe_unretained) id<CVTextViewDelegate> delegate;

@end

