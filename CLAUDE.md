# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development

This is an iOS calendar app using **Xcode with CocoaPods**. Always open the workspace, not the project:

```bash
open calvetica.xcworkspace
```

Build and run from Xcode (Cmd+B / Cmd+R). If dependencies need updating:

```bash
pod install
```

**After completing a change**, build and run the app on Anders iPhone:

```bash
xcodebuild -workspace calvetica.xcworkspace -scheme calvetica -destination "name=Anders Hovmöller's iPhone" build
```

## Architecture

**Objective-C iOS app** targeting iPhone and iPad with separate storyboards:
- `Main_iPhone.storyboard` - iPhone UI
- `Main_iPad.storyboard` - iPad UI
- `Settings.storyboard` - Settings screen

**Class prefix:** `CV` for all app classes

**View Controller Hierarchy:**
- `CVRootViewController` - Main container
  - `CVWeekAgenda` - Week agenda/list view
  - `CVWeek` - Week view
  - `CVDetailedWeek` - Detailed week with week numbers
  - `CVFullDay` - Full day view
  - `CVCompactWeek` - Compact week view
- `CVMonthTableViewController` - Month calendar view

**Key Files:**
- `CVAppDelegate.m` - App startup, timezone setup, notifications
- `CVSharedSettings.h/.m` - All user preferences (40+ settings)
- `dimensions.h` - UI constants (row heights, fonts, padding)
- `color.h` / `colors.h` - Color palette

## Custom Libraries (in `/libs/`)

Internal CocoaPod libraries with `MT` or `MYS` prefix:

- **MTDates** - Date utilities with `mt_` method prefix (e.g., `[date mt_dayOfMonth]`)
- **MTAnimation** - UIView animation extensions
- **MTGeometry** - Geometry utilities
- **MTPencil** - Animated line drawing
- **MTMigration** - Data migration
- **MYSSharedSettings** - Settings/preferences framework
- **MYSRuntime** - Runtime introspection

## EventKit Integration

The app uses EventKit for calendars and reminders. Key extensions:
- `EKEvent+Utilities.m`
- `EKReminder+Dates.m`
- `EKEventStore+Reminders.m`
- `EKRecurrenceDayOfWeek+Utilities.m`

## Platform Macros

Defined in `calvetica-Prefix.pch`:
- `PAD` - Returns YES on iPad
- `IS_MAC` - Returns YES when running as Mac Catalyst / iOS app on Mac
- `NSLog` - Disabled in non-DEBUG builds

## Tests

Test target: `calveticaTests/`

Run tests from Xcode with Cmd+U. Test coverage is minimal (primarily `CVSharedSettingsTests.m`).
