# Design.md — FORGE Design System

Source of truth for how FORGE looks. Based on the approved Stitch Home screen. Reference screens live in `/design`. **Do not invent new colors, fonts or card styles.**

**Feel:** dark, calm, glassy, premium, organised. Mentor-first, not a generic fitness-app layout.

---

## 1. Color Tokens

```dart
class AppColors {
  // Background
  static const bgDeep      = Color(0xFF050A07); // screen edges
  static const bgGlow      = Color(0xFF0D2A18); // soft green glow behind main content
  // Surfaces (glass)
  static const glass       = Color(0x14FFFFFF); // white at ~8%
  static const glassStrong = Color(0x1FFFFFFF); // white at ~12% (selected / pressed)
  static const glassBorder = Color(0x1AFFFFFF); // white at ~10%
  // Accent
  static const lime        = Color(0xFFB6F53C); // primary accent
  static const limeDim     = Color(0x33B6F53C); // lime at 20% (tints, dots off-state glow)
  static const onLime      = Color(0xFF0A1A05); // text on lime buttons
  // Text
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9AA39C);
  static const textDisabled  = Color(0xFF5C645E);
  // Status
  static const warning     = Color(0xFFFFB020); // slips, streak at risk
  static const danger      = Color(0xFFFF5A4F); // errors only
}
```

Rules:
- Lime is used **only** for: primary buttons, active tab, progress rings / bars, key numbers, completed states.
- No other accent colors. Warning (amber) only for slips / alerts. Danger only for errors.
- Never pure black backgrounds, use the gradient.

**Background gradient:** `bgDeep` at the edges with a radial `bgGlow` centered behind the top-middle content (about 60% screen width, 30% opacity fade).

---

## 2. Typography

One font family: **Inter** (via `google_fonts`).

| Style | Size / Weight | Use |
|---|---|---|
| `display` | 34 / 700 | Big numbers (kg, 68%) |
| `h1` | 26 / 700 | Screen titles, hero titles |
| `h2` | 22 / 600 | Card titles, "Chest + Triceps" |
| `h3` | 18 / 600 | Mentor message, section titles |
| `body` | 15 / 400 | Normal text |
| `bodyStrong` | 15 / 600 | Values, row labels |
| `label` | 13 / 500 | Chips, captions, secondary info |
| `button` | 16 / 600 | Buttons |

Rules: **minimum 13**. No all-caps micro labels. No letter-spaced "tech" text. Sentence case everywhere. Plain English copy, no jargon (no "telemetry", "CNS", "tactical").

---

## 3. Spacing, Radius, Elevation

- Screen horizontal padding: **20**
- Gap between cards: **16**
- Card inner padding: **16–20**
- Spacing scale: 4, 8, 12, 16, 20, 24, 32
- Radius: card **24**, chip / pill **999**, button **999**, input **16**, bottom sheet top **28**
- Bottom padding of scroll content: **110** (so the floating nav never covers content)
- No heavy drop shadows. Depth comes from blur, border and glow.
- Lime glow (soft, 16–24 blur, 25% opacity) only on the center + button and on active primary elements.

---

## 4. Core Components

### GlassCard
- Fill `glass`, 1px border `glassBorder`, radius 24, backdrop blur 16–20.
- Variant `selected`: border lime, fill `glassStrong`, subtle lime glow.
- Variant `dim`: opacity 0.5 (locked state).

### LimeButton
- Filled: fill `lime`, text `onLime`, pill, height 52, full width by default, optional trailing arrow icon.
- Outline: transparent fill, border `glassBorder`, white text, pill.
- Small: height 36, text 13 (e.g., "+250 ml", "Reply").
- Pressed: scale 0.98 + slightly darker lime.

### Chip / Pill
- Glass fill, border, label 13, radius 999. Selected: lime border + lime text, or lime fill with `onLime` text.

### ProgressRing
- Thick (10px) lime ring on a `glass` track, rounded caps, value centered in `display` or `h2`.

### ProgressBar
- 6px high, lime fill on `glass` track, rounded.

### Checkbox row (Missions)
- Circular checkbox 24px: empty = border `glassBorder`; done = lime fill with dark check. Label `bodyStrong`, value right-aligned `label` secondary.

### Streak dots (30-day challenge)
- 30 tiny dots (8px): done = lime, upcoming = `glass`, today = lime with ring.

### Bottom Navigation
- Floating glass bar, radius 28, margin 16 from edges and bottom.
- 5 slots: Home, Plan, **center raised lime circular "+" (Log)** with glow, Mentor, Progress.
- Active = lime icon + label; inactive = `textSecondary`. Line icons, 24px.

