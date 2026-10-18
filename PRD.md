# PRD.md — FORGE (AI Gym Mentor)

> "FORGE" is the working name. Change it anytime; keep it in one constant (`AppConfig.appName`).

---

## 1. Vision

FORGE is not a workout tracker. It is a **digital gym mentor in your pocket**.

Most gym apps give you charts and leave you alone. FORGE knows your body, your routine, your budget and your habits, and it **talks to you every day**: it plans, checks in, pushes you when you skip, celebrates when you win, and keeps an honest record of everything, including your slips.

**One-line pitch:** *A mentor that knows your plan, your wallet and your excuses.*

**Vision in 3 points**
1. **Mentor-first.** The AI mentor is the heart of the app, not a side chat tab. Home opens with the mentor's message.
2. **Honest and personal.** Plans are built from the user's real data (weight, goal, experience, current routine, food budget). Slips are never hidden. They reset streaks but stay in history.
3. **Built for real life.** Budget-friendly food (egg, dal, rice, soybean, banana, local protein), BDT currency, Bengali / Banglish / English mentor replies.

---

## 2. Target User

- **Primary:** Intermediate gym-goers (about 6 months to 3 years of training), age 18–30, in Bangladesh / South Asia, training in a commercial gym, with a limited food budget.
- **Behaviour:** Already has a split (e.g., Chest+Triceps, Back+Biceps, Legs), logs weights in a notebook or not at all, struggles with consistency, diet discipline (sugar, junk food) and motivation.
- **Language:** Mixed Bengali, Banglish (Bengali in English letters) and English.
- **Device:** Android first (mid-range phones). iOS later.

**Secondary (later):** beginners, home-workout users.

---

## 3. Problem

| Problem | How FORGE solves it |
|---|---|
| Users skip gym and quit apps quietly | Mentor notices, pushes, adapts the plan |
| Generic diet plans ignore budget | Meal plan built around daily BDT budget |
| No honest record of bad habits | Habit tracker + permanent Slip Log |
| Progress is invisible | Weight, strength and consistency charts + weekly report |
| Don't know what to eat / take (protein, supplements) | Mentor chat with gym + nutrition knowledge |

---

## 4. Core Loop

```
Open app -> Mentor message -> Today's workout -> Log sets
-> Log water / protein / eggs -> Habit check -> Mentor reacts
-> Weekly report -> Plan adjusts -> repeat
```

---

## 5. MVP Features

Each feature has **acceptance criteria**. A feature is done only when all are true.

### F1. Onboarding (4 steps)
- Step 1: age, height, weight, goal (Build Muscle / Lose Fat / Stay Fit).
- Step 2: training duration (slider 0–5+ years), auto-level label (Beginner under 6 months, Intermediate 6 months–3 years, Advanced over 3 years, editable), place (Gym / Home).
- Step 3: daily food budget (BDT), foods the user eats, foods to avoid.
- Step 4: weekday selection + muscle group + exercises per training day, with last-used weight per exercise.
- Language preference for the mentor (English / Bangla / Banglish).
- Mentor personality selection (see F7) at the end.
- **Done when:** completing it saves a profile + custom routine, and routes to Home. Can't skip required fields. Resumes if the app is killed mid-way.

### F2. Custom Routine + 7-Day AI Plan
- The user's own routine is stored as their **Custom Split**. The AI follows it, it does not invent a new split unless the user asks.
- AI generates a 7-day plan: workout days (from routine), meal plan within budget, protein / calorie / water targets.
- User can edit exercises, sets x reps, reorder, and regenerate.
- **Done when:** Plan screen shows each day; editing persists; "Regenerate" calls the backend and replaces the draft only after the user confirms.

### F3. Active Workout Logging
- One exercise at a time: sets table (kg, reps, check), "Last time: 59 kg x 8" shown.
- Rest timer after each completed set. Add / remove sets. Finish workout saves a session.
- **Done when:** a session with sets is saved, and next time the previous values are shown. Works with poor network (saves locally, syncs when online).

### F4. Daily Tracking (Missions)
- Water (quick +250 ml / +500 ml, target from plan).
- Protein grams (manual add or quick food tap).
- Eggs / key foods count (e.g., "eggs today 2 / 3").
- Workout done flag (auto from session).
- Home shows "Daily Missions: 3 of 5 done".
- **Done when:** values reset at local midnight, history is kept per day.

