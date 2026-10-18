# Phases.md — Implementation Plan (FORGE)

**How to use:** Tell the AI: *"Do Phase X, Task X.Y only. Follow Rules.md. When done, tick the box and update Memory.md."*
Never ask for a whole phase at once if it has many tasks. Small chunks = fewer bugs.

Each phase has a **Done when** test. Don't start the next phase until it passes.

---

## Phase 0: Setup
- [x] 0.1 Create Flutter project, set app name and package id, Android only for now
- [x] 0.2 Add allowed packages, run `flutter analyze` clean
- [x] 0.3 Create folder structure from `Architecture.md`
- [ ] 0.4 Create Supabase project (dev), add URL + anon key via `--dart-define`
- [ ] 0.5 Initialize Supabase CLI folder (`supabase/migrations`, `supabase/functions`)
- [x] 0.6 Put the 6 docs in `/docs` and Stitch screenshots / HTML in `/design`

**Done when:** app runs on a phone showing a blank themed screen and connects to Supabase.

---

## Phase 1: Design System + App Shell
- [x] 1.1 Design tokens (`AppColors`, `AppText`, `AppSpacing`, radii) from `Design.md`
- [x] 1.2 Dark theme with green-black gradient background widget
- [x] 1.3 Shared widgets: `GlassCard`, `LimeButton` (filled + outline), `SectionHeader`, `ProgressRing`, `Chip`, `AppBottomNav` with raised center button
- [x] 1.4 go_router with 5 tab routes (Home, Plan, Log sheet, Mentor, Progress) using placeholder screens
- [ ] 1.5 A temporary "Design Gallery" screen showing every shared widget

**Done when:** Gallery screen looks like the Stitch design (glass, lime, Inter).

---

## Phase 2: Auth + Database Foundation
- [ ] 2.1 Migration 001: `profiles`, `mentor_settings`, RLS policies
- [ ] 2.2 Sign up / sign in screen (email + password; Google later if needed)
- [ ] 2.3 Auth state provider + route guards (logged out -> auth, not onboarded -> onboarding, else Home)
- [ ] 2.4 Settings: sign out

**Done when:** two test users can sign up and each can only see their own profile row.

---

## Phase 3: Onboarding
- [ ] 3.1 Migration 002: `routine_days`, `routine_exercises`
- [ ] 3.2 Step 1 screen (age, height, weight, goal)
- [ ] 3.3 Step 2 screen (experience slider + auto level, gym / home)
- [ ] 3.4 Step 3 screen (budget, foods eaten, foods avoided)
- [ ] 3.5 Step 4 screen (weekday pills, muscle groups, exercises, last weights)
- [ ] 3.6 Language preference + personality pick (UI only, lock logic comes in Phase 8)
- [ ] 3.7 Save everything, set `onboarded = true`, resume if app closes mid-way

**Done when:** a new user completes onboarding and the profile + routine rows exist in Supabase.

---

## Phase 4: Plan
- [ ] 4.1 Migration 003: `plans`
- [ ] 4.2 Edge Function `generate-plan` (with schema validation + calorie floor)
- [ ] 4.3 Plan screen: day selector, exercise list, meal card
- [ ] 4.4 Edit exercises (sets x reps, reorder, add / remove)
- [ ] 4.5 "Regenerate with AI" with confirm dialog
- [ ] 4.6 Rest-day recovery card

**Done when:** onboarding ends with an AI plan that follows the user's custom split and budget, and edits persist.

---

## Phase 5: Workout Logging
- [ ] 5.1 Migration 004: `workout_sessions`, `set_logs`
- [ ] 5.2 Local database for offline sets
- [ ] 5.3 Active Workout screen (one exercise at a time, set table)
- [ ] 5.4 "Last time" values from previous session
- [ ] 5.5 Rest timer pill (isolated widget)
- [ ] 5.6 Finish workout -> save session, update `last_weight_kg`
- [ ] 5.7 Background sync to Supabase

**Done when:** a full workout can be logged in airplane mode and syncs later.

---

## Phase 6: Daily Tracking + Real Home
- [ ] 6.1 Migration 005: `water_logs`, `food_logs`, `weight_logs`
- [ ] 6.2 Quick Log bottom sheet (center + button): Water, Protein, Meal, Weight, Workout note, Slip
- [ ] 6.3 Daily Missions card with live "3 of 5 done"
- [ ] 6.4 Home screen sections 1, 3, 4 (header, Today's Workout card with muscle silhouette, Missions)
- [ ] 6.5 Daily reset by local date; Weight weekly weigh-in prompt

**Done when:** logging water / protein / eggs updates Home instantly and survives app restart.

---

## Phase 7: Habits + Slip Log
- [ ] 7.1 Migration 006: `habits`, `habit_slips` (insert-only RLS)
- [ ] 7.2 Create challenge flow (e.g., No Sugar, 30 days)
- [ ] 7.3 Challenge card on Home with 30 dots + "I slipped"
- [ ] 7.4 Slip sheet (type + note) -> resets streak, saves permanent log
- [ ] 7.5 Streak calculation unit tests

**Done when:** slipping resets the streak but the entry stays in the database and cannot be deleted by the user.

---

## Phase 8: AI Mentor
- [ ] 8.1 Migration 007: `mentor_messages`, `mentor_challenges`, `usage_counters`
- [ ] 8.2 Edge Function `set-personality` with 30-day lock + Savage 18+ opt-in
- [ ] 8.3 Personality selection screen + locked state screen
- [ ] 8.4 Edge Function `mentor-chat` (context assembly, safety block, rate limit)
- [ ] 8.5 Chat screen (bubbles, suggestion chips, input)
- [ ] 8.6 Challenge card inside chat with "Mark done"
- [ ] 8.7 Mentor card on Home (daily line, cached once per day)
- [ ] 8.8 Safety tests: try insults / starving requests / distress messages and confirm safe responses

**Done when:** changing personality before 30 days is rejected by the server, and the mentor replies in the right tone and language using real user data.

---

## Phase 9: Progress + Weekly Report
- [ ] 9.1 Migration 008: `weekly_reports`
- [ ] 9.2 Progress screen: weight chart, strength chart, consistency calendar, water bars
- [ ] 9.3 Edge Function `weekly-report`
- [ ] 9.4 Weekly Report screen with Slip Log timeline
- [ ] 9.5 Empty states for new users

**Done when:** after a week of fake data, all charts and the report show correct numbers.

---

## Phase 10: Reminders, Polish, Release
- [ ] 10.1 Local notifications (workout time, water, evening check-in), reboot-safe
- [ ] 10.2 Loading / error / empty states checked on every screen
- [ ] 10.3 Small-screen and large-font checks
- [ ] 10.4 Settings: language, reminder times, About + disclaimer, **Delete my account and data**
- [ ] 10.5 RLS re-test with two users
- [ ] 10.6 App icon, splash, final app name
- [ ] 10.7 Create prod Supabase project, move secrets, build signed release APK / AAB
- [ ] 10.8 Privacy policy + Play Store listing draft

**Done when:** a friend can install the release build, onboard, train, log and chat without help.

---

## Later (not MVP)
Progress photos, AI push notifications, auto plan adjust, food database search, iOS, community. See `PRD.md` Out of Scope.
