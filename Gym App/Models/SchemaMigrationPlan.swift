import SwiftData

// MARK: - Version 1 (before name was added to UserPreferences)
enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] = [
        UserPreferencesV1.self,
        WorkoutLog.self,
        Profile.self,
        ClientDetail.self
    ]
    
    @Model
    final class UserPreferencesV1 {
        var preferredDurationMinutes: Int
        var experienceLevelRaw: String
        var goalsRaw: [String]
        var availableEquipmentRaw: [String]
        var hasCompletedOnboarding: Bool

        init(
            preferredDurationMinutes: Int = 45,
            experienceLevelRaw: String = "Intermediate",
            goalsRaw: [String] = ["General Fitness"],
            availableEquipmentRaw: [String] = ["Bodyweight", "Dumbbells", "Bench"],
            hasCompletedOnboarding: Bool = false
        ) {
            self.preferredDurationMinutes = preferredDurationMinutes
            self.experienceLevelRaw = experienceLevelRaw
            self.goalsRaw = goalsRaw
            self.availableEquipmentRaw = availableEquipmentRaw
            self.hasCompletedOnboarding = hasCompletedOnboarding
        }
    }
}

// MARK: - Version 2 (current)
enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] = [
        UserPreferences.self,
        WorkoutLog.self,
        Profile.self,
        ClientDetail.self
    ]
}

// MARK: - Migration Plan
enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] = [
        SchemaV1.self,
        SchemaV2.self
    ]
    
    static var stages: [MigrationStage] = [
        MigrationStage.lightweight(
            fromVersion: SchemaV1.self,
            toVersion: SchemaV2.self
        )
    ]
}
