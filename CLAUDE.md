# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run development flavor
flutter run -t lib/main/main_development.dart --flavor development

# Run production flavor
flutter run -t lib/main/main_production.dart --flavor production

# Build APK (development)
flutter build apk -t lib/main/main_development.dart --flavor development

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Analyze code
flutter analyze

# Regenerate code (DI, env, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch and regenerate continuously
dart run build_runner watch --delete-conflicting-outputs
```

## Architecture

This is a Flutter pet care app (Pettix) using Clean Architecture with BLoC state management.

### Entry Points

Two flavors share a common bootstrap in [lib/main/main_common.dart](lib/main/main_common.dart):
- `lib/main/main_development.dart` — passes `AppConfig.dev`
- `lib/main/main_production.dart` — passes `AppConfig.prod`

Startup sequence: Firebase init → SharedPrefs init → `configureDependencies()` (GetIt/Injectable) → `ICacheManager.init()` → `runApp`.

## Architecture Overview

**Pattern:** Clean Architecture — Domain → Data → Presentation per feature.

```
lib/
├── config/          # DI, router, env, use case base classes
├── core/            # Shared utilities, themes, design system
├── data/            # Network (Dio), caching (SharedPrefs + SecureStorage)
├── features/        # Feature modules (each has data/, domain/, views/)
└── main/            # Entry points (main_development.dart, main_production.dart)
```

### Feature Module Structure
Each feature follows this layout:
```
features/<name>/
├── data/
│   ├── models/       # JSON models (extend domain entities)
│   ├── repos/        # Repository implementations
│   └── sources/      # Remote/local data sources
├── domain/
│   ├── entity/       # Pure Dart entities extend Equatable
│   ├── repos/        # Abstract repository interfaces
│   └── usecases/     # Single-responsibility use cases extends lib/config/usecases
└── views/
    ├── bloc/         # BLoC files: *_bloc.dart, *_event.dart, *_state.dart
    ├── view/         # Full-screen views with body widget only
    └── widgets/      # View-specific extracted widgets and body widgets for views can be a folder for each view if needed
```

### Dependency Injection

Uses `get_it` + `injectable`. All injectables are annotated with `@injectable`, `@lazySingleton`, or `@singleton`. The generated file is `lib/config/di/di.config.dart`. Module registrations (Dio, Talker, ICacheManager) live in `lib/config/di/di.dart`. To find a registered dependency, check that file and `di.config.dart`.

### Routing

`go_router` is configured in [lib/config/router/app_router.dart](lib/config/router/app_router.dart). All route path strings are constants in `lib/config/router/routes.dart`. The router starts at `/splash`. Auth guard logic exists in `lib/config/router/guards.dart` (the global redirect is currently commented out; navigation happens imperatively via `context.go`/`context.push`).

### Environment Variables

Secrets live in `lib/config/env/.env` (git-ignored). The `envied` package generates `lib/config/env/env.g.dart` (obfuscated) from this file. Required variables: `BASE_URL`, `API_KEY`, `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_SERVICE_SID`. Run `build_runner` after changing `.env`.

### Error Handling

Use cases return `Either<Failure, T>` from `dartz`. `Failure` and `DioFailure` are defined in `lib/data/network/failure.dart`. BLoCs map `Left(failure)` → error states.


### Colors & Typography

```dart
AppColors.current.primary       // semantic colors (30+ properties)
TextStyles.custom(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.current.primaryText)
TextStyles.medium               // pre-defined: small(12), medium(16), large(20), extraLarge(24)

```

### Spacing Constants
```dart
PaddingConstants.horizontal16   // EdgeInsets.symmetric(horizontal: 16)
SizedBoxConstants.vertical16    // SizedBox(height: 16)
RadiusConstants.r12             // BorderRadius.circular(12)
```

## Networking

- Dio instance created in `lib/data/network/dio_factory.dart` (30s timeout)
- Interceptors: Talker logger + Performance interceptor + custom auth headers
- Endpoints in `lib/core/constants/api_endpoints.dart`

## Logging

Talker is the unified logger. Use the instance from `lib/core/utils/logger.dart`.
All BLoC events/states are automatically logged via `TalkerBlocObserver`.

## Responsive Design

All sizes use `flutter_screenutil`. Use `.w`, `.h`, `.sp` extensions:

```dart
SizedBox(width: 16.w, height: 8.h)
Text('Hello', style: TextStyle(fontSize: 14.sp))
```

Design reference: `360 × 760` dp.

### Key Features

- **auth** — Email/OTP registration, login, Google sign-in, forgot-password flow. Auth state is persisted via `SharedPrefsHelper` (`isSignedUp`, `isLoggedIn`) and credentials in `SecureStorageHelper`.
- **home** — Social feed with posts, comments (nested/replies), likes, and post reporting.
- **adoption** — Multi-step pet adoption form (6 steps), pet profiles, and application tracking. Uses Twilio for OTP/SMS.
- **chat** — Chat list and chat page (BLoC skeleton, currently minimal).
- **notification** — Tabbed notification page (all vs. adoption).
- **side_menu** — Custom drawer with user profile header.
- **profile** *(planned)* — User profile view and edit. Will be connected to the adoption feature so that adoption application forms can be pre-filled with profile data.
- **settings** *(planned)* — App settings (language, theme, account management). Will integrate with profile and adoption features to provide a unified user identity across the app.
