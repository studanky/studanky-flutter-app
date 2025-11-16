# Studanky

## Environment configuration

Create `env_vars.json` from the provided template before running builds:

- Copy `env_vars.json.example` to `env_vars.json`.
- Fill in real values, e.g. `"MAPY_COM_API_KEY": "<your-key>"`.
- Keep `env_vars.json` out of version control (it is already gitignored).

When running or building manually, include `--dart-define-from-file=env_vars.json`, e.g. `flutter run --dart-define-from-file=env_vars.json`.

## Build (manual)

Use the provided env file and include obfuscation with split debug info:

- Android APK: `flutter build apk --verbose --obfuscate --split-debug-info=build/symbols --dart-define-from-file=env_vars.json`
- iOS IPA: `flutter build ipa --verbose --obfuscate --split-debug-info=build/symbols --dart-define-from-file=env_vars.json`

## build runner

`dart run build_runner build --verbose --delete-conflicting-outputs`

<!-- ## build dev

iOS: `flutter build ios --flavor dev -t lib/main_dev.dart --release`\
Android: `flutter build apk --flavor dev -t lib/main_dev.dart --release`

## build prod

iOS: `flutter build ios --flavor prod -t lib/main_prod.dart --release`\
Android: `flutter build apk --flavor prod -t lib/main_prod.dart --release` -->
