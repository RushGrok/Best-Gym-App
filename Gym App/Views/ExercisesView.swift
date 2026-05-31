import SwiftUI

struct ExercisesView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ExerciseCategory?

    private var filteredExercises: [Exercise] {
        var result = ExerciseDatabase.all

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.muscleGroups.contains { $0.rawValue.localizedCaseInsensitiveContains(searchText) }
            }
        }

        return result
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetailView(exercise: exercise)
                    } label: {
                        ExerciseRow(exercise: exercise)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search exercises or muscles")
            .navigationTitle("Exercise Library")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("All") { selectedCategory = nil }
                        ForEach(ExerciseCategory.allCases, id: \.self) { cat in
                            Button(cat.rawValue) { selectedCategory = cat }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(exercise.name)
                    .font(.headline)
                Spacer()
                Text(exercise.repRange)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(exercise.muscleGroups.map { $0.rawValue }.joined(separator: " • "))
                .font(.caption)
                .foregroundStyle(.secondary)

            if !exercise.instructions.isEmpty {
                Text(exercise.instructions)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack(spacing: 6) {
                ForEach(exercise.equipment, id: \.self) { eq in
                    Text(eq.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ExercisesView()
}
