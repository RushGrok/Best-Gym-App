import SwiftUI
import SwiftData
import Combine

struct WorkoutSessionView: View {
    let suggestedWorkout: SuggestedWorkout
    let onComplete: () -> Void

    @State private var performedExercises: [PerformedExercise]
    @State private var startTime = Date()
    @State private var elapsedSeconds: TimeInterval = 0
    @State private var restTimerSeconds: Int = 0
    @State private var isResting = false
    @State private var activeExerciseId: UUID?
    @State private var showingFinishConfirmation = false

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(suggestedWorkout: SuggestedWorkout, onComplete: @escaping () -> Void) {
        self.suggestedWorkout = suggestedWorkout
        self.onComplete = onComplete
        _performedExercises = State(initialValue: suggestedWorkout.exercises.map { PerformedExercise(exercise: $0) })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top bar with timer
                sessionHeader

                // Exercise list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach($performedExercises) { $performed in
                            ExerciseLoggingRow(
                                performed: $performed,
                                isActive: activeExerciseId == performed.id,
                                onStartRest: startRestTimer,
                                onActivate: { activeExerciseId = performed.id }
                            )
                        }
                    }
                    .padding()
                }

                // Bottom action bar
                bottomBar
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(suggestedWorkout.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Finish") {
                        showingFinishConfirmation = true
                    }
                    .fontWeight(.semibold)
                }
            }
            .onReceive(timer) { _ in
                elapsedSeconds = Date().timeIntervalSince(startTime)
                if isResting && restTimerSeconds > 0 {
                    restTimerSeconds -= 1
                    if restTimerSeconds == 0 {
                        isResting = false
                    }
                }
            }
            .confirmationDialog("Finish workout?", isPresented: $showingFinishConfirmation) {
                Button("Save & Finish", role: .none) {
                    saveWorkout(completed: true)
                }
                Button("Save as Incomplete", role: .destructive) {
                    saveWorkout(completed: false)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("How did it go?")
            }
        }
    }

    private var sessionHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(elapsedTimeString)
                    .font(.system(size: 28, weight: .semibold, design: .monospaced))
                Text("\(suggestedWorkout.exercises.count) exercises")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isResting {
                VStack(alignment: .trailing) {
                    Text("REST")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.appTint)
                    Text("\(restTimerSeconds)s")
                        .font(.system(size: 22, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.appTint)
                }
            } else {
                Button {
                    // Could add "skip to next" or global notes
                } label: {
                    Label("Add Note", systemImage: "note.text")
                        .font(.callout)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }

    private var bottomBar: some View {
        VStack(spacing: 8) {
            if isResting {
                Button {
                    isResting = false
                    restTimerSeconds = 0
                } label: {
                    Text("Skip Rest")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            Button {
                // Quick complete all sets for current exercise (demo convenience)
                if let idx = performedExercises.firstIndex(where: { $0.id == activeExerciseId }) {
                    for i in 0..<performedExercises[idx].sets.count {
                        performedExercises[idx].sets[i].completed = true
                    }
                }
            } label: {
                Text("Mark Current Exercise Done")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.appTint)
        }
        .padding(.horizontal)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
    }

    private var elapsedTimeString: String {
        let minutes = Int(elapsedSeconds) / 60
        let seconds = Int(elapsedSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startRestTimer(seconds: Int) {
        restTimerSeconds = seconds
        isResting = true
    }

    private func saveWorkout(completed: Bool) {
        let duration = Int(elapsedSeconds / 60)

        let log = WorkoutLog(
            date: .now,
            title: suggestedWorkout.title,
            focus: suggestedWorkout.focusAreas.joined(separator: ", "),
            estimatedMinutes: suggestedWorkout.estimatedMinutes,
            performedExercises: performedExercises,
            completed: completed
        )
        log.actualDurationMinutes = duration

        modelContext.insert(log)

        do {
            try modelContext.save()
        } catch {
            print("Failed to save workout: \(error)")
        }

        onComplete()
    }
}

// MARK: - Exercise Row

struct ExerciseLoggingRow: View {
    @Binding var performed: PerformedExercise
    let isActive: Bool
    let onStartRest: (Int) -> Void
    let onActivate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(performed.exerciseName)
                        .font(.headline)
                    Text("\(performed.sets.count) sets • Target: \(performed.sets.first?.targetReps ?? "")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    onActivate()
                } label: {
                    Image(systemName: isActive ? "chevron.down.circle.fill" : "chevron.right.circle")
                        .font(.title3)
                        .foregroundStyle(isActive ? .appTint : .secondary)
                }
            }

            // Sets
            if isActive {
                VStack(spacing: 8) {
                    ForEach(Array($performed.sets.enumerated()), id: \.element.id) { index, $set in
                        SetRow(index: index, set: $set, onCompleteSet: {
                            let suggestedRest = performed.sets.first?.targetReps.contains("s") == true ? 30 : 60
                            onStartRest(suggestedRest)
                        })
                    }

                    Button {
                        let newSet = ExerciseSet(targetReps: performed.sets.first?.targetReps ?? "8-12")
                        performed.sets.append(newSet)
                    } label: {
                        Label("Add Set", systemImage: "plus.circle")
                            .font(.callout)
                    }
                    .padding(.top, 4)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isActive ? Color.appTint.opacity(0.08) : Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isActive ? Color.appTint.opacity(0.4) : Color.clear, lineWidth: 2)
        )
    }
}

struct SetRow: View {
    let index: Int
    @Binding var set: ExerciseSet
    let onCompleteSet: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("Set \(index + 1)")
                .font(.callout.weight(.medium))
                .frame(width: 50, alignment: .leading)

            // Reps
            HStack(spacing: 4) {
                TextField("Reps", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 50)
                    .padding(6)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text("reps")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Weight
            HStack(spacing: 4) {
                TextField("Weight", value: $set.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 55)
                    .padding(6)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text("lbs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Complete toggle
            Button {
                set.completed.toggle()
                if set.completed {
                    onCompleteSet()
                }
            } label: {
                Image(systemName: set.completed ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(set.completed ? .green : .secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var setNumber: Int {
        // This is a bit of a hack since we don't have the index easily.
        // In a better version we'd pass the index.
        1
    }
}

#Preview {
    WorkoutSessionView(
        suggestedWorkout: SuggestedWorkout(
            id: UUID(),
            title: "Push Day",
            subtitle: "5 exercises • 40 min",
            estimatedMinutes: 40,
            focusAreas: ["Chest", "Shoulders"],
            exercises: Array(ExerciseDatabase.all.prefix(4)),
            reason: "Test workout"
        ),
        onComplete: {}
    )
}
