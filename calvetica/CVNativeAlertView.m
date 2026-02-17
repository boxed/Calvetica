//
//  CVNativeAlertView.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVNativeAlertView.h"
#import "CVDebug.h"

@interface CVNativeAlertView () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

// We need a strong reference to keep the audio player alive during alert presentation
static CVNativeAlertView *_activeInstance = nil;

@implementation CVNativeAlertView

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelTitle
{
    [self showWithTitle:title message:message soundName:nil cancelButtonTitle:cancelTitle cancelButtonBlock:nil otherButtonTitle:nil otherButtonBlock:nil];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelTitle
    cancelButtonBlock:(CVNativeAlertBlock)cancelBlock
     otherButtonTitle:(NSString *)otherTitle
     otherButtonBlock:(CVNativeAlertBlock)otherBlock
{
    [self showWithTitle:title message:message soundName:nil cancelButtonTitle:cancelTitle cancelButtonBlock:cancelBlock otherButtonTitle:otherTitle otherButtonBlock:otherBlock];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
            soundName:(NSString *)soundName
    cancelButtonTitle:(NSString *)cancelTitle
    cancelButtonBlock:(CVNativeAlertBlock)cancelBlock
     otherButtonTitle:(NSString *)otherTitle
     otherButtonBlock:(CVNativeAlertBlock)otherBlock
{
    CVNativeAlertView *instance = nil;
    if (soundName) {
        instance = [[CVNativeAlertView alloc] init];
        [instance startPlayingAudioWithFilename:soundName];
        _activeInstance = instance;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
        if (cancelBlock) cancelBlock();
        [instance stopAudio];
        _activeInstance = nil;
    }]];

    if (otherTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:otherTitle
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
            if (otherBlock) otherBlock();
            [instance stopAudio];
            _activeInstance = nil;
        }]];
    }

    UIViewController *presenter = [self topViewController];
    if (presenter) {
        [presenter presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Private

+ (UIViewController *)topViewController
{
    UIViewController *root = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}

- (void)startPlayingAudioWithFilename:(NSString *)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:@"caf"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];

    NSError *error = nil;
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    newPlayer.delegate = self;
    self.audioPlayer = newPlayer;

    if (self.audioPlayer) {
        if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
            CVLog(@"playing");
        } else {
            CVLog(@"not playing");
        }
    } else {
        CVLog(@"failed to instantiate player");
    }
}

- (void)stopAudio
{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([player isEqual:self.audioPlayer]) {
        self.audioPlayer = nil;
    }
}

@end
