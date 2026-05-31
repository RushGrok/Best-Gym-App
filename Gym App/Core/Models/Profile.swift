import Foundation
import SwiftData

// MARK: - Profile (local multi-user support for trainers + clients on shared device)

@Model
final class Profile {
    var id: UUID
    var roleRaw: String
    var name: String
    var email: String?
    var createdAt: Date
    var lastUsedAt: Date

    // Simple local auth for shared device (PIN or biometric-protected in UI layer)
    var pinHash: String?   // future: store hash, not plain

    init(
        role: ProfileRole,
        name: String,
        email: String? = nil,
        pinHash: String? = nil
    ) {
        self.id = UUID()
        self.roleRaw = role.rawValue
        self.name = name
        self.email = email
        self.createdAt = .now
        self.lastUsedAt = .now
        self.pinHash = pinHash
    }

    var role: ProfileRole {
        get { ProfileRole(rawValue: roleRaw) ?? .client }
        set { roleRaw = newValue.rawValue }
    }

    var isTrainer: Bool { role == .trainer }
}

enum ProfileRole: String, Codable, CaseIterable, Identifiable {
    case trainer = "Trainer"
    case client = "Client"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .trainer: return "figure.strengthtraining.traditional"
        case .client: return "person.crop.circle"
        }
    }
}

// MARK: - Lightweight client-specific details (1:1 with Profile when role == .client)

@Model
final class ClientDetail {
    var profile: Profile?

    var goals: [String]
    var notes: String
    var birthYear: Int?          // privacy-friendly vs full DOB

    // Bodyweight history (simple for v1; can normalize later)
    var bodyweightEntries: [BodyweightEntry]

    init(
        profile: Profile? = nil,
        goals: [String] = [],
        notes: String = "",
        birthYear: Int? = nil
    ) {
        self.profile = profile
        self.goals = goals
        self.notes = notes
        self.birthYear = birthYear
        self.bodyweightEntries = []
    }
}

struct BodyweightEntry: Codable, Hashable {
    var date: Date
    var weight: Double
    var unit: String   // "lbs" or "kg" — stored with entry for history integrity
}

// MARK: - Convenience

extension Profile {
    static var previewTrainer: Profile {
        Profile(role: .trainer, name: "Alex Rivera")
    }

    static var previewClient: Profile {
        Profile(role: .client, name: "Jordan Lee")
    }
}