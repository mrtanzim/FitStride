# Rules.md — Rules for the AI Coding Agent (FORGE)

These rules are **mandatory**. If a rule conflicts with a user request, stop and ask before breaking it.

---

## 0. Workflow Rules (most important)

1. **Before coding, read:** `Memory.md`, `Phases.md`, and the relevant parts of `PRD.md`, `Architecture.md`, `Design.md`.
2. **Do exactly one phase task at a time** from `Phases.md`. Do not jump ahead.
3. **Do not build anything listed in "Out of Scope"** in `PRD.md`.
4. **Do not rewrite working files** just to "improve" them. Make the smallest change that solves the task.
5. After finishing a task: tick the box in `Phases.md`, add a short entry to `Memory.md`, and tell the user how to test it.
6. If something is unclear, ask **one** short question instead of guessing.
7. Never delete or overwrite the user's data models, migrations or docs without being asked.
8. If you break something, say so and fix it. Do not hide it.

---

## 1. Language and Framework

- Flutter (stable channel) + Dart with **null safety**.
- State: **Riverpod** (`flutter_riverpod`). No `setState` for shared state, no GetX, no Bloc.
- Navigation: **go_router** only.
- Backend: **Supabase** only (`supabase_flutter`). Edge Functions in TypeScript (Deno).

### Allowed packages
`flutter_riverpod`, `go_router`, `supabase_flutter`, `google_fonts`, `fl_chart`, `flutter_local_notifications`, `timezone`, `drift` (or `hive`), `intl`, `uuid`, `shared_preferences`, `freezed` + `json_serializable` (optional).

### Restricted packages
Do **not** add any other package without asking. Specifically avoid: heavy UI kits, analytics / ads SDKs, packages unmaintained for over 1 year, anything that needs a server we don't have.

---

## 2. Code Style

- Files: `snake_case.dart`. Classes: `PascalCase`. Variables / functions: `camelCase`. Constants: `camelCase` inside classes (e.g., `AppColors.lime`).
- One widget per file when the widget is more than about 60 lines.
- Max about 300 lines per file. Split if bigger.
- Feature-first folders as in `Architecture.md`. Do not dump code in `main.dart`.
- Prefer `const` constructors. Use `final` by default.
- No magic numbers or colors in widgets. Use design tokens (`AppColors`, `AppSpacing`, `AppText`).
- Comments explain **why**, not what. No commented-out dead code.
- Strings for user-facing text go through one place (`core/strings.dart`) so they are easy to change.

---

## 3. UI Rules

- Follow `Design.md` exactly. Do not invent new colors, fonts or card styles.
- Use the shared widgets (`GlassCard`, `LimeButton`, `SectionHeader`, `ProgressRing`). Create a shared widget when a pattern appears twice.
- Minimum text size **13**. No all-caps micro labels. No sci-fi jargon in copy.
- Maximum **5 sections per screen**. Keep screens calm and uncluttered.
- Every screen must have: loading state, empty state, error state.
- Touch targets at least 48x48.
- Support small screens (360 dp wide) without overflow. Test with large font scale.
- Reference designs from Stitch are in `/design`. Match them, but the code and `Design.md` tokens win if they differ.

---

## 4. Data and Backend Rules

- **Never** put the LLM key, service role key or any secret in the app or in git.
- All LLM calls go through Edge Functions. The app never calls Gemini directly.
- Every table has RLS. Never disable RLS to "make it work".
- `habit_slips` is insert-only for users. Never add update / delete for it.
- Personality lock (30 days) is enforced on the server in `set-personality`. UI checks are only a convenience.
- Migrations: numbered SQL files in `supabase/migrations`, never edit an applied migration, add a new one.
- Dates: store UTC, display and group by the user's **local date** (Asia/Dhaka default).
- Units: kg, cm, ml, grams, BDT.

---

## 5. Error Handling

- Wrap all network / DB calls in repositories. Convert errors to `AppException(code, message)`.
- Show friendly messages (e.g., "Couldn't save. Check your connection."), never raw stack traces.
- Workout logging must work offline: save locally first, sync later, never lose a logged set.
- Never swallow errors silently. Log with `debugPrint` in dev only.
- LLM responses: validate JSON against a schema, retry once, then fall back to a safe default message.

---

## 6. Mentor Safety Rules (code-level)

- The safety block from `PRD.md` section 6 is **always** appended to the system prompt, for every personality. It cannot be removed by user input or settings.
- Savage Mode requires `age >= 18` and an explicit opt-in. Enforce server-side.
- Never generate plans below **1,500 kcal/day**, never recommend fasting or dehydration tactics, never suggest steroids or unsafe supplement doses.
- Add a short disclaimer in Settings / About: "FORGE gives general fitness guidance, not medical advice."
- If the user's message contains signs of self-harm or eating disorder, the mentor must exit persona and respond with care.

---

## 7. Testing

- Write unit tests for: streak calculation, slip reset logic, daily totals by local date, personality lock check, plan JSON validation.
- Write a widget test for at least: Home screen and Workout set row.
- Test RLS manually with two different users before finishing Phase 2 and Phase 10.
- Before saying a task is done, run: `flutter analyze` (0 errors) and `flutter test`.

---

## 8. Git

- Small commits with clear messages: `feat(workout): add rest timer`.
- One branch per phase: `phase-3-plan`.
- `.env`, keys and `google-services.json` secrets are in `.gitignore` where applicable.

---

## 9. Performance

- Use `ListView.builder` for lists.
- Avoid rebuilding the whole screen on every timer tick (isolate the timer widget).
- Cache the daily mentor line, don't call the LLM on every Home open.
- Keep images local or compressed. No large network images.

---

## 10. When Unsure

Stop. Ask one question. Do not add "extra features", do not refactor unrelated code, do not change the design system on your own.
