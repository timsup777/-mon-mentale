import SwiftUI

// MARK: - Language Selector View
// Sélecteur de langue avec design pastel fluide

struct LanguageSelector: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @Binding var isPresented: Bool
    @State private var selectedLanguage: LocalizationManager.Language
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self._selectedLanguage = State(initialValue: LocalizationManager.shared.currentLanguage)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Liste des langues
                languageListSection
                
                // Boutons d'action
                actionButtonsSection
            }
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle(LocalizedKeys.Settings.language.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedKeys.Common.close.localized) {
                        isPresented = false
                    }
                    .foregroundColor(MonMentaleColors.primaryBlue)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icône de langue
            ZStack {
                Circle()
                    .fill(MonMentaleColors.primaryGradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "globe")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Choisissez votre langue")
                    .title3Style()
                    .multilineTextAlignment(.center)
                
                Text("Sélectionnez la langue de votre choix pour l'application")
                    .bodyStyle()
                    .multilineTextAlignment(.center)
                    .foregroundColor(MonMentaleColors.textSecondary)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
    }
    
    // MARK: - Language List Section
    private var languageListSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(LocalizationManager.Language.allCases) { language in
                    LanguageRow(
                        language: language,
                        isSelected: selectedLanguage == language
                    ) {
                        selectedLanguage = language
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Bouton principal
            MonMentaleButton(
                title: LocalizedKeys.Common.save.localized,
                style: .primary
            ) {
                saveLanguage()
            }
            .disabled(selectedLanguage == localizationManager.currentLanguage)
            
            // Bouton d'annulation
            Button(LocalizedKeys.Common.cancel.localized) {
                isPresented = false
            }
            .calloutStyle()
            .foregroundColor(MonMentaleColors.textSecondary)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(MonMentaleColors.backgroundCard)
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 10, x: 0, y: -5)
    }
    
    // MARK: - Helper Methods
    private func saveLanguage() {
        localizationManager.setLanguage(selectedLanguage)
        isPresented = false
    }
}

// MARK: - Language Row
struct LanguageRow: View {
    let language: LocalizationManager.Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Drapeau
                Text(language.flag)
                    .font(.title)
                
                // Informations de la langue
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.displayName)
                        .calloutStyle()
                        .foregroundColor(MonMentaleColors.textPrimary)
                    
                    Text(language.rawValue.uppercased())
                        .captionStyle()
                        .foregroundColor(MonMentaleColors.textSecondary)
                }
                
                Spacer()
                
                // Indicateur de sélection
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.primaryBlue)
                } else {
                    Image(systemName: "circle")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.neutralGray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? MonMentaleColors.primaryBlue.opacity(0.1) : MonMentaleColors.backgroundCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? MonMentaleColors.primaryBlue : MonMentaleColors.neutralGray,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Language Selector Modal
struct LanguageSelectorModal: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Fond avec blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // Contenu du modal
            VStack(spacing: 0) {
                // Handle pour glisser
                RoundedRectangle(cornerRadius: 2)
                    .fill(MonMentaleColors.neutralGray)
                    .frame(width: 40, height: 4)
                    .padding(.top, 8)
                
                LanguageSelector(isPresented: $isPresented)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .background(MonMentaleColors.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal, 20)
            .offset(y: isPresented ? 0 : 0)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
    }
}

// MARK: - Language Toggle Button
struct LanguageToggleButton: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showingLanguageSelector = false
    
    var body: some View {
        Button(action: {
            showingLanguageSelector = true
        }) {
            HStack(spacing: 8) {
                Text(localizationManager.currentLanguage.flag)
                    .font(.title2)
                
                Text(localizationManager.currentLanguage.displayName)
                    .calloutStyle()
                    .foregroundColor(MonMentaleColors.textPrimary)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(MonMentaleColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(MonMentaleColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(MonMentaleColors.neutralGray, lineWidth: 1)
            )
        }
        .sheet(isPresented: $showingLanguageSelector) {
            LanguageSelectorModal(isPresented: $showingLanguageSelector)
        }
    }
}

// MARK: - Preview
struct LanguageSelector_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelector(isPresented: .constant(true))
            .environmentObject(LocalizationManager.shared)
    }
}

