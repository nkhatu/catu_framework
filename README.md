<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
<!--
File: README.md
File Version: 1.1.0
Copyright (c) 2026 The Khatu Family Trust
-->

![Catu Framework](https://raw.githubusercontent.com/nkhatu/app_scaffolding/main/assets/catu_framework.png)

# app_scaffolding

Reusable Flutter framework scaffold based on the architecture used in `app_scaffolding_source`.

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

## Wiring Guide

- Detailed setup and integration guide: `docs/Catu Framework : How To.md`
- Dependency injection guide: `docs/Dependency Injection.md`
- Firebase auth adapter example: `docs/examples/firebase_auth_service.example.dart`

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:app_scaffolding/app_scaffolding.dart';

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
        appVersion: '0.1.1',
        appBuild: '31',
        supportEmail: 'support@catu.app',
        copyrightNotice: 'Copyright © 2026 Catu Framework',
      ),
    ),
  );
}
```

## App icon assets

Android and iOS app build icons are sourced from `catu_full_ios_android_icon_pack` and copied into:

- `assets/icons/android/mipmap-*/ic_launcher.png`
- `assets/icons/ios/AppIcon.appiconset/*`

To apply these icons to a Flutter app (with Android and iOS folders), run:

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
