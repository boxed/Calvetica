//
//  CVNativeAlertView.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVNativeAlertView.h"
#import "CVDebug.h"

// private extension
@interface CVNativeAlertView ()

#pragma mark - Private Properties
@property (nonatomic, copy) CVNativeAlertBlock cancelButtonBlock;
@property (nonatomic, copy) CVNativeAlertBlock otherButtonBlock;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

#pragma mark - Private Methods
- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
          soundName:(NSString *)name
  cancelButtonTitle:(NSString *)cancelTitle 
  cancelButtonBlock:(CVNativeAlertBlock)cancelBlock
   otherButtonTitle:(NSString *)otherTitle
   otherButtonBlock:(CVNativeAlertBlock)otherBlock;

- (NSData *)audioDataFromFilename:(NSString *)filename;
- (void)startPlayingAudioWithFilename:(NSString *)filename;
#pragma mark - IBActions
@end






@implementation CVNativeAlertView

#pragma mark - Constructors

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
          soundName:(NSString *)name
  cancelButtonTitle:(NSString *)cancelTitle 
  cancelButtonBlock:(CVNativeAlertBlock)cancelBlock
   otherButtonTitle:(NSString *)otherTitle
   otherButtonBlock:(CVNativeAlertBlock)otherBlock {
    
    if ((self = [super initWithTitle:title 
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelTitle 
                   otherButtonTitles:otherTitle, nil])) {
        
        if (!cancelBlock && !otherBlock && !name) {
            self.delegate = nil;
        }
        
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelButtonBlock = cancelBlock;
        self.otherButtonBlock = otherBlock;
        
        if (name) {
            [self startPlayingAudioWithFilename:name];
        }
        
    }
    return self;
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelTitle {
    
    [self showWithTitle:title message:message soundName:nil cancelButtonTitle:cancelTitle cancelButtonBlock:nil otherButtonTitle:nil otherButtonBlock:nil];
    
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message 
    cancelButtonTitle:(NSString *)cancelTitle 
    cancelButtonBlock:(CVNativeAlertBlock)cancelBlock
     otherButtonTitle:(NSString *)otherTitle
     otherButtonBlock:(CVNativeAlertBlock)otherBlock {
    
    [self showWithTitle:title message:message soundName:nil cancelButtonTitle:cancelTitle cancelButtonBlock:cancelBlock otherButtonTitle:otherTitle otherButtonBlock:otherBlock];
    
}

+ (void)showWithTitle:(NSString *)title 
              message:(NSString *)message 
            soundName:(NSString *)name 
    cancelButtonTitle:(NSString *)cancelTitle 
    cancelButtonBlock:(CVNativeAlertBlock)cancelBlock 
     otherButtonTitle:(NSString *)otherTitle 
     otherButtonBlock:(CVNativeAlertBlock)otherBlock {
    
    [[[self alloc] initWithTitle:title message:message soundName:name cancelButtonTitle:cancelTitle cancelButtonBlock:cancelBlock otherButtonTitle:otherTitle otherButtonBlock:otherBlock] show];
}



#pragma mark - Private Methods

- (NSData *)audioDataFromFilename:(NSString *)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:@"caf"];
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (void)startPlayingAudioWithFilename:(NSString *)filename 
{
    @autoreleasepool {
    
        NSData *fileData = [self audioDataFromFilename:filename];
        
        NSError *error = nil;
        
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        newPlayer.delegate = self;
        self.audioPlayer = newPlayer;
        
        if (self.audioPlayer) {
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
                CVLog(@"playing");
            }
            else {
                CVLog(@"not playing");
            }
        }
        else {
            CVLog(@"failed to instantiate player");
        }
    
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:self.cancelButtonTitle]) {
        if (self.cancelButtonBlock) self.cancelButtonBlock();
    } else if ([buttonTitle isEqualToString:self.otherButtonTitle]) {
        if (self.otherButtonBlock) self.otherButtonBlock();
    }
    
    [self.audioPlayer stop];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
    
    if ([player isEqual:self.audioPlayer]) {
        self.audioPlayer = nil;
    }
    else {
    }
}

@end
