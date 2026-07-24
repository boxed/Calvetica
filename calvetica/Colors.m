#import <UIKit/UIKit.h>
#import "colors.h"
#import "CVSharedSettings.h"
#import "UIColor+Serialization.h"

#pragma mark - Theme Color

UIColor* calThemeColor(void) {
    NSString *string = PREFS.themeColorString;
    if (string.length) {
        return [UIColor colorFromString:string];
    }
    return patentedDefaultRed;
}

UIColor* calThemeColorDark(void) {
    CGFloat h, s, b, a;
    if ([calThemeColor() getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h saturation:s brightness:b * 0.72 alpha:a];
    }
    return patentedDefaultRed;
}

UIColor* calThemeColorDarker(void) {
    CGFloat h, s, b, a;
    if ([calThemeColor() getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h saturation:s brightness:b * 0.47 alpha:a];
    }
    return patentedDefaultRed;
}

UIColor* calBackgroundColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor whiteColor];
    }
    else {
        return [UIColor blackColor];
    }
}

// Gray text color derived from a light-mode "white" value. Mirrors the value
// for dark mode (as the app has always done); additionally, when the user has
// enabled Increase Contrast, pushes the text further from its background for
// better legibility. Default appearance (Increase Contrast off) is unchanged.
static UIColor* calAdaptiveTextColor(CGFloat lightWhite) {
    BOOL dark = UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
    CGFloat value = dark ? (1.0 - lightWhite) : lightWhite;
    if (UIAccessibilityDarkerSystemColorsEnabled()) {
        value = dark ? MIN(1.0, value + 0.18) : MAX(0.0, value - 0.18);
    }
    return [UIColor colorWithWhite:value alpha:1.0];
}

UIColor* calTextColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor blackColor];
    }
    else {
        return [UIColor whiteColor];
    }
}

UIColor* calSecondaryBackground(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.941 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.941 alpha:1];
    }
}

UIColor* calBorderColorLight(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.933 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.933 alpha:1];
    }
}

UIColor* calSeparatorColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.90 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.90 alpha:1];
    }
}

UIColor* calGridLineColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.80 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.80 alpha:1];
    }
}

UIColor* calSecondaryText(void) {
    return calAdaptiveTextColor(0.61);
}

UIColor* calTertiaryText(void) {
    return calAdaptiveTextColor(0.53);
}

UIColor* calQuaternaryText(void) {
    return calAdaptiveTextColor(0.40);
}

UIColor* calDimmedText(void) {
    return calAdaptiveTextColor(0.24);
}


UIColor* calWeekdayHeaderText(void) {
    return calAdaptiveTextColor(0.7);
}

#pragma mark - Semantic Colors

UIColor* alarmButtonBackgroundColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor whiteColor];
    }
    else {
        return [UIColor colorWithWhite:0 alpha:1];
    }
}

UIColor* alarmButtonTextColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor blackColor];
    }
    else {
        return [UIColor whiteColor];
    }
}

UIColor* alarmPickerBackgroundColor(void) {
    return [UIColor colorWithWhite:0 alpha:0];
}

UIColor* slideToDeleteBackgroundColor(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor whiteColor];
    }
    else {
        return [UIColor colorWithWhite:0.2 alpha:1];
    }
}
