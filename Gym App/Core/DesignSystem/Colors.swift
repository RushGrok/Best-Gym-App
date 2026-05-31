import SwiftUI

// MARK: - Best Gym App Brand Colors (Deep Navy + Electric Blue)

extension Color {
    /// Primary brand - deep, trustworthy navy
    static let brandNavy = Color(red: 0.08, green: 0.12, blue: 0.22)

    /// Secondary / accent - electric, energetic blue
    static let brandBlue = Color(red: 0.20, green: 0.55, blue: 0.95)

    /// Supporting accent for CTAs, highlights
    static let brandAccent = Color(red: 0.30, green: 0.65, blue: 0.98)

    /// Surface / card background in dark mode friendly way
    static let brandSurface = Color(.secondarySystemGroupedBackground)
}

// Convenience for the old "orange" tint during transition
extension Color {
    static let appTint: Color = .brandBlue
}