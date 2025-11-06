# Repository Guidelines

## Project Structure & Module Organization
- `lib/core/` contains shared navigation, Riverpod providers, styles, and reusable widgets.
- `lib/features/<feature>/` is domain-first and splits into `data/`, `models/`, `providers/`, and `widgets/`; mirror this pattern for new features (e.g., `lib/features/water_quality/data/...`).
- `lib/l10n/` holds generated localization delegates configured via `l10n.yaml`, while assets live in `assets/` and are surfaced through `pubspec.yaml`.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies after `pubspec.yaml` changes.
- `dart run build_runner build --delete-conflicting-outputs` regenerates `freezed`/`json_serializable` output; run whenever annotated models change.
- `flutter analyze` enforces the rules in `analysis_options.yaml`; resolve warnings before pushing.
- `flutter test [--coverage]` runs the unit and widget suite. Use `flutter run -d <device>` for manual checks.

## Coding Style & Naming Conventions
- Analyzer rules layer `flutter_lints` with extras like `always_use_package_imports`, `prefer_single_quotes`, and `require_trailing_commas`; let analyzer output guide fixes.
- Use two-space indentation, `PascalCase` for types, `camelCase` for members, and suffix Riverpod providers with `Provider` (e.g., `mapSearchProvider`). Run `dart format lib test` before committing; do not hand-edit generated `.g.dart`/`.freezed.dart` files.

## Testing Guidelines
- Place tests under `test/<feature>/` mirroring `lib/features/`. Favor widget tests for UI seams and provider tests with `ProviderContainer`.
- Name `group`/`test` blocks descriptively (e.g., `MapSearchRepository fetches nearby springs`) and stub network or location access to keep runs deterministic.
- Ship at least one automated test with every feature; refresh golden files only for intentional UI changes.

## Commit & Pull Request Guidelines
- Use Conventional Commits (`feat:`, `fix:`, `chore:`) as in the history (`feat: app error widget`). Keep each commit focused and written in the imperative.
- Pull requests need a summary, linked issue, verification notes (`flutter test`, `flutter analyze`), and screenshots or screen recordings for UI updates. Confirm generated files are current and call out any follow-up tasks.

## Localization & Assets
- Update ARB files in `lib/l10n/arb/` when adding strings, then regenerate code with `flutter gen-l10n` or `dart run build_runner build`.
- Reference assets via `pubspec.yaml`; keep vectors optimized (e.g., `assets/studanka_point.svg`) and describe new assets in the pull request.
