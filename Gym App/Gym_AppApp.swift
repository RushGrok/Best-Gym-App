//
//  Gym_AppApp.swift
//  Best Gym App
//
//  B2B platform for independent trainers & small studios.
//  Local-first, multi-profile (trainer + clients on shared device).


import SwiftUI
import SwiftData

@main
struct Gym_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WorkoutLog.self,
            UserPreferences.self,
            Profile.self,
            ClientDetail.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: MigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            print("❌ Failed to create ModelContainer: \(error)")

            // Development helper: If the store is corrupted or from an old incompatible schema,
            // delete it and try again. This prevents constant crashes during development.
            #if DEBUG
            print("🧹 Deleting incompatible store and retrying...")

            // Recreate configuration inside the recovery block so it's always in scope
            let recoveryConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let storeURL = recoveryConfiguration.url

            try? FileManager.default.removeItem(at: storeURL)

            do {
                return try ModelContainer(
                    for: schema,
                    migrationPlan: MigrationPlan.self,
                    configurations: [recoveryConfiguration]
                )
            } catch {
                fatalError("❌ Could not create ModelContainer even after deleting the store: \(error)")
            }
            #else
            fatalError("Could not create ModelContainer: \(error)")
            #endif
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(sharedModelContainer)
                .preferredColorScheme(.light)
        }
    }
}
