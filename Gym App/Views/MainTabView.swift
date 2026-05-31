import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query(sort: \WorkoutLog.date, order: .reverse) private var workoutLogs: [WorkoutLog]
    @Query private var preferencesQuery: [UserPreferences]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTab: Tab = .today
    @State private var userPreferences: UserPreferences?
    @State private var profileManager: ProfileManager?

    private var effectivePreferences: UserPreferences {
        userPreferences ?? UserPreferences()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(preferences: effectivePreferences, recentLogs: workoutLogs)
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
                .tag(Tab.today)

            ExercisesView()
                .tabItem {
                    Label("Exercises", systemImage: "list.bullet")
                }
                .tag(Tab.exercises)

            HistoryView(logs: workoutLogs)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
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
                Label("Me", systemImage: "person.crop.circle")
            }
            .tag(Tab.profile)
        }
        .tint(Color.appTint)
        .onAppear(perform: ensurePreferencesExist)
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

    enum Tab {
        case today, exercises, history, profile
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [WorkoutLog.self, UserPreferences.self, Profile.self, ClientDetail.self], inMemory: true)
}
