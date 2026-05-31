# Best Gym App

**The best-in-class iOS app for independent personal trainers and small studios.**

Trainers and their clients use it together on iPhone and iPad in the gym for world-class workout programming, fast logging, and clear progress tracking — all without requiring clients to install anything themselves in v1.

## Current Status

- **Foundation**: Strong existing SwiftUI + SwiftData starter (excellent live workout session, smart daily suggester, clean tabs)
- **Phase**: Early implementation (see detailed plan in the session artifacts)
- **Target v1**: Local-first, multi-profile (trainer + clients on shared device), rich exercise library with video demos, program builder, client progress analytics

## Key Product Decisions (v1)

- **Platform**: iOS universal (iPhone + iPad optimized)
- **Architecture**: Local-first with SwiftData. Designed for easy future migration to Firebase/Supabase when clients want to log from home.
- **Multi-user model for small teams**: Local profiles on one device (trainer is admin). Each trainer can have their own device with iCloud private sync.
- **Exercise library**: High-quality curated data + free-exercise-db, with YouTube form videos for the most important movements.
- **No backend in v1**: Keeps scope tight and gives trainers full data ownership immediately.

## Tech Stack (2026 Modern)

- Swift 6 + SwiftUI (iOS 18+)
- SwiftData (persistence)
- Swift Charts (analytics)
- Modern @Observable MVVM + actors for services
- (Future) TCA only where the live session complexity justifies it

## Project Structure (Target)

See the full implementation plan for the detailed phased roadmap, data model evolution, and feature breakdown.

## Getting Started (Developers)

1. Open `Gym App.xcodeproj` (or the renamed equivalent) in Xcode.
2. Run on iPhone 16 and iPad Pro simulators.
3. The current app has a working Today → Start Workout flow with live set logging and rest timers.

## Roadmap Highlights

1. Multi-profile system (trainer switches between clients on a shared device)
2. First-class exercise library with video demos
3. Reusable program templates + client assignment
4. Per-client history and beautiful Swift Charts progress views
5. iPad-optimized master-detail layouts + premium polish

## License & Distribution

B2B product for trainers and small gyms. Local data ownership is a core principle.

---

**Detailed implementation plan** lives in the Grok session plan file (`.grok/sessions/.../plan.md`).

Built with care to be the app trainers actually love using on the gym floor every day.