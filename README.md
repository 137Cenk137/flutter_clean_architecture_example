# flutter_clean_architecture

A Flutter starter showcasing Clean Architecture with BLoC, functional error handling, Supabase auth, and dependency injection via GetIt.

## Overview

- **Architecture**: Presentation (BLoC) → Domain (Repository contracts) → Data (Remote data sources)
- **State management**: `flutter_bloc`
- **DI / Service Locator**: `get_it`
- **Remote backend**: `supabase_flutter`
- **Functional types**: `fpdart` (`Either` for error handling)
- **Config**: `flutter_dotenv` for environment variables
- **UI Theming**: Centralized in `lib/core/theme`

## Project Structure

```
lib/
  core/
    errors/               # Exceptions and Failures abstractions
    secrets/              # AppSecrets reading from .env
    theme/                # Palette and ThemeData
  features/
    auth/
      data/
        datasources/      # Supabase-powered remote data source
        repositories/      # Repository implementation mapping to Either<Failure, T>
      domain/
        repository/        # Repository contract (interfaces)
      presentation/
        bloc/              # AuthBloc, events, states
        pages/             # Login/Signup pages
        widgets/           # Reusable auth widgets
  dependency_injection.dart  # GetIt registrations and Supabase init
  main.dart                  # App bootstrap and MultiBlocProvider
```

## Clean Architecture Flow

- **Presentation**: `AuthBlocBloc` reacts to UI events and emits `AuthBlocState`.
- **Domain**: `AuthRepository` (interface) defines actions like `signUp` and `loginWithEmailAndPassword`.
- **Data**: `AuthRepositoryImpl` calls `AuthRemoteDataSource` (Supabase). Errors are mapped to `Failure` using `Either` from `fpdart`.

## Key Files

- `lib/dependency_injection.dart`: Initializes Flutter bindings, loads `.env`, initializes Supabase, registers GetIt factories/singletons for `SupabaseClient`, `AuthRemoteDataSource`, `AuthRepository`, and `AuthBlocBloc`.
- `lib/main.dart`: Sets up `MultiBlocProvider`, applies `AppTheme.darkTheme`, and shows `LoginPage`.
- `lib/core/theme/theme.dart`: Centralized app theming, including `InputDecorationTheme` for text fields.
- `lib/features/auth/data/datasources/auth_remote_date_source.dart`: Supabase auth calls for sign up and login.
- `lib/features/auth/data/repositories/auth_repository.dart`: Converts datasource results to `Either<Failure, String>`.
- `lib/features/auth/presentation/bloc/…`: BLoC definitions for events and states.

## Requirements

- Flutter SDK compatible with Dart `^3.9.0`
- A Supabase project

## Environment Setup

Create a `.env` file at project root with:

```
SUPABASE_URL=your_supabase_url
SUPABASE_API_KEY=your_supabase_anon_key
```

`AppSecrets` reads these via `flutter_dotenv`:

```
static String supabaseUrl = dotenv.env['SUPABASE_URL']!;
static String supabaseAnonKey = dotenv.env['SUPABASE_API_KEY']!;
```

## Install Dependencies

```bash
flutter pub get
```

## Run

```bash
flutter run
```

## Common Issues

- If you see input decoration/layout errors, ensure text fields are properly constrained (e.g., avoid placing a bare `TextFormField` directly inside a `Row` without `Expanded`).
- Ensure `.env` is present and loaded before `Supabase.initialize` (handled in `initDependency`).

## Testing

- Example widget test in `test/widget_test.dart`. Add unit tests around repositories and blocs as needed.

## License

MIT
