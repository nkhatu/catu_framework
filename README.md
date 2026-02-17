<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
<!--
File: README.md
File Version: 1.3.0
Copyright (c) 2026 The Khatu Family Trust
-->

![Catu Framework](https://raw.githubusercontent.com/nkhatu/catu_framework/main/assets/catu_framework.png)

# Core Application Technology Utility (Catu) Framework

`catu_framework` is a reusable Flutter scaffold designed to help novice developers build their first structured app for Android and iOS without starting from a blank screen.

GitHub: [nkhatu/catu_framework](https://github.com/nkhatu/catu_framework)

## Purpose

The framework exists to reduce "first app" friction while still teaching how real apps are assembled.

Most starter templates either:

- Give too little structure, leaving beginners confused about architecture decisions.
- Give too much hidden automation, so beginners can run the app but do not understand the mechanics.

`catu_framework` takes a middle path. It gives a complete working scaffold for authentication, navigation, settings, legal/support pages, and app shell layout, while keeping the implementation readable so developers can learn by modifying real code.

## Who this framework is for

- New Flutter developers building a first or second app.
- Developers who can run `flutter create` but struggle to connect routing, state, auth, and UI shell cleanly.
- Teams mentoring junior developers who need a teachable baseline architecture.

## Challenges novice developers face (and what this framework teaches)

1. **Blank-project uncertainty**
A new Flutter app starts almost empty. Beginners often do not know which folder structure to use, where state should live, or how routes should be organized.
`catu_framework` provides a concrete app skeleton with clear modules and routing conventions.

2. **State and auth flow confusion**
Sign-in state, bootstrap state, and navigation state are tightly coupled in real apps. Beginners frequently mix UI state and business state.
`AppState` plus `AuthService` demonstrates a clean session lifecycle: bootstrap -> sign-in/register -> signed-in session -> sign-out.

3. **Dependency wiring and testability**
Many first apps hardcode service instances directly inside widgets, making the app difficult to test or replace later.
The framework injects services (`AuthService`, analytics, config) at app startup so implementations can be swapped safely.

4. **Navigation consistency**
Beginners often create routes ad hoc and lose consistency across pages.
`AppRoutes` and `AppPageShell` show centralized routing with a reusable shell, menu, and footer/header patterns.

5. **Crash/error handling gaps**
First apps usually skip crash handling entirely.
`CrashAnalyticsService` + `installCrashAnalyticsHandlers` demonstrates how to catch and report failures early.

6. **Android/iOS readiness**
Beginners may get UI working but miss platform polish such as launcher icons, version metadata, and deployable configuration.
The repository includes icon assets, app-version/build configuration, and example deployment guidance.

7. **Non-feature pages are often forgotten**
Support, privacy, licensing, and feedback are often postponed until late release stages.
The framework includes these pages so beginners learn complete app scaffolding, not just feature screens.

## Included framework modules

- Theme: `ThemeController`, `AppThemeVariant`, `buildAppTheme`
- SignIn/Register: `AuthService`, `SignInPage`, `RegisterPage`, `InMemoryAuthService`
- Social auth hooks: `signInWithGoogle()` and `signInWithApple()` in `AuthService`
- Routes: `AppRoutes` + prewired route map in `AppFrameworkApp`
- AppState: `AppState` for session/bootstrap/sign-in lifecycle
- Bootstrap: `BootstrapPage`
- Menu: `AppMenuButton` + menu action handling in `AppPageShell`
- Settings: `SettingsPage` with theme picker and crash log panel
- Crash analytics: `CrashAnalyticsService`, `InMemoryCrashAnalyticsService`, `installCrashAnalyticsHandlers`
- Page layout shell: `AppPageShell`, `AppPageHeader`, `AppPageFooter`
- Legal/support/feedback pages: `PrivacyPage`, `CopyrightPage`, `SupportPage`, `FeedbackPage`

## Usage

### Option 1: Learn quickly by running the included example

```bash
git clone https://github.com/nkhatu/catu_framework.git
cd catu_framework/example
flutter pub get
flutter run
```

This path is best if your goal is to understand how the scaffold behaves before integrating it into your own app.

### Option 2: Use the framework in your own new Flutter app

1. Create a new app.

```bash
flutter create my_first_app
cd my_first_app
```

2. Add dependency to `pubspec.yaml`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  catu_framework:
    git:
      url: https://github.com/nkhatu/catu_framework.git
```

3. Install packages.

```bash
flutter pub get
```

4. Replace `lib/main.dart` with framework bootstrap wiring.

```dart
import 'package:flutter/material.dart';
import 'package:catu_framework/catu_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = InMemoryAuthService(
    users: {
      'demo@catu.app': 'demo123',
      'admin@catu.app': 'admin123',
    },
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

5. Run on a connected device/emulator.

```bash
flutter run
```

6. Replace demo services with production services as your app matures.

## Mechanics walkthrough (how the app is actually put together)

1. `main()` wires concrete services (`AuthService`, analytics) and immutable app metadata (`AppFrameworkConfig`).
2. `AppFrameworkApp` builds the route table and owns top-level app composition.
3. `AppState` coordinates bootstrap/auth/session transitions and exposes state to UI.
4. `AppPageShell` standardizes page layout and menu behavior across screens.
5. Feature/support/legal/settings pages are routed through `AppRoutes` with consistent navigation semantics.
6. Crash handlers are installed early so runtime failures can be captured.

This sequence helps beginners understand that Flutter apps are not just UI widgets; they are service wiring, lifecycle control, route orchestration, and platform packaging.

## Beginner progression checklist

- Start with `InMemoryAuthService` to understand flow before using Firebase/Auth0/custom backend.
- Change app metadata (`appName`, `appVersion`, `appBuild`) and confirm it appears in settings.
- Add one new route and menu entry to learn routing + shell integration.
- Replace placeholder legal/support text with your app policy/contact content.
- Add one real crash logging provider and verify error capture in debug tests.
- Build and run on Android and iOS to learn platform-specific readiness checks.

## Wiring Guide

- Detailed setup and integration guide: `docs/Catu Framework : How To.md`
- Dependency injection guide: `docs/Dependency Injection.md`
- Developer install guide (setup + GitHub download): `docs/Developer Install Guide.md`
- Firebase auth adapter example: `docs/examples/firebase_auth_service.example.dart`

## App icon assets

Source artwork for all icon sets:

- `assets/Catu_Square_1024.png`

Generated icon sets committed in this repository:

- `assets/icons/android/mipmap-*/ic_launcher.png`
- `assets/icons/ios/AppIcon.appiconset/*`
- `catu_full_ios_android_icon_pack/Android_mipmap/mipmap-*/ic_launcher.png`
- `catu_full_ios_android_icon_pack/iOS_AppIcon.appiconset/*`
- `example/android/app/src/main/res/mipmap-*/ic_launcher.png`
- `example/ios/Runner/Assets.xcassets/AppIcon.appiconset/*`

Regenerate icon sets from the source image:

```bash
./scripts/generate_icon_sets.sh
```

Apply framework icons to a target Flutter app (with Android and iOS folders):

```bash
./scripts/apply_app_icons.sh /absolute/path/to/your_flutter_app
```

## Production integration notes

- Replace `InMemoryAuthService` with your real auth provider.
- Wire `register`, `signInWithGoogle`, and `signInWithApple` to your backend/Firebase providers.
- Replace or wrap `InMemoryCrashAnalyticsService` with Firebase Crashlytics or your telemetry provider.
- Replace placeholder legal/support text with your own content.
- Extend settings/menu/routes with your app-specific pages.

## License

This repository is licensed under **Apache-2.0**.

- License file: `LICENSE`
- Copyright (c) 2026 The Khatu Family Trust

## SPDX Header Pattern

Use the following SPDX pattern in new files.

Dart (`.dart`):

```dart
/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
```

YAML/Shell (`.yaml`, `.yml`, `.sh`):

```text
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 The Khatu Family Trust
```

Markdown (`.md`):

```markdown
<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
```
