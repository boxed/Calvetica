//
//  CVNativeAlertView.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CVNativeAlertBlock)(void);

@interface CVNativeAlertView : NSObject

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelTitle;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelTitle
    cancelButtonBlock:(nullable CVNativeAlertBlock)cancelBlock
     otherButtonTitle:(nullable NSString *)otherTitle
     otherButtonBlock:(nullable CVNativeAlertBlock)otherBlock;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
            soundName:(nullable NSString *)soundName
    cancelButtonTitle:(NSString *)cancelTitle
    cancelButtonBlock:(nullable CVNativeAlertBlock)cancelBlock
     otherButtonTitle:(nullable NSString *)otherTitle
     otherButtonBlock:(nullable CVNativeAlertBlock)otherBlock;

@end

NS_ASSUME_NONNULL_END
