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
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(sharedModelContainer)
        }
    }
}
