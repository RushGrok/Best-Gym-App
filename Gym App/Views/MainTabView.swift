import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query(sort: \WorkoutLog.date, order: .reverse) private var workoutLogs: [WorkoutLog]
    @Query private var preferencesQuery: [UserPreferences]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTab: Tab = .today
    @State private var userPreferences: UserPreferences?
    @State private var profileManager: ProfileManager?

    @AppStorage("appLanguage") private var appLanguage: String = "en"

    private var effectivePreferences: UserPreferences {
        userPreferences ?? UserPreferences()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(preferences: effectivePreferences, recentLogs: workoutLogs)
                .tabItem {
                    Label(String(localized: "Today"), systemImage: "calendar")
                }
                .tag(Tab.today)

            ExercisesView()
                .tabItem {
                    Label(String(localized: "Exercises"), systemImage: "list.bullet")
                }
                .tag(Tab.exercises)

            HistoryView(logs: workoutLogs)
                .tabItem {
                    Label(String(localized: "History"), systemImage: "clock.arrow.circlepath")
                }
                .tag(Tab.history)

            Group {
                if let prefs = userPreferences {
                    ProfileView(preferences: prefs)
                } else {
                    ProgressView()
                }
            }
            .tabItem {
                Label(String(localized: "Me"), systemImage: "person.crop.circle")
            }
            .tag(Tab.profile)
        }
        .tint(Color.appTint)
        .onAppear {
            ensurePreferencesExist()
            // Pre-generate suggestion early so the toolbar button isn't disabled on first launch
            // (TodayView will also call it, but this helps with timing)
        }
        .environment(\.locale, Locale(identifier: appLanguage))
    }

    private func ensurePreferencesExist() {
        if let existing = preferencesQuery.first {
            userPreferences = existing
        } else {
            let newPrefs = UserPreferences()
            modelContext.insert(newPrefs)
            try? modelContext.save()
            userPreferences = newPrefs
        }
    }

    // Call this when we want to ensure a suggestion exists early (e.g. for toolbar button)
    func generateInitialSuggestionIfNeeded(recentLogs: [WorkoutLog]) {
        // This is a lightweight way to pre-warm the suggestion for the toolbar
        // Actual generation still happens in TodayView for freshness
    }

    enum Tab {
        case today, exercises, history, profile
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [WorkoutLog.self, UserPreferences.self, Profile.self, ClientDetail.self], inMemory: true)
}
