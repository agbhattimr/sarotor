## Quick orientation

This Flutter app is a Tailoring MVP that uses Supabase as the backend and Flutter + Riverpod for the frontend. Primary source files to inspect for behavior and examples are under `lib/` and SQL schema/seed files under `db/`.

Key technologies
- Flutter (>=3.22), Dart SDK >=3.3
- Supabase (supabase_flutter)
- State: flutter_riverpod (StateNotifierProvider, FutureProvider, Provider)
- Routing: go_router (router configured in `lib/router.dart`)
- Data models: freezed + json_serializable (run codegen with build_runner)

Architecture highlights (read these files to understand flows)
- `lib/main.dart` — Supabase initialization and app entry. Note a Supabase URL/anon key exists here and README documents use of `--dart-define` for builds.
- `lib/router.dart` — Central routing and auth gate. The router redirect checks Supabase session, `profiles` row and `measurements` to decide navigation.
- `lib/services/` — Repository layer. `supabase_repo.dart` centralizes common Supabase queries; other repos (e.g. `measurement_repository.dart`, `service_repository.dart`) encapsulate domain logic and exceptions.
- `lib/providers/` — Riverpod providers. Example patterns: `profileProvider` (FutureProvider), `cartProvider` (StateNotifierProvider with `CartNotifier`).
- `lib/features/*` — Feature folders with UI screens. Typical file naming: `<feature>_screen.dart`. Example: `lib/features/orders/new_order_screen.dart` demonstrates the full order flow: create order, insert items, call RPC `update_order_total`.
- `lib/models/` — Data models, many generated (`*.freezed.dart`, `*.g.dart`). Always run code generation after model changes.
- `db/` — SQL schema, policies, seed files. README prescribes import order: `schema.sql`, `policies.sql`, `storage.sql`, then `seed.sql`.

Developer workflows & commands (concrete)
- Install deps and run locally (mobile/web):

  flutter pub get
  flutter run --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<anon>

- Build web with environment values:

  flutter build web --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<anon>

- Generate code (models, freezed, json_serializable):

  flutter pub run build_runner build --delete-conflicting-outputs

- Run tests:

  flutter test

Project-specific conventions & patterns
- Supabase client access: use `Supabase.instance.client` or inject a `SupabaseClient` into repository classes. The codebase commonly wraps client access in repo classes like `SupabaseRepo` and `MeasurementRepository` (see `lib/services/`).
- Extensions: there is an extension on `SupabaseClient` in `measurement_repository.dart` for convenient access (`client.measurements`). Search for `extension SupabaseClient` to find similar helpers.
- Providers: use Riverpod providers for local/global state. UI code typically uses `ref.watch(...)` or `ConsumerWidget`/`ConsumerStatefulWidget` and mutates state via notifiers (`CartNotifier`). See `lib/providers/cart_provider.dart` for the cart API surface.
- Routing & auth: Router redirect logic in `lib/router.dart` determines initial navigation and enforces profile/measurement completion. Avoid manually pushing routes for session-related redirects — router handles it.
- Database RPC usage: business logic sometimes lives in DB functions. Example: RPC `update_order_total` is called by `SupabaseRepo.recalcOrderTotal` when finalizing orders. Look in `db/` for RPC definitions.

Integration points & sensitive data
- Database: SQL migrations and policies live in `db/`. When changing DB structure, update the SQL files and seed data accordingly.
- Supabase RPCs and triggers: used for aggregated logic (order totals). Check `db/` scripts for their definitions.
- Environment secrets: Recommended pattern in README is to pass `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define`. Note: `lib/main.dart` currently contains hard-coded values — treat them as present but prefer `--dart-define` when running locally or CI.

Files to open first (fast tour)
- `lib/main.dart` — app entry and Supabase init
- `lib/router.dart` — routing, auth, and guards
- `lib/services/supabase_repo.dart` — canonical API for Supabase interactions
- `lib/providers/cart_provider.dart` — illustrates StateNotifier & cart calculations
- `lib/features/orders/new_order_screen.dart` — example full flow that uses repos & providers
- `db/schema.sql`, `db/policies.sql`, `db/seed.sql` — database structure and seed data

When editing models or providers
- Modify `lib/models/*.dart` then run build_runner. Generated files are checked into the repo (e.g. `*.freezed.dart`, `*.g.dart`). Keep generated files up-to-date.

What not to change without CI/manual verification
- Database column names and RPC signatures (breaking these will cause runtime PostgREST errors). If you update SQL or RPC names, update all repository calls and re-run seeds locally.
- Public API shapes returned by Supabase queries — many UI widgets assume particular field names (`id`, `profile_name`, `price_cents`, `total_cents`). Use casts/`maybeSingle()` patterns already used throughout the repo.

If anything here is unclear or you want more detail (examples, tests, or CI steps), tell me which area to expand and I will iterate.
