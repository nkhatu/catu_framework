<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
<!--
File: docs/Catu Framework : How To.md
File Version: 1.2.0
Framework : Complete App Topology Utility (Catu) Framework
Author: Neil Khatu
Copyright (c) 2026 The Khatu Family Trust
-->

![Catu Framework](https://raw.githubusercontent.com/nkhatu/catu_framework/main/assets/Catu.png)

# Catu Framework Wiring Guide

For DI-first setup details: `docs/Dependency Injection.md`

This guide explains **where each framework concern lives** and **how to wire it** into a real app.

## Architecture Map (Where + What)

| Capability | Primary Files | What You Wire |
| --- | --- | --- |
| Theme | `lib/src/theme/*`, `lib/src/settings/settings_page.dart` | Theme selection + persistence per user/guest |
| Sign-in/Register | `lib/src/auth/*` | Concrete `AuthService` (Firebase/custom/demo) |
| Routes | `lib/src/routing/app_routes.dart`, `lib/src/framework/app_framework.dart` | Route additions/overrides |
| App state | `lib/src/app_state/app_state.dart` | Session lifecycle and auth events |
| Bootstrap | `lib/src/bootstrap/bootstrap_page.dart` | Startup session restore path |
| Menu | `lib/src/menu/app_menu.dart`, `lib/src/shell/page_shell.dart` | Menu actions + navigation mapping |
| Settings | `lib/src/settings/settings_page.dart` | Theme picker, app version/build, diagnostics |
| Crash analytics | `lib/src/analytics/crash_analytics_service.dart` | Concrete logger provider |
| Page shell | `lib/src/shell/page_shell.dart` | Header, body, footer layout wrapper |
| Legal + support + feedback | `lib/src/legal/*`, `lib/src/support/support_page.dart`, `lib/src/feedback/feedback_page.dart` | Real legal/support/feedback content + backend hooks |

## Minimal App Bootstrap (How)

Use `AppFrameworkApp` as your composition root.

```dart
import 'package:flutter/material.dart';
import 'package:catu_framework/catu_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = InMemoryAuthService(
    users: {'demo.user': 'demo123'},
    adminEmail: 'admin.user',
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
        supportEmail: 'support@yourdomain.com',
        copyrightNotice: 'Copyright © 2026 Catu Framework',
      ),
    ),
  );
}
```

## Detailed Wiring by Concern

### 1. Theme

- Theme variants: `AppThemeVariant` in `lib/src/theme/app_theme.dart`
- Theme builder: `buildAppTheme(...)` in `lib/src/theme/theme_data_factory.dart`
- Persistence: `ThemeController` in `lib/src/theme/theme_controller.dart`

How it works:
- Guest preference key: `catu_framework_theme_guest`
- Signed-in preference key: `catu_framework_theme_user_<userId>`
- `AppFrameworkApp` syncs the active user ID into `ThemeController` automatically.

### 2. Sign-in / Register

- Contract: `AuthService` in `lib/src/auth/auth_service.dart`
- Demo implementation: `InMemoryAuthService` in `lib/src/auth/in_memory_auth_service.dart`
- UI: `SignInPage` and `RegisterPage`

Production wiring:
- Replace `InMemoryAuthService` with your implementation.
- Implement:
  - `currentUser()`
  - `signIn(...)`
  - `register(...)`
  - `signInWithGoogle()`
  - `signInWithApple()`
  - `signOut()`

### 3. Routes

- Route constants: `AppRoutes`
- Default route map: `AppFrameworkApp`

Add new route:
1. Add route constant in `AppRoutes`.
2. Add the widget mapping in `AppFrameworkApp.routes`.
3. Add menu action if needed (next section).

### 4. App State

`AppState` centralizes:
- bootstrap session restore
- sign-in/register/social sign-in
- sign-out
- error/log signaling

Keep app-level auth side effects in `AppState` (not UI widgets).

### 5. Bootstrap

`BootstrapPage` is the startup gate.

Flow:
1. App starts on `AppRoutes.bootstrap`
2. `AppState.bootstrap()` runs
3. Navigate to sign-in or home based on session

### 6. Menu

- Enum: `AppMenuAction`
- UI trigger: `AppMenuButton`
- Action routing: `_onMenuSelection(...)` in `AppPageShell`

To add a menu item:
1. Add enum value in `AppMenuAction`.
2. Add `PopupMenuItem` in `AppMenuButton`.
3. Add handling case in `AppPageShell._onMenuSelection`.

### 7. Settings

`SettingsPage` already includes:
- Theme selector
- About (version + build)
- Crash log viewer

You only need to pass:
- `themeController`
- `analytics`
- `appVersion`
- `appBuild`

### 8. Crash Analytics

Contract: `CrashAnalyticsService`

Use in-memory logs for local/demo or provide a real implementation (Firebase Crashlytics/Sentry/etc.).

Hook registration is automatic through:
- `installCrashAnalyticsHandlers(widget.analytics)` in `AppFrameworkApp.initState`

### 9. Header / Body / Footer Shell

Use `AppPageShell` for every signed-in page.

```dart
return AppPageShell(
  title: 'My Feature',
  appState: appState,
  footerText: 'Copyright © 2026 Catu Framework',
  body: const Center(child: Text('Feature body')),
);
```

This keeps nav/menu/footer behavior consistent.

### 10. Copyright / Privacy / Support / Feedback

Provided pages:
- `PrivacyPage`
- `CopyrightPage`
- `SupportPage`
- `FeedbackPage`

Production expectation:
- Replace placeholder text/content.
- Wire `FeedbackPage` submission to backend/email/queue.

## Icons and Branding

Source image for icon generation:
- `assets/Catu.png`

Regenerate all committed Android/iOS icon sets:
```bash
./scripts/generate_icon_sets.sh
```

Apply framework icons into a target Flutter app:
```bash
./scripts/apply_app_icons.sh /absolute/path/to/flutter_app
```


## 11. Firebase Authentication + App Check (Example Wiring)

This section shows one practical wiring pattern. Keep `catu_framework` framework-agnostic and put Firebase-specific code in your app layer.

### Firebase Console Setup

1. Create/select your Firebase project.
2. Add Android app and iOS app in Firebase Project Settings.
3. Download config files and place them in your app:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
4. Enable auth providers in Firebase Auth:
- Email/Password
- Google
- Apple (if needed)
5. For Android Google sign-in, add SHA-1 and SHA-256 fingerprints in Firebase Project Settings.
6. If using Apple sign-in, configure Apple Developer keys/Service ID and map them in Firebase Auth provider settings.

### Flutter Dependencies (Host App)

Add to the host app `pubspec.yaml` (not required in the framework package itself):

```yaml
dependencies:
  firebase_core: ^3.15.0
  firebase_auth: ^5.6.0
  firebase_app_check: ^0.3.2+7
  google_sign_in: ^6.3.0
  sign_in_with_apple: ^6.1.4
```

Then run:

```bash
flutter pub get
```

### Example `AuthService` Adapter

Create `lib/auth/firebase_auth_service.dart` in your host app:

```dart
import 'package:catu_framework/catu_framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Future<AuthUser?> currentUser() async {
    final user = _auth.currentUser;
    return user == null ? null : _map(user);
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _map(cred.user!);
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName.trim().isNotEmpty) {
      await cred.user?.updateDisplayName(displayName.trim());
      await cred.user?.reload();
    }
    return _map(_auth.currentUser!);
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    return _map(userCred.user!);
  }

  @override
  Future<AuthUser> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    final oauth = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final userCred = await _auth.signInWithCredential(oauth);
    return _map(userCred.user!);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  AuthUser _map(User user) {
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : (user.email?.split('@').first ?? 'User'),
      isAdmin: false,
    );
  }
}
```

### Wire Firebase Into `main.dart`

```dart
import 'package:catu_framework/catu_framework.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'auth/firebase_auth_service.dart';
import 'firebase_options.dart'; // generated by flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode
        ? AppleProvider.debug
        : AppleProvider.deviceCheck,
  );

  final auth = FirebaseAuthService();
  final analytics = InMemoryCrashAnalyticsService();

  runApp(
    AppFrameworkApp(
      authService: auth,
      analytics: analytics,
      config: const AppFrameworkConfig(
        appName: 'Catu Framework',
        appVersion: '0.0.1',
        appBuild: '1',
        supportEmail: 'support@yourdomain.com',
        copyrightNotice: 'Copyright © 2026 Catu Framework',
      ),
    ),
  );
}
```

### App Check Settings (Firebase Console)

1. Open Firebase Console → App Check.
2. Register your Android and iOS apps for App Check:
- Android: Play Integrity (prod), Debug (dev)
- iOS: DeviceCheck/App Attest (prod), Debug (dev)
3. For debug builds, capture the debug token from app logs and add it under App Check debug tokens.
4. Start in monitoring mode, then enforce gradually for:
- Firestore
- Cloud Functions
- Storage
5. App Check does not replace Auth. It protects backend resources from non-attested clients.

### Changes Needed in `catu_framework`

No mandatory core framework code changes are required.

Recommended integration pattern:
- Keep Firebase-specific code in host app files (`lib/auth/firebase_auth_service.dart`, `main.dart`).
- Continue using the framework contracts (`AuthService`, `AppState`, `AppFrameworkApp`).
- Optionally add a package-side Firebase adapter later if you want batteries-included auth.


## Integration Checklist

- Use `AppFrameworkApp` as entry point.
- Provide concrete `AuthService`.
- Provide concrete `CrashAnalyticsService`.
- Set `AppFrameworkConfig` values (name/version/build/support/copyright).
- Replace placeholder legal/support/feedback content.
- Add/adjust routes and menu actions for your app features.
- Apply icons to Android/iOS project.
- Run tests.

## Verification

From package root:

```bash
flutter test
```

From example app:

```bash
cd example
flutter run -d <device_id>
```
