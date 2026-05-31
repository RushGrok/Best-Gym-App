import Foundation

/// Static database of exercises. Seeded once at launch.
enum ExerciseDatabase {
    static let all: [Exercise] = [
        // === PUSH ===
        Exercise(
            name: "Push-ups",
            muscleGroups: [.chest, .shoulders, .triceps],
            equipment: [.bodyweight],
            instructions: "Hands shoulder-width, lower chest to floor, push back up. Keep core tight.",
            defaultSets: 3,
            repRange: "8-15",
            restSeconds: 45
        ),
        Exercise(
            name: "Dumbbell Bench Press",
            muscleGroups: [.chest, .shoulders, .triceps],
            equipment: [.dumbbells, .bench],
            instructions: "Lie on bench, press dumbbells from chest level to full extension.",
            defaultSets: 4,
            repRange: "6-10",
            restSeconds: 90
        ),
        Exercise(
            name: "Overhead Press",
            muscleGroups: [.shoulders, .triceps],
            equipment: [.dumbbells, .barbell],
            instructions: "Press weight from shoulder height overhead until arms are locked out.",
            defaultSets: 3,
            repRange: "6-10",
            restSeconds: 90
        ),
        Exercise(
            name: "Dumbbell Lateral Raises",
            muscleGroups: [.shoulders],
            equipment: [.dumbbells],
            instructions: "Raise dumbbells out to sides until arms are parallel to floor. Slight bend in elbows.",
            defaultSets: 3,
            repRange: "10-15",
            restSeconds: 45
        ),
        Exercise(
            name: "Tricep Dips",
            muscleGroups: [.triceps, .chest],
            equipment: [.bodyweight, .bench],
            instructions: "Lower body by bending elbows, then press back up. Keep shoulders down.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 60
        ),

        // === PULL ===
        Exercise(
            name: "Pull-ups",
            muscleGroups: [.back, .biceps],
            equipment: [.pullUpBar],
            instructions: "Hang from bar, pull chest toward bar, lower with control. Use band if needed.",
            defaultSets: 3,
            repRange: "4-8",
            restSeconds: 90
        ),
        Exercise(
            name: "Dumbbell Rows",
            muscleGroups: [.back, .biceps],
            equipment: [.dumbbells, .bench],
            instructions: "One hand on bench, row dumbbell toward hip, squeeze shoulder blade.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 60
        ),
        Exercise(
            name: "Face Pulls",
            muscleGroups: [.shoulders, .back],
            equipment: [.cable, .resistanceBands],
            instructions: "Pull rope toward face, externally rotate at end. Great for posture.",
            defaultSets: 3,
            repRange: "12-15",
            restSeconds: 45
        ),
        Exercise(
            name: "Dumbbell Bicep Curls",
            muscleGroups: [.biceps],
            equipment: [.dumbbells],
            instructions: "Curl weights toward shoulders without swinging. Control the negative.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 45
        ),
        Exercise(
            name: "Inverted Rows",
            muscleGroups: [.back, .biceps],
            equipment: [.bodyweight, .bench, .pullUpBar],
            instructions: "Lie under bar or table edge, pull chest up. Adjust difficulty by leg position.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 60
        ),

        // === LEGS ===
        Exercise(
            name: "Goblet Squats",
            muscleGroups: [.quads, .glutes, .core],
            equipment: [.dumbbells, .kettlebell],
            instructions: "Hold weight at chest, squat deep while keeping torso upright.",
            defaultSets: 4,
            repRange: "8-12",
            restSeconds: 75
        ),
        Exercise(
            name: "Romanian Deadlifts",
            muscleGroups: [.hamstrings, .glutes, .back],
            equipment: [.dumbbells, .barbell],
            instructions: "Hinge at hips with slight knee bend, feel stretch in hamstrings, drive hips forward.",
            defaultSets: 3,
            repRange: "6-10",
            restSeconds: 90
        ),
        Exercise(
            name: "Bulgarian Split Squats",
            muscleGroups: [.quads, .glutes],
            equipment: [.dumbbells, .bench],
            instructions: "Rear foot elevated on bench. Lower until front thigh is parallel to floor.",
            defaultSets: 3,
            repRange: "6-10 each",
            restSeconds: 60
        ),
        Exercise(
            name: "Walking Lunges",
            muscleGroups: [.quads, .glutes, .hamstrings],
            equipment: [.bodyweight, .dumbbells],
            instructions: "Step forward into lunge, push through front heel to bring back leg forward.",
            defaultSets: 3,
            repRange: "8-12 each",
            restSeconds: 45
        ),
        Exercise(
            name: "Calf Raises",
            muscleGroups: [.calves],
            equipment: [.bodyweight, .dumbbells],
            instructions: "Rise onto toes, pause at top, lower slowly. Use step for greater range.",
            defaultSets: 4,
            repRange: "12-20",
            restSeconds: 30
        ),
        Exercise(
            name: "Hip Thrusts",
            muscleGroups: [.glutes, .hamstrings],
            equipment: [.barbell, .bench, .dumbbells],
            instructions: "Upper back on bench, drive hips up hard, squeeze glutes at top.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 60
        ),

        // === CORE ===
        Exercise(
            name: "Plank",
            muscleGroups: [.core],
            equipment: [.bodyweight],
            category: .core,
            instructions: "Forearms on ground, body straight from head to heels. Brace abs hard.",
            defaultSets: 3,
            repRange: "30-60s",
            restSeconds: 30
        ),
        Exercise(
            name: "Dead Bugs",
            muscleGroups: [.core],
            equipment: [.bodyweight],
            category: .core,
            instructions: "Lie on back, extend opposite arm and leg while keeping lower back pressed down.",
            defaultSets: 3,
            repRange: "8-12 each",
            restSeconds: 30
        ),
        Exercise(
            name: "Hanging Knee Raises",
            muscleGroups: [.core],
            equipment: [.pullUpBar],
            category: .core,
            instructions: "Hang from bar and raise knees toward chest with control.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 45
        ),
        Exercise(
            name: "Russian Twists",
            muscleGroups: [.core],
            equipment: [.bodyweight, .dumbbells],
            category: .core,
            instructions: "Sit with feet off ground, rotate torso side to side holding weight.",
            defaultSets: 3,
            repRange: "10-15 each",
            restSeconds: 30
        ),

        // === FULL BODY / POWER ===
        Exercise(
            name: "Dumbbell Thrusters",
            muscleGroups: [.fullBody],
            equipment: [.dumbbells],
            instructions: "Squat holding dumbbells at shoulders, stand and press overhead in one motion.",
            defaultSets: 3,
            repRange: "6-10",
            restSeconds: 60
        ),
        Exercise(
            name: "Kettlebell Swings",
            muscleGroups: [.fullBody, .glutes, .hamstrings],
            equipment: [.kettlebell],
            instructions: "Hinge and snap hips forward explosively. Arms are just guides for the bell.",
            defaultSets: 4,
            repRange: "12-20",
            restSeconds: 45
        ),
        Exercise(
            name: "Burpees",
            muscleGroups: [.fullBody, .cardio],
            equipment: [.bodyweight],
            category: .cardio,
            instructions: "Squat, kick feet back to plank, push-up (optional), jump feet in, leap up.",
            defaultSets: 3,
            repRange: "6-10",
            restSeconds: 45
        ),

        // === CARDIO / CONDITIONING ===
        Exercise(
            name: "Jump Rope",
            muscleGroups: [.cardio, .calves],
            equipment: [.bodyweight],
            category: .cardio,
            instructions: "Stay light on toes. Mix single unders, high knees, or double unders.",
            defaultSets: 4,
            repRange: "45-60s",
            restSeconds: 30
        ),
        Exercise(
            name: "Mountain Climbers",
            muscleGroups: [.cardio, .core],
            equipment: [.bodyweight],
            category: .cardio,
            instructions: "Plank position, rapidly drive knees toward chest one at a time.",
            defaultSets: 3,
            repRange: "30-45s",
            restSeconds: 20
        ),
        Exercise(
            name: "Rowing Machine",
            muscleGroups: [.cardio, .back, .legs],
            equipment: [.machine],
            category: .cardio,
            instructions: "Drive with legs first, then pull handle to chest. Reverse the motion smoothly.",
            defaultSets: 3,
            repRange: "250-400m",
            restSeconds: 60
        ),
    ]

    /// Returns exercises filtered to those the user can actually do with their equipment.
    static func available(for equipment: Set<Equipment>) -> [Exercise] {
        all.filter { exercise in
            // An exercise is available if the user has *at least one* of the required pieces
            // OR if it requires only bodyweight (always available)
            exercise.equipment.contains(.bodyweight) ||
            !exercise.equipment.filter { equipment.contains($0) }.isEmpty
        }
    }
}
