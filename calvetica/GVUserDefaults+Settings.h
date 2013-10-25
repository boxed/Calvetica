//
//  GVUserDefaults+Settings.h
//  calvetica
//
//  Created by Adam Kirk on 10/23/13.
//
//

#import "GVUserDefaults.h"


#define PREFS [GVUserDefaults standardUserDefaults]


@interface GVUserDefaults (Settings)
@property (nonatomic, assign) BOOL showReminders;
@end
