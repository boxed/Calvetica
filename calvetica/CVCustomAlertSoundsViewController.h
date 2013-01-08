//
//  CVCustomAlertSoundsViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "UITableViewCell+Nibs.h"
#import "sounds.h"


@interface CVCustomAlertSoundsViewController : UITableViewController <AVAudioPlayerDelegate> {
@private
@protected
}


#pragma mark - Public Properties
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableArray *audioFileNamesArray;


#pragma mark - Public Methods
- (NSData *)audioDataFromFilename:(NSString *)filename;
- (NSTimeInterval)durationFromAudio:(NSData *)audio;
- (void)startPlayingAudioWithFilename:(NSString *)filename;
+ (NSDictionary *)dictionaryFromAudioName:(NSString *)commonName filename:(NSString *)filename;

#pragma mark - Notifications


@end
