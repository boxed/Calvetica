#import <UIKit/UIKit.h>
#import "colors.h"

UIColor* patentedWhite(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor whiteColor];
    }
    else {
        return [UIColor blackColor];
    }
}

UIColor* patentedBlack(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor blackColor];
    }
    else {
        return [UIColor whiteColor];
    }
}

UIColor* backgroundColorVeryWhite(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.941 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.941 alpha:1];
    }
}

UIColor* patentedVeryLightGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.933 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.933 alpha:1];
    }
}

UIColor* patentedPrettyLightGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.90 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.90 alpha:1];
    }
}

UIColor* patentedLightGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.80 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.80 alpha:1];
    }
}

UIColor* patentedGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.61 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.61 alpha:1];
    }
}

UIColor* patentedDarkGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.53 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.53 alpha:1];
    }
}

UIColor* patentedQuiteDarkGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.40 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.40 alpha:1];
    }
}

UIColor* patentedVeryDarkGray(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.24 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.24 alpha:1];
    }
}


UIColor* patentedDarkGrayWeekdayHeader(void) {
    if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [UIColor colorWithWhite:0.7 alpha:1];
    }
    else {
        return [UIColor colorWithWhite:1.0-0.7 alpha:1];
    }
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
