import SwiftUI

/// Detailed exercise guide view — the heart of the "library & guides" experience.
/// v1: Excellent instructions + equipment + YouTube launch (curated links coming next).
struct ExerciseDetailView: View {
    let exercise: Exercise

    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Hero / visual area (placeholder for image or illustration)
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.brandNavy.opacity(0.08))
                        .frame(height: 220)

                    VStack(spacing: 12) {
                        Image(systemName: iconForExercise(exercise))
                            .font(.system(size: 72, weight: .light))
                            .foregroundStyle(.appTint)

                        Text(exercise.name)
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)

                // Quick meta
                HStack(spacing: 16) {
                    MetaChip(title: "\(exercise.defaultSets) sets", icon: "repeat")
                    MetaChip(title: exercise.repRange, icon: "number")
                    MetaChip(title: "\(exercise.restSeconds)s rest", icon: "timer")
                }
                .padding(.horizontal)

                // Muscles & Equipment
                VStack(alignment: .leading, spacing: 8) {
                    Text("Targets")
                        .font(.headline)
                    FlowLayout {
                        ForEach(exercise.muscleGroups, id: \.self) { group in
                            Chip(text: group.rawValue, style: .muscle)
                        }
                        ForEach(exercise.equipment, id: \.self) { eq in
                            Chip(text: eq.rawValue, style: .equipment)
                        }
                    }
                }
                .padding(.horizontal)

                // Instructions (the "guide" part)
                VStack(alignment: .leading, spacing: 12) {
                    Text("How to Perform")
                        .font(.headline)

                    Text(exercise.instructions.isEmpty ? "Detailed coaching cues coming soon for this movement." : exercise.instructions)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)

                // Video CTA (core v1 requirement)
                Button {
                    launchVideo()
                } label: {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .font(.title3)
                        Text("Watch Proper Form Video")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.appTint)
                    )
                    .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Text("High-quality curated demonstrations for the most important lifts. More videos added continuously.")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal)
            }
            .padding(.vertical, 20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Exercise")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func launchVideo() {
        // For now we use a smart YouTube search as fallback.
        // Next step: add real curated youtubeVideoID per exercise.
        let query = exercise.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://www.youtube.com/results?search_query=\(query)+proper+form") {
            openURL(url)
        }
    }

    private func iconForExercise(_ ex: Exercise) -> String {
        if ex.muscleGroups.contains(.chest) { return "figure.arms.open" }
        if ex.muscleGroups.contains(.back) { return "figure.rower" }
        if ex.muscleGroups.contains(.quads) || ex.muscleGroups.contains(.hamstrings) { return "figure.walk" }
        if ex.muscleGroups.contains(.core) { return "figure.core.training" }
        if ex.category == .cardio { return "heart.fill" }
        return "dumbbell.fill"
    }
}

// Small reusable chips
private struct MetaChip: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
    }
}

private struct Chip: View {
    enum Style { case muscle, equipment }

    let text: String
    let style: Style

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(style == .muscle ? Color.appTint.opacity(0.12) : Color.secondary.opacity(0.12))
            .foregroundStyle(style == .muscle ? .appTint : .secondary)
            .clipShape(Capsule())
    }
}

// Very simple flow layout for chips (no external dependency)
private struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: result.positions[index].x + bounds.minX,
                                      y: result.positions[index].y + bounds.minY),
                          proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += lineHeight + 8
                    lineHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + 8
            }
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: ExerciseDatabase.all.first!)
    }
}