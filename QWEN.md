# Pettix - Pet Care App

## Project Overview

**Pettix** is a Flutter-based mobile application for pet care, social networking, and pet adoption. It combines a social feed for pet owners with a comprehensive pet adoption platform, featuring a multi-step application process, chat functionality, and user profiles.

### Key Features

- **Authentication** — Email/OTP registration, login, Google sign-in, Apple sign-in, forgot-password flow
- **Social Feed** — Posts, comments (nested/replies), likes, user posts, saved posts, post reporting
- **Pet Adoption** — Browse pets, view detailed profiles (gallery, medical history, description), multi-step adoption application (6 steps)
- **Chat** — Messaging between users (BLoC skeleton, minimal implementation)
- **Notifications** — Tabbed notification system (all vs. adoption-specific)
- **My Pets** — Pet management for registered users
- **Profile** — User profile view and editing
- **Adoption History** — Track and review past adoption applications
- **Clinics & Store** — Pet-related services and shopping (planned/in-progress)
- **Help & Support** — FAQ, contact support, report problems, send feedback
- **Legal** — About, privacy policy, terms & conditions, refund policy

### Architecture

**Pattern:** Clean Architecture — Domain → Data → Presentation per feature.

```
lib/
├── config/          # DI (GetIt/Injectable), router (go_router), env, use case base classes
├── core/            # Shared utilities, themes, design system, constants, services, widgets
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
│   ├── entity/       # Pure Dart entities (extend Equatable)
│   ├── repos/        # Abstract repository interfaces
│   └── usecases/     # Single-responsibility use cases (extend lib/config/usecases)
└── views/
    ├── bloc/         # BLoC files: *_bloc.dart, *_event.dart, *_state.dart
    ├── view/         # Full-screen views with body widget only
    └── widgets/      # View-specific extracted widgets
```

### Technology Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter (SDK >=3.7.2 <4.0.0) |
| **State Management** | flutter_bloc (BLoC pattern) |
| **Dependency Injection** | get_it + injectable |
| **Networking** | Dio (with interceptors) |
| **Routing** | go_router |
| **Localization** | easy_localization (en, ar) |
| **Logging** | Talker (unified logger with BLoC & Dio integration) |
| **Caching** | shared_preferences, flutter_secure_storage |
| **Firebase** | firebase_core, firebase_auth, firebase_messaging |
| **Auth Providers** | Google Sign-In, Sign in with Apple, Email OTP (Twilio) |
| **UI/Design** | google_fonts, flutter_svg, cached_network_image, flutter_screenutil, flex_color_scheme |
| **Code Generation** | build_runner, envied, injectable_generator |

## Building and Running

### Prerequisites

- Flutter SDK >=3.7.2
- Dart SDK >=3.7.2
- Firebase project configured (config/development & config/production)
- `.env` file configured at `lib/config/env/.env`

### Commands

```bash
# Run development flavor
flutter run -t lib/main/main_development.dart --flavor development

# Run production flavor
flutter run -t lib/main/main_production.dart --flavor production

# Build APK (development)
flutter build apk -t lib/main/main_development.dart --flavor development

# Build APK (production)
flutter build apk -t lib/main/main_production.dart --flavor production

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Analyze code
flutter analyze

# Format code
flutter format .

# Regenerate code (DI, env, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch and regenerate continuously
dart run build_runner watch --delete-conflicting-outputs

# Generate flavor configurations
flutter pub run flutter_flavorizr

# Generate app icons
flutter pub run flutter_launcher_icons
```

### Flavors

The app supports two flavors:

| Flavor | App Name | Android Application ID | iOS Bundle ID |
|--------|----------|------------------------|---------------|
| **development** | Pettix Dev | com.pettix.up | com.pettix.up |
| **production** | Pettix | com.pettix.up | com.pettix.up |

## Development Conventions

### Responsive Design

All sizes use `flutter_screenutil` with design reference `360 × 760` dp. Use `.w`, `.h`, `.sp` extensions:

