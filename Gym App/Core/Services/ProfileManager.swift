import Foundation
import SwiftData
import Observation

/// Manages the current active profile (trainer or client) in the local multi-profile system.
/// For v1 this is all on-device. Later this will map to remote auth identities.
@Observable
final class ProfileManager {
    private let modelContext: ModelContext

    var currentProfile: Profile?
    var allProfiles: [Profile] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadProfiles()
    }

    func loadProfiles() {
        let descriptor = FetchDescriptor<Profile>(sortBy: [SortDescriptor(\.lastUsedAt, order: .reverse)])
        allProfiles = (try? modelContext.fetch(descriptor)) ?? []

        if currentProfile == nil {
            // Default to the first trainer, or create one
            if let trainer = allProfiles.first(where: { $0.isTrainer }) {
                currentProfile = trainer
            } else if let first = allProfiles.first {
                currentProfile = first
            } else {
                createDemoProfilesIfNeeded()
            }
        }
    }

    /// Creates a sensible demo setup for independent trainers (one trainer + 4-5 sample clients)
    private func createDemoProfilesIfNeeded() {
        let trainer = Profile(role: .trainer, name: "Alex Rivera", email: "alex@riverafitness.com")
        modelContext.insert(trainer)

        let clients = [
            Profile(role: .client, name: "Jordan Lee"),
            Profile(role: .client, name: "Sam Patel"),
            Profile(role: .client, name: "Taylor Kim"),
            Profile(role: .client, name: "Casey Morgan"),
            Profile(role: .client, name: "Riley Quinn")
        ]

        for client in clients {
            modelContext.insert(client)

            // Give each a lightweight ClientDetail
            let detail = ClientDetail(
                profile: client,
                goals: ["Build strength", "Improve posture"],
                notes: "New client intake pending"
            )
            modelContext.insert(detail)
        }

        try? modelContext.save()

        currentProfile = trainer
        loadProfiles()
    }

    func switchTo(_ profile: Profile) {
        currentProfile = profile
        profile.lastUsedAt = .now
        try? modelContext.save()
    }

    func createClient(name: String, goals: [String] = [], notes: String = "") -> Profile {
        let client = Profile(role: .client, name: name)
        modelContext.insert(client)

        let detail = ClientDetail(profile: client, goals: goals, notes: notes)
        modelContext.insert(detail)

        try? modelContext.save()
        loadProfiles()
        return client
    }

    var isTrainerMode: Bool {
        currentProfile?.isTrainer ?? false
    }
}