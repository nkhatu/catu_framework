/// SPDX-License-Identifier: Apache-2.0
/// Copyright (c) 2026 The Khatu Family Trust
/// ---------------------------------------------------------------------------
/// lib/src/home/home_page.dart
/// ---------------------------------------------------------------------------
///
/// Purpose:
/// - Defines home page module.
/// Architecture:
/// - Layered Flutter architecture with explicit UI/state/service boundaries.
/// File Version: 1.3.0
/// Framework : Core App Tech Utilities (Catu) Framework
/// Author: Neil Khatu
///

library;

import 'package:flutter/material.dart';

import '../app_state/app_state.dart';
import '../shell/page_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.appState, required this.appName});

  final AppState appState;
  final String appName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppPageShell(
      title: appName,
      appState: appState,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Image.asset(
                    'assets/Catu.png',
                    package: 'catu_framework',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Catu Framework',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Text('Purpose', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Catu Framework is designed to help first-time Flutter developers '
                'accelerate the creation of their first mobile app. It provides a '
                'clean starting architecture and essential scaffolding so beginners '
                'can focus on learning and shipping, instead of spending days on '
                'boilerplate setup.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text('Usage', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Use Catu Framework as a foundation for Android and iOS apps. Start '
                'with the built-in authentication pages, app shell, routing, theme '
                'management, settings, and legal/support pages. Then replace demo '
                'services with your real backend integrations and customize the UI, '
                'branding, and business features for your app.',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
