//
//  CVDebug.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVDebug.h"

void CVDebug(const char *fileName, NSInteger lineNumber, NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    
    static NSDateFormatter *debugFormatter = nil;
    if (debugFormatter == nil) {
        debugFormatter = [[NSDateFormatter alloc] init];
        [debugFormatter setDateFormat:@"yyyy-MM-dd.HH:mm:ss"];
    }
    
    NSString *msg = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *filePath = [[NSString alloc] initWithUTF8String:fileName];    
    NSString *timestamp = [debugFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [info objectForKey:(NSString *)kCFBundleNameKey];
    fprintf(stdout, "%s %s[%s:%ld] %s\n",
            [timestamp UTF8String],
            [appName UTF8String],
            [[filePath lastPathComponent] UTF8String],
            (long)lineNumber,
            [msg UTF8String]);
    
    va_end(args);
}