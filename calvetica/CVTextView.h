//
//  CVTextView.h
//  calvetica
//
//  Created by Adam Kirk on 5/6/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN


@class CVTextView;

@protocol CVTextViewDelegate <NSObject, UITextViewDelegate>
@optional
- (void)textViewWasTappedWhenUneditable:(CVTextView *)textView;
@end

@interface CVTextView : UITextView
@property (nonatomic, nullable, weak) IBOutlet id<CVTextViewDelegate> cv_delegate;
@end

NS_ASSUME_NONNULL_END

