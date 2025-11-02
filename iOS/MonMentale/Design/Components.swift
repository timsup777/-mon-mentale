import SwiftUI

// MARK: - Reusable UI Components
// Composants SwiftUI fluides avec design pastel

// MARK: - Primary Button
struct MonMentaleButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
        case danger
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .buttonStyle()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(backgroundGradient)
            .foregroundColor(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var backgroundGradient: LinearGradient {
        switch style {
        case .primary:
            return MonMentaleColors.primaryGradient
        case .secondary:
            return MonMentaleColors.secondaryGradient
        case .outline, .ghost:
            return LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom)
        case .danger:
            return LinearGradient(colors: [MonMentaleColors.error, MonMentaleColors.error.opacity(0.8)], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .secondary, .danger:
            return .white
        case .outline, .ghost:
            return MonMentaleColors.primaryBlueDark
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline:
            return MonMentaleColors.primaryBlue
        case .ghost:
            return .clear
        default:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline:
            return 2
        default:
            return 0
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return MonMentaleColors.primaryBlue.opacity(0.3)
        case .secondary:
            return MonMentaleColors.secondaryPink.opacity(0.3)
        case .danger:
            return MonMentaleColors.error.opacity(0.3)
        default:
            return .clear
        }
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Component
struct MonMentaleCard<Content: View>: View {
    let content: Content
    let style: CardStyle
    
    enum CardStyle {
        case standard
        case elevated
        case outlined
        case gradient
    }
    
    init(style: CardStyle = .standard, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
    }
    
    private var backgroundView: some View {
        Group {
            switch style {
            case .standard:
                MonMentaleColors.backgroundCard
            case .elevated:
                MonMentaleColors.backgroundCard
            case .outlined:
                MonMentaleColors.backgroundCard
            case .gradient:
                MonMentaleColors.primaryGradient
            }
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outlined:
            return MonMentaleColors.neutralGray
        default:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outlined:
            return 1
        default:
            return 0
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated:
            return MonMentaleColors.textPrimary.opacity(0.1)
        case .gradient:
            return MonMentaleColors.primaryBlue.opacity(0.2)
        default:
            return .clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            return 12
        case .gradient:
            return 8
        default:
            return 0
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .elevated:
            return 6
        case .gradient:
            return 4
        default:
            return 0
        }
    }
}

// MARK: - Input Field
struct MonMentaleTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let errorMessage: String?
    
    init(title: String, placeholder: String, text: Binding<String>, isSecure: Bool = false, errorMessage: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .calloutStyle()
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(MonMentaleColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .captionStyle()
                    .foregroundColor(MonMentaleColors.error)
            }
        }
    }
    
    private var borderColor: Color {
        if errorMessage != nil {
            return MonMentaleColors.error
        } else if text.isEmpty {
            return MonMentaleColors.neutralGray
        } else {
            return MonMentaleColors.primaryBlue
        }
    }
}

// MARK: - Loading View
struct MonMentaleLoadingView: View {
    let message: String
    
    init(message: String = "Chargement...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: MonMentaleColors.primaryBlue))
                .scaleEffect(1.2)
            
            Text(message)
                .calloutStyle()
                .foregroundColor(MonMentaleColors.textSecondary)
        }
        .padding(40)
        .background(MonMentaleColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Empty State View
struct MonMentaleEmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(MonMentaleColors.primaryBlue)
            
            VStack(spacing: 12) {
                Text(title)
                    .title3Style()
                
                Text(message)
                    .bodyStyle()
                    .multilineTextAlignment(.center)
                    .foregroundColor(MonMentaleColors.textSecondary)
            }
            
            if let actionTitle = actionTitle, let action = action {
                MonMentaleButton(title: actionTitle, style: .primary, action: action)
                    .frame(maxWidth: 200)
            }
        }
        .padding(40)
    }
}

// MARK: - Badge Component
struct MonMentaleBadge: View {
    let text: String
    let style: BadgeStyle
    
    enum BadgeStyle {
        case primary
        case secondary
        case success
        case warning
        case error
        case info
    }
    
    var body: some View {
        Text(text)
            .captionStyle()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .clipShape(Capsule())
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return MonMentaleColors.primaryBlue
        case .secondary:
            return MonMentaleColors.secondaryPink
        case .success:
            return MonMentaleColors.success
        case .warning:
            return MonMentaleColors.warning
        case .error:
            return MonMentaleColors.error
        case .info:
            return MonMentaleColors.info
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .secondary, .error:
            return .white
        case .success, .warning, .info:
            return MonMentaleColors.textPrimary
        }
    }
}

// MARK: - Floating Action Button
struct MonMentaleFAB: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(MonMentaleColors.primaryGradient)
                .clipShape(Circle())
                .shadow(color: MonMentaleColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