### Mentor Orb
- Small glowing lime circle (32–40px) with soft radial glow, used for the mentor avatar everywhere.

### Bottom Sheet
- Glass, top radius 28, small drag handle, blurred dimmed background behind it.

### Inputs / Number fields
- Glass fill, radius 16, large number text (`h2` or `display`), clear steppers (+ / −) with 48px tap targets.

---

## 5. Screens (Layout Specs)

**Home (approved).** Exactly 5 sections:
1. Header: avatar, "Good Morning, <name>", streak pill with flame and "12 days".
2. Mentor card: orb, "Strict Coach" badge with lock, one short message (h3), buttons "Talk to mentor" (outline) and "I'm going" (lime).
3. Today's Workout card: title + "6 exercises • 55 min", muscle silhouette (line art, target muscles glow lime), exercise chips (horizontally scrollable, "+3 more"), full-width "Start Workout".
4. Daily Missions card: progress bar + "3 of 5 done"; rows Workout, Water (+250 ml pill), Protein, Eggs (+), No sugar today.
5. No Sugar Challenge card: "Day 9 of 30", 30 dots, subtle "I slipped" text button.

**Onboarding.** 4 steps, thin lime progress bar on top, max 3 inputs per step, fixed lime Continue button at the bottom (last: "Build my plan").

**Plan.** Title + "Regenerate with AI", day selector (Sat–Fri), exercise list card (number, name, sets x reps, last weight, drag handle), meal plan card with total protein and BDT cost, rest-day recovery card.

**Active Workout.** No bottom nav. Top: back, title, timer pill, Finish. One exercise card, "Last time" line, set table (Set / kg / Reps / check), Add set, rest timer pill, upcoming exercise chips, fixed "Next Exercise" button.

**Quick Log sheet.** 2x3 glass tiles: Water, Protein, Meal, Weight, Workout note, Slip. Water tile with +250 / +500 chips.

**Mentor Chat.** Header with orb, "Your Mentor", personality badge with lock. Mentor bubbles: dark glass with thin lime left edge. User bubbles: lime fill, dark text. Challenge card inside chat with "Mark done". Suggestion chips above a glass input bar with mic icon and lime send.

**Choose Mentor.** Three large selectable cards (Friendly, Strict, Savage with "Opt-in" badge), each with icon, one-line description, sample quote. Button "Lock <name> for 30 days". Locked state: dim cards, lock icon, banner "Locked until <date> (N days left)".

**Progress.** Segmented control (Week / Month / All). Cards: Weight (line chart), Strength (exercise dropdown + chart), Consistency (month heat grid), Water (7 bars + dashed target).

**Weekly Report.** Week title, 2x2 stats, "Mentor's verdict" card, Slip Log timeline (date, what, amber tag), note "Slips reset your streak but stay in your history.", "Share report" outline button.

---

## 6. Motion

- Page transitions: 250 ms fade + slight slide.
- Set completed: row tints lime, check scales in (150 ms), light haptic.
- Progress ring / bar: animate from 0 on first show (600 ms ease-out).
- Mission checked: check pops, progress bar animates.
- Keep animations subtle. No bouncing, no long intros.

---

## 7. Icons and Imagery

- Line icons only (Material Symbols Rounded or Lucide), 24px, stroke about 1.75.
- **No stock athlete photos.** Use the muscle silhouette illustration (front / back, line art) for workouts, and the lime orb for the mentor.
- Empty states: simple line illustration + one short sentence + one action button.

---

## 8. Copy Style

- Short, plain, direct. Max about 8 words in headings, one short sentence for messages.
- Mentor text can be sharp, but UI labels stay neutral and clear.
- Examples: "Today's Workout", "Daily Missions", "I slipped", "Start Workout", "Quick Log".
- Never: "telemetry", "bio-metric", "CNS", "tactical", "system state", "archive".

---

## 9. Do / Don't

**Do:** glass cards, generous spacing, one lime accent, big readable numbers, calm layouts, consistent radius.
**Don't:** flat boxes with no border, multiple accent colors, tiny caps labels, more than 5 sections on a screen, copy a generic fitness-app layout, add decoration with no purpose.

---

## 10. Accessibility

- Text contrast at least 4.5:1 on glass (check `textSecondary` on the brightest glow area).
- Don't rely on color alone: slips use icon + label + amber, done uses a check mark.
- Respect system font scale up to 1.3 without overflow.
- Semantic labels on icon buttons.
