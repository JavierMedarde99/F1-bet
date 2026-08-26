# AGENTS.md — F1-Bet

## Stack
Flutter (Dart) + Supabase (anon key, no Supabase Auth) + OpenF1 API.
Design system "Grid Dynamic" defined in `DESIGN.md`, implemented in `lib/utils/theme.dart`.

## Commands
```sh
flutter pub get              # resolve dependencies
flutter analyze              # zero errors expected; ~50 info lints (file naming, print) are baseline
dart format --output=none --set-exit-if-changed .   # CI format gate — must exit 0
dart run tool/hash_password.dart <password>          # generate bcrypt hash for new users
flutter build web --debug    # fast local web verification (no Android SDK needed)
flutter build apk --release  # full APK (requires Android SDK)
```

## .env
Required at runtime and for asset bundling. Two vars:
- `DATABASE_URL` — Supabase project URL
- `ANON_KEY` — Supabase anon/public key

`.env` is gitignored. `.env.example` exists as template. CI generates it from GitHub Actions secrets before building.

## CI gotcha
`.github/workflows/ci.yml ` has a **trailing space in the filename** — GitHub does not detect it. Renaming it would activate checks that currently fail (no `test/` directory, 15 files fail `dart format`). Fix the name + format the repo + add a placeholder test before renaming.

## Architecture
- `lib/main.dart` — entry point, inits Supabase, shows LoginPage
- `lib/utils/connectionDataBase.dart` — all Supabase queries (login, bets, ranking, save results)
- `lib/utils/f1Api.dart` — OpenF1 HTTP client (meetings, sessions, race results)
- `lib/utils/theme.dart` — Grid Dynamic design tokens + `getGridTheme()` ThemeData
- `lib/utils/constants.dart` — driver IDs (Alonso=14, Sainz=55), API URLs
- `lib/components/` — reusable widgets (FormLogin, FormBet, cardPage, listRaces, etc.)
- `lib/models/` — data classes (Circuit, ResultsRaces, ResultsUser, RankingUser, etc.)
- `supabase/` — SQL migration scripts (RLS policies, results table)
- `DESIGN.md` — full Grid Dynamic spec (colors, typography, layout, components)

## Key DB tables
- `users_f1`: `id`, `user_name`, `password` (bcrypt hash)
- `bets`: `user_id`, `meeting_bet`, `alonso_position`, `sainz_position`
- `results`: `meeting_bet` (PK), `alonso_position`, `sainz_position` — populated automatically by app

## Workflow conventions
- Branches: `fix/<issue>-<desc>` for bugs, `feat/<issue>-<desc>` for features
- PRs target `main`; design-system PRs are stacked (`feat/33` → `feat/35` → `feat/47`)
- Never merge your own PRs unless asked
- After merging, execute any new SQL from `supabase/*.sql` manually in Supabase SQL Editor