### F5. Habit Challenges + Slip Log
- Create a challenge (e.g., "No sugar", 30 days). Streak shown as day dots.
- "I slipped" button: asks what (Sugar / Fatty food / Junk / Other), optional note. **Streak resets, entry is saved forever.**
- Slip Log timeline appears in the Weekly Report. Slips cannot be deleted by the user.
- **Done when:** slip creates a log row with timestamp, resets streak, and appears in the report.

### F6. AI Mentor Chat
- Chat with a mentor that has the user's context (profile, plan, today's logs, recent slips, streaks).
- Suggestion chips ("Cheap protein ideas", "Skip today?", "Check my week").
- Mentor can create a **challenge card** ("100 push-ups at home, mark done").
- **Done when:** replies are personality-correct, reference real user data, and respect daily message limits.

### F7. Mentor Personality (30-day lock)
- Options: **Friendly Coach**, **Strict Coach**, **Savage Mode** (opt-in, 18+ only).
- Once chosen it is **locked for 30 days**. Settings shows "Locked until <date> (N days left)".
- Lock is enforced on the **server**, not only in the UI.
- **Done when:** trying to change before the date fails with a clear message; after the date it can be changed.

### F8. Progress
- Weight chart (weekly weigh-in), strength chart per exercise, consistency calendar (trained / missed / rest), weekly water bars.
- **Done when:** charts read real data and handle empty states.

### F9. Weekly Report
- Workouts done vs planned, avg water, avg protein, slips count, mentor's verdict (2 short lines), Slip Log timeline.
- Generated every week (Friday night or on demand).
- **Done when:** report opens from Progress and from a notification.

### F10. Reminders (simple)
- Local scheduled notifications: workout time, water nudges, evening check-in. Text is templated per personality.
- **Done when:** user can set times, notifications fire on Android after reboot.

---

## 6. Mentor Personalities (behaviour spec)

| Mode | Tone | Example |
|---|---|---|
| Friendly Coach | Warm, encouraging, patient | "Rough day? Even a 20 min session counts. Let's do just chest." |
| Strict Coach | Direct, no excuses, firm | "Chest day. No excuses today. Open the workout." |
| Savage Mode | Sharp, competitive, roasting the *excuse*, never the person | "You said legs on Monday. The leg press is still waiting. Prove it." |

**Hard safety rules for every mode (including Savage):**
- Never insult the user's body, weight, looks, intelligence or family. Roast the excuse, not the person.
- Never use threats, real "blackmail", shame about worth, or language like "you are a loser/worthless".
- Never encourage starving, purging, extreme dehydration, overtraining through injury or pain, steroid use or unsafe supplement doses.
- If the user shows signs of an eating disorder, self-harm, or deep distress, **drop the persona**, respond gently, and suggest talking to a trusted person or professional.
- Medical issues (injury, chest pain, dizziness): advise resting and seeing a doctor.
- Challenges are physical and safe (e.g., push-ups at home), never risky dares.
- Savage Mode requires confirmed age 18+ and an explicit opt-in screen.

---

## 7. Out of Scope for MVP (do NOT build)

The AI coding agent must not build or "helpfully add" any of these:

- Social feed, community, friends, leaderboards, sharing to other users
- Progress photo compare
- Payments, subscriptions, premium tiers
- Wearable / heart-rate / step integrations
- Barcode scanner or food-database search (use a small built-in food list)
- Video exercise library or form-check with camera
- Voice mode / speech
- Auto plan adjustment engine (MVP: manual "Regenerate")
- AI-generated push notifications (MVP: templated local notifications)
- iOS release, web version, tablet layouts
- Multi-language UI (UI is English; only mentor replies support Bangla / Banglish)
- Admin dashboard

---

## 8. Success Metrics (for later)

- Day-7 and Day-30 retention
- Workouts logged per user per week
- Mentor messages per user per day
- % of users who keep the same personality after the 30-day lock
- Slip logging rate (honesty indicator)

---

## 9. Assumptions

- Backend: Supabase. LLM: Gemini API through backend (swappable).
- Android first, Flutter.
- Currency BDT, metric units (kg, cm, ml).
- The user is the owner and first tester. No public launch decisions yet.

---

## 10. Open Questions (answer before the phase that needs them)

1. Final app name and logo (before Phase 10).
2. LLM provider and monthly cost limit (before Phase 7).
3. Is Google sign-in required, or email only? (Phase 2)
4. Play Store release plan and privacy policy (Phase 10).
