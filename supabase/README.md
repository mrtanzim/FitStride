# FORGE Supabase Migrations

Run these migrations **in order** using the Supabase SQL Editor at https://supabase.com/dashboard.

## Running Order

### 001 — Profiles
File: `migrations/20261018_profiles.sql`

Creates the `public.profiles` table linked to `auth.users`.

### 002 — Mentor Settings
File: `migrations/20261018_002_mentor_settings.sql`

Creates the `public.mentor_settings` table. Note: updates are done via Edge Function (service role) only.

### 003 — Routine
File: `migrations/20261018_003_routine.sql`

Creates `public.routine_days` and `public.routine_exercises` tables.

### 004 — Tracking
File: `migrations/20261018_004_tracking.sql`

Creates `public.water_logs`, `public.food_logs`, and `public.weight_logs` tables for daily tracking.

## How to Run

1. Open https://supabase.com/dashboard → your project → SQL Editor
2. Paste each migration file's contents in order
3. Click "Run"
4. Verify no errors before proceeding to the next migration
