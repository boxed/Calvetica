//
//  CVDebug.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

// this is used for conditional Logging, make sure to add -DCVDEBUG to the build settings under
// "other C Flags" in the Scheme of your choice (typical is in the Debug scheme)
// if the scheme doesn't have this flag the compiler won't include the debug code and statements in the build
#ifdef DEBUG
#define CVLog(format...) CVDebug(__FILE__, __LINE__, format)
#else
#define CVLog(format...)
#endif

// pass this as an arg to CVLog to see the class
#define CLASS_STRING NSStringFromClass([self class])

// pass this an an arg to CVLog to see the command/method
#define COMMAND_STRING NSStringFromSelector(_cmd)

void CVDebug(const char *fileName, int lineNumber, NSString *format, ...);