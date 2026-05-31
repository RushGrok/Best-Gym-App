import SwiftUI

struct ProfileView: View {
    @Bindable var preferences: UserPreferences
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    var body: some View {
        NavigationStack {
            Form {
                Section("Your Profile") {
                    TextField("Name", text: $preferences.name)
                        .textContentType(.name)
                }

                Section("Language") {
                    Picker("App Language", selection: $appLanguage) {
                        Text(String(localized: "English")).tag("en")
                        Text(String(localized: "Mandarin")).tag("zh-Hans")
                    }
                    .pickerStyle(.menu)

                    Text("Changing language will take effect after restarting the app.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Preferences") {
                    Picker("Target Workout Length", selection: $preferences.preferredDurationMinutes) {
                        Text("25 minutes").tag(25)
                        Text("35 minutes").tag(35)
                        Text("45 minutes").tag(45)
                        Text("60 minutes").tag(60)
                    }

                    Picker("Experience Level", selection: $preferences.experienceLevel) {
                        ForEach(ExperienceLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }

                Section("Available Equipment") {
                    ForEach(Equipment.allCases, id: \.self) { equipment in
                        Toggle(equipment.rawValue, isOn: Binding(
                            get: { preferences.availableEquipment.contains(equipment) },
                            set: { isOn in
                                if isOn {
                                    preferences.availableEquipment.insert(equipment)
                                } else {
                                    preferences.availableEquipment.remove(equipment)
                                }
                            }
                        ))
                    }
                }

                Section("Goals") {
                    ForEach(Goal.allCases) { goal in
                        Toggle(goal.rawValue, isOn: Binding(
                            get: { preferences.goals.contains(goal) },
                            set: { isOn in
                                if isOn {
                                    preferences.goals.append(goal)
                                } else {
                                    preferences.goals.removeAll { $0 == goal }
                                }
                            }
                        ))
                    }
                }

                Section {
                    Text("More settings coming soon: units (lbs/kg), rest timer customization, notifications.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Profile & Settings")
        }
    }
}

#Preview {
    ProfileView(preferences: UserPreferences())
}