```dart
SizedBox(width: 16.w, height: 8.h)
Text('Hello', style: TextStyle(fontSize: 14.sp))
```

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

### Dependency Injection

Uses `get_it` + `injectable`. All injectables are annotated with `@injectable`, `@lazySingleton`, or `@singleton`. The generated file is `lib/config/di/di.config.dart`. Module registrations (Dio, Talker, ICacheManager) live in `lib/config/di/di.dart`.

### Routing

`go_router` is configured in `lib/config/router/app_router.dart`. All route path strings are constants in `lib/config/router/routes.dart`. The router starts at `/splash`.

### Environment Variables

Secrets live in `lib/config/env/.env` (git-ignored). The `envied` package generates `lib/config/env/env.g.dart` (obfuscated) from this file. Required variables:

- `BASE_URL`
- `API_KEY`
- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`
- `TWILIO_SERVICE_SID`

Run `build_runner` after changing `.env`.

### Error Handling

Use cases return `Either<Failure, T>` from `dartz`. `Failure` and `DioFailure` are defined in `lib/data/network/failure.dart`. BLoCs map `Left(failure)` → error states.

### Networking

- Dio instance created in `lib/data/network/dio_factory.dart` (30s timeout)
- Interceptors: Talker logger + Performance interceptor + custom auth headers
- Endpoints in `lib/core/constants/api_endpoints.dart`

### Logging

Talker is the unified logger. All BLoC events/states are automatically logged via `TalkerBlocObserver`.

### Localization

Supports English (`en`) and Arabic (`ar`) with fallback to English. Translation files are in `assets/translations/`.

## Project Structure

### Core Directories

| Directory | Purpose |
|-----------|---------|
| `lib/config/` | App configuration: DI, routing, environment, base use cases |
| `lib/core/` | Shared utilities, constants, themes, services, common widgets |
| `lib/data/` | Data layer: network (Dio), caching (SharedPrefs/SecureStorage) |
| `lib/features/` | Feature modules (17 features currently) |
| `lib/main/` | Entry points for different flavors |
| `config/` | Firebase configurations per flavor/environment |
| `assets/` | Static assets: images, icons, fonts, translations, notification keys |
| `test/` | Unit and widget tests |

### Feature List

1. `adoption` — Pet browsing, profiles, multi-step adoption form
2. `adoption_history` — Track past adoption applications
3. `auth` — Login, signup, OTP, password reset flows
4. `bottom_bar` — Main navigation bottom bar
5. `chat` — Messaging (skeleton)
6. `clinics` — Pet clinic services (in-progress)
7. `help_support` — FAQ, contact, feedback
8. `home` — Social feed, posts, comments
9. `legal` — About, privacy, terms, refund policy
10. `my_pets` — User pet management
11. `notification` — Push notification display
12. `on_boarding` — Initial app onboarding screens
13. `profile` — User profile management
14. `select_language` — Language selection
15. `side_menu` — Custom drawer with user profile
16. `splash` — App splash screen
17. `store` — Pet store (in-progress)

## Key Files

| File | Description |
|------|-------------|
| `lib/main/main_common.dart` | Bootstrap sequence: Firebase → SharedPrefs → DI → Cache → Notifications → runApp |
| `lib/config/di/di.dart` | GetIt/Injectable module registrations |
| `lib/config/router/routes.dart` | All route path constants |
| `lib/config/env/.env` | Environment variables (git-ignored) |
| `pubspec.yaml` | Dependencies, flavor config, flutter icons |
| `analysis_options.yaml` | Flutter lints configuration |

## Notes

- Auth state is persisted via `SharedPrefsHelper` (`isSignedUp`, `isLoggedIn`)
- Credentials stored in `SecureStorageHelper`
- The `AdoptionBloc` is reset on each new adoption application flow to prevent data leakage
- Background notifications handled via `FirebaseMessaging.onBackgroundMessage`
- Design reference: `360 × 760` dp for screen util calculations
