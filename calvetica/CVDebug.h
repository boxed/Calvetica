//
//  CVDebug.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

// this is used for conditional Logging, make sure to add -DCVDEBUG to the build settings under
// "other C Flags" in the Scheme of your choice (typical is in the Debug scheme)
// if the scheme doesn't have this flag the compiler won't include the debug code and statements in the build
#ifndef DLog
    #if defined(DEBUG)
        #define CVLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
        #define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
    #else
        #define CVLog(...) do { [NSString stringWithFormat:__VA_ARGS__]; } while (0)
        #ifndef NS_BLOCK_ASSERTIONS
            #define NS_BLOCK_ASSERTIONS
        #endif
        #define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
    #endif
    #define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)
#endif

// pass this as an arg to CVLog to see the class
#define CLASS_STRING NSStringFromClass([self class])

// pass this an an arg to CVLog to see the command/method
#define COMMAND_STRING NSStringFromSelector(_cmd)

void CVDebug(const char *fileName, NSInteger lineNumber, NSString *format, ...);