import Foundation

/// Generates daily workout suggestions.
/// This is the heart of what helps the user actually go to the gym.
struct WorkoutSuggester {

    /// Main entry point. Call this every time the Today screen appears.
    static func generateSuggestion(
        preferences: UserPreferences,
        recentLogs: [WorkoutLog],
        allExercises: [Exercise] = ExerciseDatabase.all
    ) -> SuggestedWorkout {

        let available = ExerciseDatabase.available(for: preferences.availableEquipment)
        let duration = preferences.preferredDurationMinutes

        // 1. Analyze recent training (last 10 days)
        let recent = recentLogs
            .sorted { $0.date > $1.date }
            .prefix(10)

        let lastWorkoutDate = recent.first?.date ?? .distantPast
        let daysSinceLastWorkout = Calendar.current.dateComponents([.day], from: lastWorkoutDate, to: .now).day ?? 7

        // 2. Determine focus based on history + rotation
        let focus = determineFocus(recentLogs: Array(recent), daysSinceLast: daysSinceLastWorkout)

        // 3. Select exercises for that focus
        let selectedExercises = selectExercises(
            for: focus,
            from: available,
            targetCount: exerciseCount(for: duration),
            recentLogs: Array(recent)
        )

        // 4. Create nice title + reason
        let (title, subtitle, reason) = makePresentation(
            focus: focus,
            daysSinceLast: daysSinceLastWorkout,
            exerciseCount: selectedExercises.count,
            duration: duration
        )

        return SuggestedWorkout(
            id: UUID(),
            title: title,
            subtitle: subtitle,
            estimatedMinutes: duration,
            focusAreas: focus.focusAreas,
            exercises: selectedExercises,
            reason: reason
        )
    }

    // MARK: - Focus Logic

    private static func determineFocus(recentLogs: [WorkoutLog], daysSinceLast: Int) -> WorkoutFocus {
        // If user hasn't worked out in 3+ days, default to full body or balanced
        if daysSinceLast >= 3 {
            return .balanced
        }

        // Look at last 2-3 workouts to avoid repeating the same focus
        let recentFocuses = recentLogs.prefix(3).map { $0.focus.lowercased() }

        let allOptions: [WorkoutFocus] = [.push, .pull, .legs, .upper, .lower, .balanced, .coreCardio]

        // Pick something different from recent
        let candidates = allOptions.filter { focus in
            !recentFocuses.contains { $0.contains(focus.rawValue.lowercased()) }
        }

        return candidates.randomElement() ?? .balanced
    }

    private enum WorkoutFocus: String {
        case push, pull, legs, upper, lower, balanced, coreCardio

        var focusAreas: [String] {
            switch self {
            case .push: return ["Chest", "Shoulders", "Triceps"]
            case .pull: return ["Back", "Biceps", "Rear Delts"]
            case .legs: return ["Quads", "Hamstrings", "Glutes"]
            case .upper: return ["Chest", "Back", "Shoulders", "Arms"]
            case .lower: return ["Legs", "Glutes", "Calves"]
            case .balanced: return ["Full Body"]
            case .coreCardio: return ["Core", "Conditioning"]
            }
        }
    }

    // MARK: - Exercise Selection

    private static func selectExercises(
        for focus: WorkoutFocus,
        from available: [Exercise],
        targetCount: Int,
        recentLogs: [WorkoutLog]
    ) -> [Exercise] {

        var pool = available

        // Filter by focus
        switch focus {
        case .push:
            pool = pool.filter { ex in
                ex.muscleGroups.contains(.chest) ||
                ex.muscleGroups.contains(.shoulders) ||
                ex.muscleGroups.contains(.triceps)
            }
        case .pull:
            pool = pool.filter { ex in
                ex.muscleGroups.contains(.back) ||
                ex.muscleGroups.contains(.biceps)
            }
        case .legs:
            pool = pool.filter { ex in
                ex.muscleGroups.contains(.quads) ||
                ex.muscleGroups.contains(.hamstrings) ||
                ex.muscleGroups.contains(.glutes) ||
                ex.muscleGroups.contains(.calves)
            }
        case .upper:
            pool = pool.filter { ex in
                !ex.muscleGroups.contains(.quads) &&
                !ex.muscleGroups.contains(.hamstrings) &&
                !ex.muscleGroups.contains(.calves)
            }
        case .lower:
            pool = pool.filter { ex in
                ex.muscleGroups.contains(.quads) ||
                ex.muscleGroups.contains(.hamstrings) ||
                ex.muscleGroups.contains(.glutes) ||
                ex.muscleGroups.contains(.calves)
            }
        case .coreCardio:
            pool = pool.filter { ex in
                ex.category == .cardio || ex.muscleGroups.contains(.core)
            }
        case .balanced:
            break // use full pool
        }

        // Prefer compound movements first (exercises that hit 2+ muscle groups)
        let compounds = pool.filter { $0.muscleGroups.count >= 2 }
        let isolations = pool.filter { $0.muscleGroups.count < 2 }

        var selection: [Exercise] = []

        // Add 2-4 compounds
        selection.append(contentsOf: compounds.shuffled().prefix(max(2, targetCount - 2)))

        // Fill rest with good variety
        let remaining = targetCount - selection.count
        if remaining > 0 {
            let fillers = (compounds + isolations)
                .filter { ex in !selection.contains(ex) }
                .shuffled()
                .prefix(remaining)
            selection.append(contentsOf: fillers)
        }

        // Always ensure at least one core movement if doing balanced or longer session
        if focus == .balanced && targetCount >= 5 && !selection.contains(where: { $0.muscleGroups.contains(.core) }) {
            if let core = available.first(where: { $0.muscleGroups.contains(.core) }) {
                if selection.count >= 2 {
                    selection.removeLast()
                }
                selection.append(core)
            }
        }

        return Array(selection.prefix(targetCount))
    }

    private static func exerciseCount(for duration: Int) -> Int {
        switch duration {
        case ...25: return 4
        case 26...40: return 5
        case 41...55: return 6
        default: return 7
        }
    }

    // MARK: - Presentation

    private static func makePresentation(
        focus: WorkoutFocus,
        daysSinceLast: Int,
        exerciseCount: Int,
        duration: Int
    ) -> (title: String, subtitle: String, reason: String) {

        let title: String
        let reason: String

        switch focus {
        case .push:
            title = "Push Day"
            reason = "Time to build your chest, shoulders, and triceps."
        case .pull:
            title = "Pull Day"
            reason = "Back and biceps focus. Great for posture and pulling strength."
        case .legs:
            title = "Leg Day"
            reason = "Lower body strength and power. Don't skip legs!"
        case .upper:
            title = "Upper Body"
            reason = "Chest, back, shoulders, and arms in one efficient session."
        case .lower:
            title = "Lower Body Focus"
            reason = "Quads, hamstrings, glutes, and calves."
        case .coreCardio:
            title = "Core & Conditioning"
            reason = "Build a strong midsection and get the heart rate up."
        case .balanced:
            title = daysSinceLast >= 3 ? "Full Body Reset" : "Balanced Strength"
            reason = daysSinceLast >= 3
                ? "You haven't trained in a while. Let's hit everything."
                : "Well-rounded session to keep progressing across all areas."
        }

        let subtitle = "\(exerciseCount) exercises • \(duration) min"

        return (title, subtitle, reason)
    }
}
