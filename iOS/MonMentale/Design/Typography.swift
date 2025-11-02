import SwiftUI

// MARK: - Typography System
// Système de typographie fluide et lisible pour la santé mentale

struct MonMentaleFonts {
    
    // MARK: - Font Sizes
    private static let largeTitleSize: CGFloat = 34
    private static let title1Size: CGFloat = 28
    private static let title2Size: CGFloat = 22
    private static let title3Size: CGFloat = 20
    private static let headlineSize: CGFloat = 17
    private static let bodySize: CGFloat = 17
    private static let calloutSize: CGFloat = 16
    private static let subheadlineSize: CGFloat = 15
    private static let footnoteSize: CGFloat = 13
    private static let captionSize: CGFloat = 12
    
    // MARK: - Font Weights
    private static let lightWeight: Font.Weight = .light
    private static let regularWeight: Font.Weight = .regular
    private static let mediumWeight: Font.Weight = .medium
    private static let semiboldWeight: Font.Weight = .semibold
    private static let boldWeight: Font.Weight = .bold
    
    // MARK: - Primary Fonts
    static let largeTitle = Font.system(size: largeTitleSize, weight: boldWeight, design: .rounded)
    static let title1 = Font.system(size: title1Size, weight: semiboldWeight, design: .rounded)
    static let title2 = Font.system(size: title2Size, weight: semiboldWeight, design: .rounded)
    static let title3 = Font.system(size: title3Size, weight: mediumWeight, design: .rounded)
    static let headline = Font.system(size: headlineSize, weight: semiboldWeight, design: .default)
    static let body = Font.system(size: bodySize, weight: regularWeight, design: .default)
    static let callout = Font.system(size: calloutSize, weight: mediumWeight, design: .default)
    static let subheadline = Font.system(size: subheadlineSize, weight: regularWeight, design: .default)
    static let footnote = Font.system(size: footnoteSize, weight: regularWeight, design: .default)
    static let caption = Font.system(size: captionSize, weight: regularWeight, design: .default)
    
    // MARK: - Specialized Fonts
    static let button = Font.system(size: calloutSize, weight: semiboldWeight, design: .default)
    static let navigationTitle = Font.system(size: title3Size, weight: semiboldWeight, design: .rounded)
    static let tabBarItem = Font.system(size: captionSize, weight: mediumWeight, design: .default)
    static let cardTitle = Font.system(size: headlineSize, weight: semiboldWeight, design: .default)
    static let cardSubtitle = Font.system(size: subheadlineSize, weight: regularWeight, design: .default)
    static let price = Font.system(size: title2Size, weight: boldWeight, design: .monospaced)
    static let time = Font.system(size: calloutSize, weight: mediumWeight, design: .monospaced)
    
    // MARK: - Mental Health Specific Fonts
    static let affirmation = Font.system(size: title3Size, weight: mediumWeight, design: .rounded)
    static let quote = Font.system(size: bodySize, weight: lightWeight, design: .serif)
    static let mood = Font.system(size: largeTitleSize, weight: lightWeight, design: .rounded)
    static let progress = Font.system(size: headlineSize, weight: semiboldWeight, design: .monospaced)
}

// MARK: - Text Style Modifiers
extension View {
    
    // MARK: - Primary Text Styles
    func largeTitleStyle() -> some View {
        self.font(MonMentaleFonts.largeTitle)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func title1Style() -> some View {
        self.font(MonMentaleFonts.title1)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func title2Style() -> some View {
        self.font(MonMentaleFonts.title2)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func title3Style() -> some View {
        self.font(MonMentaleFonts.title3)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func headlineStyle() -> some View {
        self.font(MonMentaleFonts.headline)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func bodyStyle() -> some View {
        self.font(MonMentaleFonts.body)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func calloutStyle() -> some View {
        self.font(MonMentaleFonts.callout)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func subheadlineStyle() -> some View {
        self.font(MonMentaleFonts.subheadline)
            .foregroundColor(MonMentaleColors.textSecondary)
    }
    
    func footnoteStyle() -> some View {
        self.font(MonMentaleFonts.footnote)
            .foregroundColor(MonMentaleColors.textSecondary)
    }
    
    func captionStyle() -> some View {
        self.font(MonMentaleFonts.caption)
            .foregroundColor(MonMentaleColors.textTertiary)
    }
    
    // MARK: - Specialized Text Styles
    func buttonStyle() -> some View {
        self.font(MonMentaleFonts.button)
            .foregroundColor(.white)
    }
    
    func navigationTitleStyle() -> some View {
        self.font(MonMentaleFonts.navigationTitle)
            .foregroundColor(.white)
    }
    
    func cardTitleStyle() -> some View {
        self.font(MonMentaleFonts.cardTitle)
            .foregroundColor(MonMentaleColors.textPrimary)
    }
    
    func cardSubtitleStyle() -> some View {
        self.font(MonMentaleFonts.cardSubtitle)
            .foregroundColor(MonMentaleColors.textSecondary)
    }
    
    func priceStyle() -> some View {
        self.font(MonMentaleFonts.price)
            .foregroundColor(MonMentaleColors.primaryBlueDark)
    }
    
    func timeStyle() -> some View {
        self.font(MonMentaleFonts.time)
            .foregroundColor(MonMentaleColors.textSecondary)
    }
    
    // MARK: - Mental Health Text Styles
    func affirmationStyle() -> some View {
        self.font(MonMentaleFonts.affirmation)
            .foregroundColor(MonMentaleColors.wellness)
            .multilineTextAlignment(.center)
    }
    
    func quoteStyle() -> some View {
        self.font(MonMentaleFonts.quote)
            .foregroundColor(MonMentaleColors.textSecondary)
            .italic()
    }
    
    func moodStyle() -> some View {
        self.font(MonMentaleFonts.mood)
            .foregroundColor(MonMentaleColors.accentPurple)
    }
    
    func progressStyle() -> some View {
        self.font(MonMentaleFonts.progress)
            .foregroundColor(MonMentaleColors.complementaryGreenDark)
    }
}

// MARK: - Dynamic Type Support
extension MonMentaleFonts {
    static func scaledFont(for textStyle: UIFont.TextStyle, weight: Font.Weight = .regular) -> Font {
        let font = UIFont.preferredFont(forTextStyle: textStyle)
        return Font(font).weight(weight)
    }
}

// MARK: - Accessibility Text Styles
extension View {
    func accessibleTextStyle() -> some View {
        self
            .font(.body)
            .foregroundColor(MonMentaleColors.textPrimary)
            .accessibility(label: Text(""))
    }
    
    func highContrastTextStyle() -> some View {
        self
            .font(.body)
            .foregroundColor(.primary)
            .background(MonMentaleColors.backgroundCard)
    }
}

