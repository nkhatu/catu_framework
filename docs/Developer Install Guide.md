<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
<!--
File: docs/Developer Install Guide.md
File Version: 1.1.0
Framework : Core App Tech Utilities (Catu) Framework
Author: Neil Khatu
Copyright (c) 2026 The Khatu Family Trust
-->

# Catu Framework Developer Install Guide

This guide is for developers who want to download, run, and integrate `catu_framework` quickly.

## 1. Prerequisites

Install the following tools before setup:

- Flutter SDK (stable channel)
- Dart SDK (included with Flutter)
- Git
- Android Studio (for Android development)
- Xcode (for iOS development on macOS)

Recommended checks:

```bash
flutter doctor
flutter --version
git --version
```

Resolve any `flutter doctor` issues before continuing.

## 2. Download From GitHub

Repository URL:

- `https://github.com/nkhatu/catu_framework`

### Option A: Clone with Git (recommended)

```bash
git clone https://github.com/nkhatu/catu_framework.git
cd catu_framework
```

### Option B: Download ZIP

1. Open `https://github.com/nkhatu/catu_framework`
2. Click **Code**
3. Click **Download ZIP**
4. Extract the archive
5. Open the extracted folder in your IDE/terminal

## 3. Install Dependencies

From repository root:

```bash
flutter pub get
```

From example app:

```bash
cd example
flutter pub get
```

## 4. Run Quality Checks

From repository root:

```bash
flutter analyze
flutter test
```

From `example/`:

```bash
flutter analyze
flutter test
```

## 5. Run on Android

From `example/`:

```bash
flutter devices
flutter run -d <android_device_id>
```

If only one Android device is connected:

```bash
flutter run
```

## 6. Run on iOS (macOS only)

From `example/`:

```bash
flutter devices
flutter run -d <ios_device_id>
```

If CocoaPods setup is needed:

```bash
cd ios
pod install
cd ..
```

## 7. Use Catu Framework in Your Own App

### Option A: Local path dependency

In your app `pubspec.yaml`:

```yaml
dependencies:
  catu_framework:
    path: /absolute/path/to/catu_framework
```

Then run:

```bash
flutter pub get
```

### Option B: Git dependency

In your app `pubspec.yaml`:

```yaml
dependencies:
  catu_framework:
    git:
      url: https://github.com/nkhatu/catu_framework.git
      ref: main
```

Then run:

```bash
flutter pub get
```

## 8. Basic Integration Example

```dart
import 'package:flutter/material.dart';
import 'package:catu_framework/catu_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = InMemoryAuthService(
    users: {'demo@catu.app': 'demo123'},
    adminEmail: 'admin@catu.app',
  );

  final analytics = InMemoryCrashAnalyticsService();

  runApp(
    AppFrameworkApp(
      authService: auth,
      analytics: analytics,
      config: const AppFrameworkConfig(
        appName: 'Catu Framework',
        appVersion: '0.0.1',
        appBuild: '1',
        supportEmail: 'support@catu.app',
        copyrightNotice: 'Copyright © 2026 Catu Framework',
      ),
    ),
  );
}
```

## 9. App Icons (Android + iOS)

Source image for app icons:

- `assets/Catu.png`

Regenerate all committed icon sets:

```bash
./scripts/generate_icon_sets.sh
```

Copy prepared launcher icons into a target Flutter app:

```bash
./scripts/apply_app_icons.sh /absolute/path/to/your_flutter_app
```

## 10. Troubleshooting

- Device not detected:
  - Run `flutter devices`
  - Check USB cable/permissions
  - Run `adb devices` for Android
- Build fails after SDK updates:
  - Run `flutter clean`
  - Run `flutter pub get`
- iOS pod issues:
  - Run `cd ios && pod install`

## 11. Next Docs

- Architecture/Wiring: `docs/Catu Framework : How To.md`
- Dependency Injection: `docs/Dependency Injection.md`
