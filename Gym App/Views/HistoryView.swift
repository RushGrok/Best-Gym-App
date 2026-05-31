import SwiftUI
import SwiftData

struct HistoryView: View {
    let logs: [WorkoutLog]

    var body: some View {
        NavigationStack {
            Group {
                if logs.isEmpty {
                    ContentUnavailableView(
                        "No workouts yet",
                        systemImage: "figure.strengthtraining.traditional",
                        description: Text("Complete your first workout from the Today tab and it will appear here.")
                    )
                } else {
                    List {
                        ForEach(logs) { log in
                            WorkoutLogRow(log: log)
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

struct WorkoutLogRow: View {
    let log: WorkoutLog

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(log.title)
                    .font(.headline)
                Spacer()
                if log.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "clock.badge.exclamationmark")
                        .foregroundStyle(Color.appTint)
                }
            }

            HStack {
                Text(log.formattedDate)
                Text("•")
                Text("\(log.estimatedMinutes) min planned")
                if let actual = log.actualDurationMinutes {
                    Text("• \(actual) min actual")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if !log.performedExercises.isEmpty {
                Text("\(log.performedExercises.count) exercises logged")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HistoryView(logs: [])
}
