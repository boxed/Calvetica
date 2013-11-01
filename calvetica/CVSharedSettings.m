//
//  DOSharedSettings.m
//  DOCore
//
//  Created by Ben Dolman on 6/27/13.
//
//

#import "CVSharedSettings.h"
#import <objc/runtime.h>


@interface CVSharedSettings ()
- (id)objectForKeyFromPropertySelector:(SEL)selector;
- (void)setObject:(id)object forKeyFromPropertySelector:(SEL)selector;
@end


static id sharedSettingsObjectGetter(id self, SEL _cmd)
{
    CVSharedSettings *settings = self;
    return [settings objectForKeyFromPropertySelector:_cmd];
}

static void sharedSettingsObjectSetter(id self, SEL _cmd, id object)
{
    CVSharedSettings *settings = self;
    [settings setObject:object forKeyFromPropertySelector:_cmd];
}


@implementation CVSharedSettings

@dynamic showReminders;

+ (CVSharedSettings *)defaultSettings
{
    static CVSharedSettings *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [CVSharedSettings new];
    });
    return s;
}

+ (void)load
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);

    for (int i = 0; i < count; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *attributes = property_getAttributes(property);

        // make sure this follows naming convention
        NSString *nameString = [NSString stringWithUTF8String:name];
        BOOL conformsToNamingConvention = [nameString length] > 3 && [nameString characterAtIndex:3] == '_';
        if (!conformsToNamingConvention) {
            continue;
        }

        char *getter = strstr(attributes, ",G");
        if (getter) {
            getter = strdup(getter + 2);
            getter = strsep(&getter, ",");
        } else {
            getter = strdup(name);
        }
        SEL getterSel = sel_registerName(getter);
        free(getter);

        char *setter = strstr(attributes, ",S");
        if (setter) {
            setter = strdup(setter + 2);
            setter = strsep(&setter, ",");
        } else {
            asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
        }
        SEL setterSel = sel_registerName(setter);
        free(setter);

        char type = attributes[1];
        char types[5];

        snprintf(types, 4, "%c@:", type);
        class_addMethod(self, getterSel, (IMP)sharedSettingsObjectGetter, types);

        snprintf(types, 5, "v@:%c", type);
        class_addMethod(self, setterSel, (IMP)sharedSettingsObjectSetter, types);
    }
    
    free(properties);
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ubiquitousStoreDidChange:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:[NSUbiquitousKeyValueStore defaultStore]];
        
        BOOL synced = [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        if (!synced) {
            NSLog(@"NSUbiquitousKeyValueStore synchronization failed.");
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





#pragma mark - Notifications

// Updates local state when things change externally in the ubiquitous store
- (void)ubiquitousStoreDidChange:(NSNotification *)notif
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
        NSArray *keys = [notif userInfo][NSUbiquitousKeyValueStoreChangedKeysKey];
        for (NSString *changedKey in keys) {
            id obj = [store objectForKey:changedKey];
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:changedKey];
        }
    });
}




#pragma mark - Private

- (id)objectForKeyFromPropertySelector:(SEL)selector
{
    NSString *key           = [self keyForPropertySelector:selector];
    NSString *prefixedKey   = [self prefixedKey:key];

    id icloud       = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:prefixedKey];
    id local        = [[NSUserDefaults standardUserDefaults] objectForKey:prefixedKey];
    id defualt      = [self defaultForKey:key];

    if (self.isICloudEnabled && icloud) {
        return icloud;
    }

    if (local) {
        return local;
    }

    return defualt;
}

- (void)setObject:(id)object forKeyFromPropertySelector:(SEL)selector
{
    NSString *key           = [self keyForPropertySelector:selector];
    NSString *prefixedKey   = [self prefixedKey:key];

    if (self.isICloudEnabled) {
        [[NSUbiquitousKeyValueStore defaultStore] setObject:object forKey:prefixedKey];
    }
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:prefixedKey];
}

- (NSString *)keyForPropertySelector:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    if ([selectorString hasPrefix:@"set"] && [selectorString hasSuffix:@":"]) {
        selectorString = [selectorString stringByReplacingOccurrencesOfString:@"set" withString:@""];
        selectorString = [selectorString stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    NSString *keyString = [selectorString capitalizedString];
    return keyString;
}

- (NSString *)prefixedKey:(NSString *)key
{
    return [NSString stringWithFormat:@"com.mysterioustrousers.calvetica.%@", key];
}


- (id)defaultForKey:(NSString *)key
{
    static NSDictionary *defaults;
    defaults = @{
                 @"remindersOn" : @YES
                 };
    return defaults[key];
}


@end
