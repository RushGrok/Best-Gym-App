import Foundation
import SwiftData

@Model
final class WorkoutLog {
    var date: Date
    var title: String
    var focus: String
    var estimatedMinutes: Int
    var actualDurationMinutes: Int?
    var performedExercises: [PerformedExercise]
    var notes: String?
    var completed: Bool

    // B2B multi-profile support: which client (or nil = trainer's personal log)
    var clientProfileID: UUID?
    // Denormalized for fast display when the Profile may be deleted
    var clientName: String?

    init(
        date: Date = .now,
        title: String,
        focus: String,
        estimatedMinutes: Int,
        performedExercises: [PerformedExercise] = [],
        notes: String? = nil,
        completed: Bool = false,
        clientProfileID: UUID? = nil,
        clientName: String? = nil
    ) {
        self.date = date
        self.title = title
        self.focus = focus
        self.estimatedMinutes = estimatedMinutes
        self.performedExercises = performedExercises
        self.notes = notes
        self.completed = completed
        self.clientProfileID = clientProfileID
        self.clientName = clientName
    }

    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    var muscleGroupsHit: Set<MuscleGroup> {
        // We don't store full exercises here, so we compute from names for now
        // In a richer version we'd embed more data
        return []
    }
}

@Model
final class UserPreferences {
    var name: String = "Trainer"
    var preferredDurationMinutes: Int
    var experienceLevelRaw: String
    var goalsRaw: [String]
    var availableEquipmentRaw: [String]

    // Simple stored properties for now
    var hasCompletedOnboarding: Bool

    init(
        name: String = "Trainer",
        preferredDurationMinutes: Int = 45,
        experienceLevel: ExperienceLevel = .intermediate,
        goals: [Goal] = [.generalFitness],
        availableEquipment: Set<Equipment> = [.bodyweight, .dumbbells, .bench],
        hasCompletedOnboarding: Bool = false
    ) {
        self.name = name
        self.preferredDurationMinutes = preferredDurationMinutes
        self.experienceLevelRaw = experienceLevel.rawValue
        self.goalsRaw = goals.map { $0.rawValue }
        self.availableEquipmentRaw = availableEquipment.map { $0.rawValue }
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    var experienceLevel: ExperienceLevel {
        get { ExperienceLevel(rawValue: experienceLevelRaw) ?? .intermediate }
        set { experienceLevelRaw = newValue.rawValue }
    }

    var goals: [Goal] {
        get { goalsRaw.compactMap { Goal(rawValue: $0) } }
        set { goalsRaw = newValue.map { $0.rawValue } }
    }

    var availableEquipment: Set<Equipment> {
        get { Set(availableEquipmentRaw.compactMap { Equipment(rawValue: $0) }) }
        set { availableEquipmentRaw = newValue.map { $0.rawValue } }
    }
}

enum ExperienceLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum Goal: String, Codable, CaseIterable, Identifiable {
    case buildMuscle = "Build Muscle"
    case loseFat = "Lose Fat"
    case getStronger = "Get Stronger"
    case generalFitness = "General Fitness"
    case improveEndurance = "Improve Endurance"

    var id: String { rawValue }
}
