# Sartor Order Management (Tailoring MVP)

## Backend (Supabase)
1. Create a Supabase project
2. In SQL Editor, run files in this order:
   - `db/schema.sql`
   - `db/policies.sql`
   - `db/storage.sql`
   - `db/seed.sql`
3. Create an admin user account; set `profiles.role = 'admin'` for that user.

## Frontend (Flutter)
1. Ensure Flutter 3.22+ is installed
2. Configure environment values at build-time:
   - Web: `flutter build web --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
   - Mobile: add the same `--dart-define` flags to `run` or `build`
3. Run locally:
```
flutter pub get
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

## Notes
- Measurements are in inches.
- Services are admin-editable only; public can read.
- Orders support multiple services with quantities; totals computed via RPC.
