//
//  CVCustomAlertSoundsViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVCustomAlertSoundsViewController.h"
#import "CVDebug.h"




@implementation CVCustomAlertSoundsViewController


- (void)viewDidLoad 
{
    [super viewDidLoad];

	NSMutableArray *audioNames = [NSMutableArray array];
	[audioNames addObject:@"Endless Love"];
	[audioNames addObject:@"Sayonara Robot"];
	[audioNames addObject:@"Bullet Train to Everest"];
	[audioNames addObject:@"Jazz Hands"];
	[audioNames addObject:@"Annoy Your Coworkers"];
	[audioNames addObject:@"Hey there, Friend."];

	NSMutableArray *audioFiles = [NSMutableArray array];
	[audioFiles addObject:PIANO];
	[audioFiles addObject:WHIRLY];
	[audioFiles addObject:FLUTE_1];
	[audioFiles addObject:FLUTE_2];
	[audioFiles addObject:PIANO_2];
	[audioFiles addObject:WHISTLE];

	self.audioFileNamesArray = [NSMutableArray array];

	for (int i = 0; i < audioNames.count; i++) {
		NSString *name = [audioNames objectAtIndex:i];
		NSString *filename = [audioFiles objectAtIndex:i];
		NSDictionary *audioDict = [CVCustomAlertSoundsViewController dictionaryFromAudioName:name filename:filename];

		[self.audioFileNamesArray addObject:audioDict];
	}

    self.navigationItem.title = @"Alert Audio";
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 416);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.audioPlayer) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Public Methods
- (NSData *)audioDataFromFilename:(NSString *)filename 
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:@"caf"];
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (NSTimeInterval)durationFromAudio:(NSData *)audio 
{    
    NSError *error = nil;
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:audio error:&error];
    return player.duration;
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

+ (NSDictionary *)dictionaryFromAudioName:(NSString *)commonName filename:(NSString *)filename {
    return @{@"name": commonName, @"filename": filename};
}

#pragma mark - Private Methods




#pragma mark - IBActions




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0) {
        return self.audioFileNamesArray.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [UITableViewCell cellWithStyle:UITableViewCellStyleSubtitle forTableView:tableView];

    cell.textLabel.font             = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font       = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor  = [UIColor darkGrayColor];

    if (indexPath.section == 0) {
        NSDictionary *dict = [self.audioFileNamesArray objectAtIndex:indexPath.row];
        NSString *filename = [dict objectForKey:@"filename"];
        NSString *name = [dict objectForKey:@"name"];
        NSTimeInterval duration = [self durationFromAudio:[self audioDataFromFilename:filename]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = name;
        
        if ([filename isEqualToString:[CVSettings customAlertSoundFile]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if ([self.audioPlayer isPlaying]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %0.0f sec", @"tap to stop", duration];
            }
            else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %0.0f sec", @"tap to preview", duration];
            }
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %0.0f sec", @"tap to preview", duration];
        }
    }
    else {
        cell.textLabel.text = NSLocalizedString(@"Reset to defaults", @"Reset to defaults");
    }
    
    return cell;
}

//NSNumberFormatter



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if (indexPath.section == 0) {
        NSDictionary *dict = [self.audioFileNamesArray objectAtIndex:indexPath.row];
        NSString *filename = [dict objectForKey:@"filename"];
        
        if ([self.audioPlayer isPlaying] && [filename isEqualToString:[CVSettings customAlertSoundFile]]) {
            [self.audioPlayer stop];
        }
        else {
            [self startPlayingAudioWithFilename:filename];
        }
        
        [CVSettings setCustomAlertSoundFile:filename];
    }
    else {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
        }
        [CVSettings setCustomAlertSoundFile:nil];
    }
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return NSLocalizedString(@"Available Calvetica Alerts", @"The header of a table with a list of available alerts");
    }
    else {
       return NSLocalizedString(@"Defaults", @"Defaults");
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (section == 0) {
        return NSLocalizedString(@"Select a clip to save it as the alert audio", @"Instructions to the user as a footer on a table");
    }
    else {
        return @"";
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
    
    [self.tableView reloadData];
    
    if ([player isEqual:self.audioPlayer]) {
        self.audioPlayer = nil;
    }
    else {
    }
}

@end
