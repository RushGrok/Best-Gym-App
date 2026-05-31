import SwiftUI
import SwiftData

struct TodayView: View {
    let preferences: UserPreferences
    let recentLogs: [WorkoutLog]

    @State private var suggestedWorkout: SuggestedWorkout?
    @State private var showingWorkout = false
    @State private var currentWorkout: SuggestedWorkout?

    private var streak: Int {
        calculateStreak(from: recentLogs)
    }

    private var lastWorkoutText: String {
        guard let last = recentLogs.first else { return "First workout today?" }
        let days = Calendar.current.dateComponents([.day], from: last.date, to: .now).day ?? 0
        if days == 0 { return "You trained today. Nice work!" }
        if days == 1 { return "Last workout: Yesterday" }
        return "Last workout: \(days) days ago"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    header

                    // Streak card
                    streakCard

                    // Today's suggestion
                    if let workout = suggestedWorkout {
                        workoutSuggestionCard(workout)

                        Button {
                            generateSuggestion()
                        } label: {
                            Label("Suggest something else", systemImage: "arrow.triangle.2.circlepath")
                                .font(.callout)
                        }
                        .padding(.top, -8)
                    } else {
                        ProgressView()
                            .padding(40)
                    }

                    // Quick actions
                    quickActions
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .background(Color.systemBackground)
            .navigationTitle("Today")
            #if os(iOS)
.navigationBarTitleDisplayMode(.large)
#endif
            .onAppear(perform: generateSuggestion)
            .refreshable {
                generateSuggestion()
            }
            .sheet(isPresented: $showingWorkout) {
                if let workout = currentWorkout {
                    WorkoutSessionView(suggestedWorkout: workout) {
                        showingWorkout = false
                        currentWorkout = nil
                        generateSuggestion()
                    }
                } else {
                    // Fallback UI so we never show a completely blank sheet
                    Text("No workout selected")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if let workout = suggestedWorkout {
                        currentWorkout = workout
                        showingWorkout = true
                    }
                } label: {
                    Label("Start Workout", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.appTint)
                .disabled(suggestedWorkout == nil)
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Date.now.formatted(.dateTime.weekday(.wide).month().day()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Let's get after it.")
                    .font(.title2.weight(.semibold))
            }
            Spacer()

            // Temporary profile indicator (will be replaced by real switcher)
            HStack(spacing: 6) {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundStyle(Color.appTint)
                Text(preferences.name.isEmpty ? "Trainer" : preferences.name)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
    }

    private var streakCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.system(size: 36))
                .foregroundStyle(Color.appTint)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak) day streak")
                    .font(.title3.weight(.semibold))
                Text(lastWorkoutText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondarySystemBackground)
        )
    }

    private func workoutSuggestionCard(_ workout: SuggestedWorkout) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title area
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(workout.title)
                        .font(.title2.weight(.bold))
                    Spacer()
                    Text("\(workout.estimatedMinutes) min")
                        .font(.callout.weight(.medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.appTint.opacity(0.15))
                        .foregroundStyle(Color.appTint)
                        .clipShape(Capsule())
                }

                Text(workout.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(workout.reason)
                    .font(.callout)
                    .padding(.top, 2)
            }

            // Exercise preview
            VStack(alignment: .leading, spacing: 8) {
                ForEach(workout.exercises.prefix(4)) { exercise in
                    HStack {
                        Image(systemName: iconForExercise(exercise))
                            .foregroundStyle(Color.appTint)
                            .frame(width: 24)
                        Text(exercise.name)
                            .font(.callout)
                        Spacer()
                        Text("\(exercise.defaultSets) × \(exercise.repRange)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if workout.exercises.count > 4 {
                    Text("+ \(workout.exercises.count - 4) more exercises")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 32)
                }
            }
            .padding(.top, 4)

            // Start Workout button inside the card
            Button {
                currentWorkout = workout
                showingWorkout = true
            } label: {
                HStack {
                    Spacer()
                    Text("Start Workout")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.appTint)
                )
            }
            .padding(.top, 12)

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondarySystemBackground)
        )
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick options")
                .font(.headline)
                .padding(.leading, 4)

            HStack(spacing: 12) {
                quickActionButton(
                    title: "20 min",
                    subtitle: "Fast session",
                    icon: "bolt.fill"
                ) {
                    // TODO: Generate shorter workout
                }

                quickActionButton(
                    title: "Core only",
                    subtitle: "10-15 min",
                    icon: "target"
                ) {
                    // TODO
                }

                quickActionButton(
                    title: "Just show up",
                    subtitle: "Minimal",
                    icon: "figure.walk"
                ) {
                    // TODO: Generate very light workout
                }
            }
        }
    }

    private func quickActionButton(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color.appTint)
                Text(title)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondarySystemBackground)
            )
        }
    }

    // MARK: - Helpers

    private func generateSuggestion() {
        suggestedWorkout = WorkoutSuggester.generateSuggestion(
            preferences: preferences,
            recentLogs: recentLogs
        )
    }

    private func iconForExercise(_ exercise: Exercise) -> String {
        if exercise.muscleGroups.contains(.chest) { return "figure.arms.open" }
        if exercise.muscleGroups.contains(.back) { return "figure.rower" }
        if exercise.muscleGroups.contains(.quads) || exercise.muscleGroups.contains(.hamstrings) { return "figure.walk" }
        if exercise.muscleGroups.contains(.core) { return "figure.core.training" }
        if exercise.category == .cardio { return "heart.fill" }
        return "dumbbell.fill"
    }

    private func calculateStreak(from logs: [WorkoutLog]) -> Int {
        let completed = logs
            .filter { $0.completed }
            .sorted { $0.date > $1.date }

        guard let mostRecent = completed.first else { return 0 }

        // If most recent wasn't today or yesterday, streak is broken
        let daysSince = Calendar.current.dateComponents([.day], from: mostRecent.date, to: .now).day ?? 99
        if daysSince > 1 { return 0 }

        var streak = 1
        var currentDate = Calendar.current.startOfDay(for: mostRecent.date)

        for log in completed.dropFirst() {
            let logDay = Calendar.current.startOfDay(for: log.date)
            let diff = Calendar.current.dateComponents([.day], from: logDay, to: currentDate).day ?? 0

            if diff == 1 {
                streak += 1
                currentDate = logDay
            } else if diff > 1 {
                break
            }
        }

        return streak
    }
}

#Preview {
    TodayView(
        preferences: UserPreferences(),
        recentLogs: []
    )
}
