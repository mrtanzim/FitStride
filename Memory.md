# Memory.md — Project Memory (FORGE)

The AI agent **reads this file first in every new chat** and **updates it after every finished task**. Keep it short and current. Newest entries at the top of each log.

---

## 1. Project Snapshot

- **App:** FORGE (working name), an AI gym mentor. Mentor-first, not a plain tracker.
- **Platform:** Android first, Flutter + Riverpod + go_router.
- **Backend:** Supabase (Auth, Postgres + RLS, Edge Functions). LLM (Gemini) only via Edge Functions.
- **Owner:** solo builder, vibe coding with AI tools. Explain steps simply, one task at a time.
- **Docs:** `PRD.md`, `Architecture.md`, `Rules.md`, `Phases.md`, `Design.md`, `Memory.md` in `/docs`.
- **Design reference:** Stitch screens in `/design` (Home screen approved; style = dark green-black, glass cards, lime accent, Inter).
- **GitHub repo:** https://github.com/mrtanzim/FitStride (branch: `main`)

---

## 2. Current Status

- **Current phase:** Phase 0 & Phase 1 complete
- **Last completed task:** Built Plan screen (Workout Details) matching Stitch HTML design inch-to-inch, wired into Tab 1. Full project committed and pushed to GitHub.
- **Next task:** 0.4 Supabase project setup & auth foundation (Phase 2)
- **Blocked by:** waiting for Supabase credentials (URL & anon key) from owner

---

## 3. Decisions Made

| Date | Decision | Reason |
|---|---|---|
| 2026-10-14 | Converted approved Stitch HTML into modular Flutter widgets | Ensures pixel-per-pixel fidelity while adhering to architecture |
| (start) | Flutter + Riverpod + Supabase | Simple for a solo vibe coder, secrets stay server-side |
| (start) | LLM called only from Edge Functions | Never expose API keys in the app |
| (start) | Mentor personality locks for 30 days, enforced on server | Product rule from owner |
| (start) | Slips reset streak but are permanent in the Slip Log | Honest tracking, product rule from owner |
| (start) | Savage Mode is opt-in, 18+, roasts the excuse never the person | Safety and retention |
| (start) | Currency BDT, units kg / cm / ml | Target users in Bangladesh |
| (start) | Mentor replies in English / Bangla / Banglish (UI English only) | Owner and users mix languages |
| (start) | No stock athlete photos, muscle silhouette + lime orb instead | Unique identity, approved Home design |

---

## 4. Completed Work Log

_(Add entries like this after each task.)_

```
YYYY-MM-DD | Phase X.Y | What was done | Files touched | How to test
```

- 2026-10-18 | Phase 1.5 | Built Plan screen (Workout Details) matching Stitch HTML design — day selector, hero card, 5 exercise cards, goal card, meal fuel card. Wired into Tab 1 router. Full project committed and pushed to GitHub (https://github.com/mrtanzim/FitStride) | `lib/features/plan/presentation/plan_screen.dart`, `lib/app/router.dart` | Tap the Plan tab in the nav bar
- 2026-10-14 | Phase 0.1-0.3, 0.6 & Phase 1.1-1.4 | Setup Flutter project, Riverpod, go_router, Google Fonts, created design system tokens, GlassCard, LimeButton, MentorOrb, MuscleSilhouette, AppBottomNav and converted the approved Stitch Home screen inch by inch into `features/home/presentation/home_screen.dart` | `lib/core/theme/*`, `lib/core/widgets/*`, `lib/app/*`, `lib/features/home/presentation/*`, `test/widget_test.dart` | Run `flutter test` and `flutter run`

---

## 5. Known Issues / Bugs

- (none yet)

Format: `[ ] Short description | where | how to reproduce`

---

## 6. Open Questions for the Owner

1. Final app name and logo?
2. LLM provider and monthly cost limit?
3. Email-only sign-in, or Google sign-in too?
4. Play Store release plan?

---

## 7. Gotchas / Lessons (add as you learn)

- (none yet)

Examples to record later: "Supabase local date vs UTC bug on water reset", "Android notifications need exact alarm permission".

---

## 8. Session Start Checklist (for the AI agent)

1. Read this file fully.
2. Read the next unchecked task in `Phases.md`.
3. Read `Rules.md` and the relevant part of `Design.md` / `Architecture.md`.
4. Confirm the task in one sentence, then do **only that task**.
5. Run `flutter analyze` and tests.
6. Tick the box in `Phases.md`, add a log entry above, update "Current Status".
7. Tell the owner exactly how to test it.
