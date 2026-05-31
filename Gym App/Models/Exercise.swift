import Foundation
import SwiftData

// MARK: - Enums

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    // Upper body
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case rearDelts = "Rear Delts"
    case traps = "Traps"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"

    // Lower body
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    case adductors = "Adductors"
    case abductors = "Abductors"
    case hipFlexors = "Hip Flexors"
    case legs = "Legs"

    // Other / general
    case core = "Core"
    case fullBody = "Full Body"
    case cardio = "Cardio"

    var id: String { rawValue }
}

enum Equipment: String, Codable, CaseIterable, Identifiable {
    case bodyweight = "Bodyweight"
    case dumbbells = "Dumbbells"
    case barbell = "Barbell"
    case kettlebell = "Kettlebell"
    case resistanceBands = "Resistance Bands"
    case cable = "Cable"
    case machine = "Machine"
    case bench = "Bench"
    case pullUpBar = "Pull-up Bar"
    case none = "None"

    var id: String { rawValue }
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case mobility = "Mobility"
    case core = "Core"
}

// MARK: - Exercise (Reference Data - not persisted as @Model to keep it simple)

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let muscleGroups: [MuscleGroup]
    let equipment: [Equipment]
    let category: ExerciseCategory
    let instructions: String
    let defaultSets: Int
    let repRange: String          // e.g. "8-12", "30s", "45-60s"
    let restSeconds: Int          // recommended rest between sets

    /// YouTube video ID for proper form demonstration (e.g. "gRVjAtPip0Y").
    /// When present, the detail view will link directly to this video.
    let youtubeVideoID: String?

    init(
        name: String,
        muscleGroups: [MuscleGroup],
        equipment: [Equipment],
        category: ExerciseCategory = .strength,
        instructions: String = "",
        defaultSets: Int = 3,
        repRange: String = "8-12",
        restSeconds: Int = 60,
        youtubeVideoID: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.muscleGroups = muscleGroups
        self.equipment = equipment
        self.category = category
        self.instructions = instructions
        self.defaultSets = defaultSets
        self.repRange = repRange
        self.restSeconds = restSeconds
        self.youtubeVideoID = youtubeVideoID
    }
}

// MARK: - Performed Exercise (logged during workout)

struct PerformedExercise: Codable, Identifiable, Hashable {
    let id: UUID
    let exerciseId: UUID
    let exerciseName: String
    var sets: [ExerciseSet]
    var notes: String?

    init(exercise: Exercise, sets: [ExerciseSet] = []) {
        self.id = UUID()
        self.exerciseId = exercise.id
        self.exerciseName = exercise.name
        self.sets = sets.isEmpty ? (0..<exercise.defaultSets).map { _ in ExerciseSet(targetReps: exercise.repRange) } : sets
    }
}

struct ExerciseSet: Codable, Identifiable, Hashable {
    let id: UUID
    var reps: Int?
    var weight: Double?          // in lbs or kg (user's choice later)
    var completed: Bool
    var targetReps: String       // "8-12" or "10"

    init(targetReps: String) {
        self.id = UUID()
        self.reps = nil
        self.weight = nil
        self.completed = false
        self.targetReps = targetReps
    }
}

// MARK: - Suggested Workout (generated, not stored until started)

struct SuggestedWorkout: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let focusAreas: [String]
    let exercises: [Exercise]
    let reason: String

    var totalExercises: Int { exercises.count }
}
