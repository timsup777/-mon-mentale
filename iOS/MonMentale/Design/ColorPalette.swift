import SwiftUI

// MARK: - Color Palette System
// Palette de couleurs pastel complémentaires optimisée pour la santé mentale

struct MonMentaleColors {
    
    // MARK: - Primary Colors (Pastel pour santé mentale)
    static let primaryBlue = Color(red: 0.6, green: 0.8, blue: 0.95) // Bleu ciel doux
    static let primaryBlueDark = Color(red: 0.4, green: 0.6, blue: 0.85) // Bleu plus profond
    static let primaryBlueLight = Color(red: 0.8, green: 0.9, blue: 0.98) // Bleu très clair
    
    // MARK: - Secondary Colors (Rose pastel)
    static let secondaryPink = Color(red: 0.95, green: 0.8, blue: 0.85) // Rose poudré
    static let secondaryPinkDark = Color(red: 0.85, green: 0.6, blue: 0.75) // Rose plus profond
    static let secondaryPinkLight = Color(red: 0.98, green: 0.9, blue: 0.92) // Rose très clair
    
    // MARK: - Accent Colors (Violet pastel)
    static let accentPurple = Color(red: 0.85, green: 0.8, blue: 0.95) // Violet lavande
    static let accentPurpleDark = Color(red: 0.75, green: 0.7, blue: 0.85) // Violet plus profond
    static let accentPurpleLight = Color(red: 0.92, green: 0.9, blue: 0.98) // Violet très clair
    
    // MARK: - Complementary Colors (Vert pastel)
    static let complementaryGreen = Color(red: 0.8, green: 0.95, blue: 0.85) // Vert menthe
    static let complementaryGreenDark = Color(red: 0.6, green: 0.85, blue: 0.75) // Vert plus profond
    static let complementaryGreenLight = Color(red: 0.9, green: 0.98, blue: 0.92) // Vert très clair
    
    // MARK: - Warm Accent (Pêche pastel)
    static let warmPeach = Color(red: 0.95, green: 0.85, blue: 0.8) // Pêche douce
    static let warmPeachDark = Color(red: 0.85, green: 0.75, blue: 0.7) // Pêche plus profonde
    static let warmPeachLight = Color(red: 0.98, green: 0.92, blue: 0.9) // Pêche très claire
    
    // MARK: - Neutral Colors
    static let neutralGray = Color(red: 0.9, green: 0.9, blue: 0.92) // Gris très clair
    static let neutralGrayDark = Color(red: 0.7, green: 0.7, blue: 0.75) // Gris moyen
    static let textPrimary = Color(red: 0.2, green: 0.2, blue: 0.25) // Texte principal
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.55) // Texte secondaire
    static let textTertiary = Color(red: 0.7, green: 0.7, blue: 0.75) // Texte tertiaire
    
    // MARK: - Background Colors (Pastel pour santé mentale)
    static let backgroundPrimary = Color(red: 0.98, green: 0.98, blue: 0.99) // Blanc cassé
    static let backgroundSecondary = Color(red: 0.95, green: 0.96, blue: 0.98) // Gris très clair
    static let backgroundCard = Color.white // Blanc pur pour les cartes
    static let headerBackground = Color(red: 0.6, green: 0.8, blue: 0.95) // Bleu pastel header
    static let searchBackground = Color(red: 0.96, green: 0.96, blue: 0.96) // Gris clair pour recherche
    
    // MARK: - Status Colors
    static let success = Color(red: 0.7, green: 0.9, blue: 0.8) // Vert succès pastel
    static let warning = Color(red: 0.95, green: 0.85, blue: 0.7) // Orange avertissement pastel
    static let error = Color(red: 0.95, green: 0.8, blue: 0.8) // Rouge erreur pastel
    static let info = Color(red: 0.8, green: 0.9, blue: 0.95) // Bleu info pastel
    
    // MARK: - Specialized Mental Health Colors
    static let calm = Color(red: 0.85, green: 0.9, blue: 0.95) // Calme - bleu très doux
    static let anxiety = Color(red: 0.95, green: 0.9, blue: 0.85) // Anxiété - beige chaud
    static let depression = Color(red: 0.9, green: 0.9, blue: 0.95) // Dépression - gris bleuté
    static let therapy = Color(red: 0.9, green: 0.85, blue: 0.95) // Thérapie - violet doux
    static let wellness = Color(red: 0.85, green: 0.95, blue: 0.9) // Bien-être - vert doux
}

// MARK: - Gradient Definitions
extension MonMentaleColors {
    
    // Gradients principaux
    static let primaryGradient = LinearGradient(
        colors: [primaryBlue, primaryBlueLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [secondaryPink, secondaryPinkLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accentPurple, accentPurpleLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Gradients thérapeutiques
    static let calmGradient = LinearGradient(
        colors: [calm, primaryBlueLight],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let wellnessGradient = LinearGradient(
        colors: [wellness, complementaryGreenLight],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Gradient de fond principal
    static let backgroundGradient = LinearGradient(
        colors: [backgroundPrimary, backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Color Scheme Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Dynamic Color Support
@available(iOS 13.0, *)
extension MonMentaleColors {
    static func adaptiveColor(light: Color, dark: Color) -> Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}
