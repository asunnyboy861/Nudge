import SwiftUI

enum NudgeColor {
    static let primary = Color(red: 0.29, green: 0.56, blue: 0.85)
    static let overdue = Color(red: 0.91, green: 0.30, blue: 0.24)
    static let dueToday = Color(red: 0.95, green: 0.61, blue: 0.07)
    static let completed = Color(red: 0.15, green: 0.68, blue: 0.38)
    static let hot = Color(red: 0.91, green: 0.30, blue: 0.24)
    static let warm = Color(red: 0.95, green: 0.61, blue: 0.07)
    static let cold = Color(red: 0.20, green: 0.60, blue: 0.86)
    static let background = Color(red: 0.97, green: 0.98, blue: 0.98)
    static let cardBackground = Color.white
    static let textPrimary = Color(red: 0.10, green: 0.10, blue: 0.18)
    static let textSecondary = Color(red: 0.42, green: 0.46, blue: 0.49)
}

enum NudgeFont {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
}

enum NudgeSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

enum NudgeRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
}
