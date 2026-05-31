import Foundation

/// Static database of exercises. Seeded once at launch.
///
/// === VIDEO CURATION NOTES ===
/// We prioritize high-quality, reputable coaching videos (Athlean-X, Jeff Nippard, etc.).
/// Only add a youtubeVideoID when the video is genuinely excellent for form cues.
/// Prefer videos under 5-6 minutes that focus on technique over entertainment.
/// When in doubt, leave it as nil and let the smart search act as fallback.
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
            restSeconds: 45,
            youtubeVideoID: "IODxDxX7oi4"   // Athlean-X - Excellent push-up form
        ),
        Exercise(
            name: "Dumbbell Bench Press",
            muscleGroups: [.chest, .shoulders, .triceps],
            equipment: [.dumbbells, .bench],
            instructions: "Lie on bench, press dumbbells from chest level to full extension.",
            defaultSets: 4,
            repRange: "6-10",
            restSeconds: 90,
            youtubeVideoID: "VmB1G1K7v94"   // Jeff Nippard - Great dumbbell bench technique
        ),
        Exercise(
            name: "Overhead Press",
            muscleGroups: [.shoulders, .triceps],
            equipment: [.dumbbells, .barbell],
            instructions: "Press weight from shoulder height overhead until arms are locked out.",
            defaultSets: 3,
            repRange: "6-10",
            restSeconds: 90,
            youtubeVideoID: "2yjwXTZQDDI"   // Athlean-X - Solid overhead press form
        ),
        Exercise(
            name: "Dumbbell Lateral Raises",
            muscleGroups: [.shoulders],
            equipment: [.dumbbells],
            instructions: "Raise dumbbells out to sides until arms are parallel to floor. Slight bend in elbows.",
            defaultSets: 3,
            repRange: "10-15",
            restSeconds: 45,
            youtubeVideoID: "3VcKaXpzqRo"   // Jeff Nippard - Excellent lateral raise tutorial
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
            restSeconds: 90,
            youtubeVideoID: "eGo4IYlbE5g"   // Athlean-X - Excellent pull-up tutorial
        ),
        Exercise(
            name: "Dumbbell Rows",
            muscleGroups: [.back, .biceps],
            equipment: [.dumbbells, .bench],
            instructions: "One hand on bench, row dumbbell toward hip, squeeze shoulder blade.",
            defaultSets: 3,
            repRange: "8-12",
            restSeconds: 60,
            youtubeVideoID: "pYcpY20QaE8"   // Jeff Nippard - Good single-arm row form
        ),
        Exercise(
            name: "Face Pulls",
            muscleGroups: [.shoulders, .back, .rearDelts],
            equipment: [.cable, .resistanceBands],
            instructions: "Pull rope toward face, externally rotate at end. Great for posture.",
            defaultSets: 3,
            repRange: "12-15",
            restSeconds: 45,
            youtubeVideoID: "rep-qVOkqgk"   // Athlean-X - Classic face pull video
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
            restSeconds: 75,
            youtubeVideoID: "MeIiIdhvXT4"   // Athlean-X - Great goblet squat demo
        ),
        Exercise(
            name: "Romanian Deadlifts",
            muscleGroups: [.hamstrings, .glutes, .back],
            equipment: [.dumbbells, .barbell],
            instructions: "Hinge at hips with slight knee bend, feel stretch in hamstrings, drive hips forward.",
            defaultSets: 3,
            repRange: "6-10",
            restSeconds: 90,
            youtubeVideoID: "jEy_czb3RKA"   // Athlean-X - Excellent RDL form
        ),
        Exercise(
            name: "Bulgarian Split Squats",
            muscleGroups: [.quads, .glutes],
            equipment: [.dumbbells, .bench],
            instructions: "Rear foot elevated on bench. Lower until front thigh is parallel to floor.",
            defaultSets: 3,
            repRange: "6-10 each",
            restSeconds: 60,
            youtubeVideoID: "2C-uNgKwPLE"   // Athlean-X - Good split squat technique
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
            restSeconds: 30,
            youtubeVideoID: "ASdvN_XEl_c"   // Athlean-X - Plank done right
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

        // === MOBILITY ===
        Exercise(
            name: "Cat-Cow",
            muscleGroups: [.core, .back],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "On all fours, alternate between arching and rounding your back. Move slowly with your breath.",
            defaultSets: 2,
            repRange: "8-10 each",
            restSeconds: 30
        ),
        Exercise(
            name: "World's Greatest Stretch",
            muscleGroups: [.fullBody],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "Lunge position, rotate torso and reach arm to sky. Great for hips, thoracic spine, and hamstrings.",
            defaultSets: 2,
            repRange: "5-8 each side",
            restSeconds: 30
        ),
        Exercise(
            name: "Thread the Needle",
            muscleGroups: [.shoulders, .back],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "On all fours, slide one arm under the other and rotate. Excellent for upper back and shoulder mobility.",
            defaultSets: 2,
            repRange: "8-10 each side",
            restSeconds: 30
        ),
        Exercise(
            name: "90/90 Hip Stretch",
            muscleGroups: [.glutes, .hamstrings],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "Sit with one leg in front and one to the side, both knees at 90 degrees. Hinge forward gently.",
            defaultSets: 2,
            repRange: "45-60s each side",
            restSeconds: 30
        ),
        Exercise(
            name: "Couch Stretch",
            muscleGroups: [.hipFlexors, .quads],
            equipment: [.bodyweight, .bench],
            category: .mobility,
            instructions: "Knee on the floor against a wall or bench, foot on the couch. Drive hips forward for deep hip flexor stretch.",
            defaultSets: 2,
            repRange: "45-90s each side",
            restSeconds: 30
        ),
        Exercise(
            name: "Downward Facing Dog",
            muscleGroups: [.shoulders, .hamstrings, .calves],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "From plank, lift hips high and back. Pedal the feet or hold for a full-body stretch.",
            defaultSets: 2,
            repRange: "30-60s",
            restSeconds: 30
        ),
        Exercise(
            name: "Pigeon Pose",
            muscleGroups: [.glutes, .hipFlexors],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "Bring one shin forward, extend the back leg. Sink hips for a deep glute and hip opener.",
            defaultSets: 2,
            repRange: "45-90s each side",
            restSeconds: 30
        ),
        Exercise(
            name: "Thoracic Rotations (Open Books)",
            muscleGroups: [.shoulders, .back],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "Lie on your side with knees bent. Open the top arm toward the floor while keeping knees stacked.",
            defaultSets: 2,
            repRange: "8-12 each side",
            restSeconds: 30
        ),
        Exercise(
            name: "Child's Pose",
            muscleGroups: [.back, .shoulders],
            equipment: [.bodyweight],
            category: .mobility,
            instructions: "Kneel and sit back on heels, reach arms forward. Relax and breathe deeply into the stretch.",
            defaultSets: 2,
            repRange: "30-60s",
            restSeconds: 30
        ),
        Exercise(
            name: "Shoulder Dislocates",
            muscleGroups: [.shoulders],
            equipment: [.resistanceBands],
            category: .mobility,
            instructions: "Hold a band or stick with wide grip. Slowly move it from hips to overhead and behind the back.",
            defaultSets: 3,
            repRange: "8-12",
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
            restSeconds: 45,
            youtubeVideoID: "YSxHifyI6sM"   // StrongFirst / good swing demo (widely recommended)
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
