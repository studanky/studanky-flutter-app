# Architecture

The application uses feature-first modules with explicit presentation, data,
and domain boundaries. New code follows the layout below; imports point to the
file that owns a symbol rather than to compatibility barrels.

```text
lib/
├── core/                         # Cross-feature infrastructure and UI tokens
└── features/<feature>/
    ├── data/
    │   ├── repositories/         # Data orchestration and cache policy
    │   └── services/             # HTTP, storage, plugin and platform adapters
    ├── entities/                 # Immutable feature/domain models
    ├── presentation/
    │   ├── controllers/          # UI state and interaction orchestration
    │   ├── services/             # Stateless presentation action coordinators
    │   ├── views/                # Page/sheet composition and immutable view DTOs
    │   └── widgets/              # All feature-local UI building blocks
    └── providers/                # Concrete Riverpod providers/notifiers only
```

Feature-root Dart files are public entrypoints that are consumed by another
feature or the router (for example `map_page.dart`, `map_page_content.dart`, and
`spring_detail_overlay.dart`). Feature-local widgets do not live in a second
root `widgets/` directory. This placement rule is enforced by
`test/architecture/feature_structure_test.dart`.

## Dependency rules

- Views render immutable state snapshots and forward callbacks. They do not
  fetch data or read mutable controllers as state without a subscription.
- Presentation controllers depend on repository/service interfaces. Platform
  plugins and HTTP clients stay in data services.
- Repositories are the source of truth for caching, mapping, and retry policy.
- Provider files do not re-export state, services, or repositories. Callers
  import each dependency from its owning file so architectural coupling stays
  visible.
- Prefer one public production class per file. Small private widgets and record
  types may stay next to their sole owner.
- Extract reusable or calculation-heavy logic into pure functions and cover it
  with unit tests; keep route/widget tests for integration behavior.

The existing `dtos/`, `mappers/`, and repository files directly below `data/`
are valid feature data-layer components. Move them only when a feature gains
enough files to make an additional subdirectory useful; directory depth should
serve navigation, not become ceremony.
