//
//  CVNativeAlertView.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void(^CVNativeAlertBlock)(void);

@interface CVNativeAlertView : UIAlertView <AVAudioPlayerDelegate>

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelTitle;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message 
    cancelButtonTitle:(NSString *)cancelTitle 
    cancelButtonBlock:(CVNativeAlertBlock)cancelBlock
           otherButtonTitle:(NSString *)otherTitle
     otherButtonBlock:(CVNativeAlertBlock)otherBlock;

+ (void)showWithTitle:(NSString *)title 
              message:(NSString *)message 
            soundName:(NSString *)soundName 
    cancelButtonTitle:(NSString *)cancelTitle 
    cancelButtonBlock:(CVNativeAlertBlock)cancelBlock 
     otherButtonTitle:(NSString *)otherTitle 
     otherButtonBlock:(CVNativeAlertBlock)otherBlock;

@end