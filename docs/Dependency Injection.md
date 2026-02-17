<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
<!--
File: docs/Dependency Injection.md
File Version: 1.0.0
Framework : Core App Tech Utilities (Catu) Framework
Author: Neil Khatu
Copyright (c) 2026 The Khatu Family Trust
-->

![Catu Framework](https://raw.githubusercontent.com/nkhatu/app_scaffolding/main/assets/catu_framework.png)

# Dependency Injection in Catu Framework

This document explains how dependency injection works in `app_scaffolding` and how to wire it.

## What Was Introduced

The framework now includes a DI container object:

- `AppFrameworkDependencies` (`lib/src/di/app_framework_dependencies.dart`)

It supports injecting:

- `AuthService`
- `CrashAnalyticsService`
- optional custom factories for:
  - `AppState` (`AppStateFactory`)
  - `ThemeController` (`ThemeControllerFactory`)

## Why Use It

- Centralizes app wiring in one place.
- Makes testing easier (swap implementations/factories).
- Keeps framework code provider-agnostic.

## API Options

### Option A: Existing constructor (backward compatible)

```dart
AppFrameworkApp(
  authService: authService,
  analytics: analytics,
  config: config,
)
```

### Option B: DI-first constructor

```dart
AppFrameworkApp.withDependencies(
  dependencies: dependencies,
  config: config,
)
```

## Example: Default DI Wiring

```dart
import 'package:app_scaffolding/app_scaffolding.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = AppFrameworkDependencies(
    authService: InMemoryAuthService(users: {'demo.user': 'demo123'}),
    analytics: InMemoryCrashAnalyticsService(),
  );

  runApp(
    AppFrameworkApp.withDependencies(
      dependencies: dependencies,
      config: const AppFrameworkConfig(
        appName: 'Catu Framework',
        appVersion: '0.1.1',
        appBuild: '31',
        supportEmail: 'support@yourdomain.com',
        copyrightNotice: 'Copyright © 2026 Catu Framework',
      ),
    ),
  );
}
```

## Example: Custom Factory Injection

Use this when you need specialized `AppState` or `ThemeController` behavior.

```dart
import 'package:app_scaffolding/app_scaffolding.dart';

final dependencies = AppFrameworkDependencies(
  authService: myAuthService,
  analytics: myAnalyticsService,
  appStateFactory: ({required authService, required analytics}) {
    final appState = AppState(authService: authService, analytics: analytics);
    // Attach custom listeners/telemetry/warmup here.
    return appState;
  },
  themeControllerFactory: () {
    final controller = ThemeController();
    // Optional pre-configuration
    return controller;
  },
);
```

## Firebase Example (DI)

If you use Firebase auth, inject your adapter implementation:

```dart
final dependencies = AppFrameworkDependencies(
  authService: FirebaseAuthService(),
  analytics: InMemoryCrashAnalyticsService(),
);

runApp(
  AppFrameworkApp.withDependencies(
    dependencies: dependencies,
    config: myConfig,
  ),
);
```

Reference adapter sample:

- `docs/examples/firebase_auth_service.example.dart`

## Where To Modify

- DI contract and factories:
  - `lib/src/di/app_framework_dependencies.dart`
- Framework composition root:
  - `lib/src/framework/app_framework.dart`
- Public export:
  - `lib/app_scaffolding.dart`

## Verification

```bash
flutter test
```
