<!-- SPDX-License-Identifier: Apache-2.0 -->
<!-- Copyright (c) 2026 The Khatu Family Trust -->
<!--
File: docs/Getting Started.md
File Version: 1.0.0
Framework : Complete App Topology Utility (Catu) Framework
Author: Neil Khatu
Copyright (c) 2026 The Khatu Family Trust
-->

![Catu Framework](https://raw.githubusercontent.com/nkhatu/catu_framework/main/assets/Catu.png)

# Getting Started with Complete App Topology Utility (Catu) Framework

This guide helps you move from first setup to your first custom feature with a clean, beginner-friendly workflow.

## 1. Start Here

- Installation and environment setup: [Developer Install Guide](./Developer%20Install%20Guide.md)
- Architecture and wiring details: [Catu Framework : How To](./Catu%20Framework%20:%20How%20To.md)
- Dependency injection guide: [Dependency Injection](./Dependency%20Injection.md)
- Repository: [nkhatu/catu_framework](https://github.com/nkhatu/catu_framework)

## 2. Why This Works for Beginners

- It removes blank-project confusion by giving you a complete scaffold from day one.
- It separates concerns clearly: routing, state, auth, theme, analytics, and page shell are pre-structured.
- It demonstrates real app mechanics instead of hiding everything behind generators.
- It gives safe defaults (`InMemoryAuthService`, sample routes/pages) so you can learn flow before backend integration.
- It includes non-feature essentials (support, privacy, feedback, settings), so you learn full app delivery, not only UI screens.

## 3. Project Structure

```text
catu_framework/
├─ lib/
│  ├─ src/
│  │  ├─ framework/          # AppFrameworkApp + app-level composition
│  │  ├─ routing/            # Route constants and route wiring
│  │  ├─ app_state/          # Session/bootstrap/auth lifecycle state
│  │  ├─ auth/               # Auth contracts + pages + in-memory adapter
│  │  ├─ home/               # Home screen
│  │  ├─ shell/              # Shared page shell, header, footer, menu handling
│  │  ├─ settings/           # Theme/settings/crash log panel
│  │  ├─ analytics/          # Crash analytics abstraction + handlers
│  │  ├─ legal/              # Privacy/copyright pages
│  │  ├─ support/            # Support page
│  │  └─ feedback/           # Feedback page
│  └─ catu_framework.dart    # Public exports
├─ docs/                     # Integration and setup documentation
├─ example/                  # Runnable sample app
├─ assets/                   # Brand assets and generated icon source/artifacts
└─ scripts/                  # Automation scripts (icon generation/application)
```

## 4. Connect a New Feature

Use this pattern each time you add a feature page.

1. Create a feature page widget.

```dart
// lib/src/feature/tasks/tasks_page.dart
import 'package:flutter/material.dart';
import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Tasks',
      appState: appState,
      body: const Center(child: Text('Tasks feature')),
    );
  }
}
```

2. Add a route constant in `lib/src/routing/app_routes.dart`.

```dart
static const tasks = '/tasks';
```

3. Register the route in `lib/src/framework/app_framework.dart`.

```dart
AppRoutes.tasks: (_) => TasksPage(appState: _appState),
```

4. Add navigation access (menu/action/button) using existing shell/menu patterns.
5. If needed, add service interfaces first, then inject concrete implementations in `main()` or host app composition.
6. Add tests for route behavior and feature logic before merging.

## 5. Best Practices

- Keep business logic in state/services, not in widgets.
- Use dependency injection for all external providers (auth, analytics, APIs).
- Add routes centrally and keep names consistent.
- Reuse `AppPageShell` for layout and menu consistency.
- Fail gracefully: surface user-safe messages, log technical details via analytics.
- Keep docs updated when public behavior or setup changes.

## 6. Contribution and Quality

Before you commit:

- Run `flutter analyze`
- Run `flutter test`
- Verify app startup from `example/`
- Keep changes focused and atomic
- Write clear commit messages tied to user-visible outcomes

## 7. How to Contribute

1. Sync latest code.

```bash
git checkout main
git pull origin main
```

2. Create a feature branch.

```bash
git checkout -b codex/<short-feature-name>
```

3. Implement changes and run checks.

```bash
flutter analyze
flutter test
```

4. Commit and push.

```bash
git add -A
git commit -m "feat: add <feature>"
git push origin codex/<short-feature-name>
```

5. Open a pull request with:
- What changed
- Why it changed
- How it was tested
- Any migration/setup notes

6. Address review feedback quickly and keep the branch rebased/updated.

## 8. Next Steps

- Start with one simple feature (for example: `Tasks` or `Notifications`).
- Add route + page + menu entry.
- Add one service abstraction and one test.
- Repeat the same pattern for each new feature to keep architecture clean.
