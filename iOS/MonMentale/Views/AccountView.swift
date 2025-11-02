import SwiftUI

// MARK: - Account View (Style Doctolib)
// Page de compte utilisateur inspirée de Doctolib

struct AccountView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showingLanguageSelector = false
    @State private var showingPasswordChange = false
    @State private var showingEmailChange = false
    @State private var showingPhoneChange = false
    @State private var showingPaymentSettings = false
    @State private var showingDeleteAccount = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header avec titre et aide
                    headerSection
                    
                    // Section confidentialité
                    privacySection
                    
                    // Section identité
                    identitySection
                    
                    // Section connexion
                    connectionSection
                    
                    // Section paiement
                    paymentSection
                    
                    // Section paramètres
                    settingsSection
                    
                    // Section confidentialité avancée
                    advancedPrivacySection
                    
                    // Bouton de déconnexion
                    logoutSection
                    
                    // Version de l'app
                    versionSection
                }
            }
            .background(MonMentaleColors.backgroundPrimary)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingLanguageSelector) {
            LanguageSelectorModal(isPresented: $showingLanguageSelector)
        }
        .sheet(isPresented: $showingPasswordChange) {
            PasswordChangeModal(isPresented: $showingPasswordChange)
        }
        .sheet(isPresented: $showingEmailChange) {
            EmailChangeModal(isPresented: $showingEmailChange)
        }
        .sheet(isPresented: $showingPhoneChange) {
            PhoneChangeModal(isPresented: $showingPhoneChange)
        }
        .sheet(isPresented: $showingPaymentSettings) {
            PaymentSettingsModal(isPresented: $showingPaymentSettings)
        }
        .alert("Supprimer le compte", isPresented: $showingDeleteAccount) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                // Action de suppression
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            // Status bar simulé
            HStack {
                Text("17:35")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .clipShape(Capsule())
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "wifi")
                    Text("5G")
                    Text("83")
                    Image(systemName: "battery.75")
                }
                .font(.caption)
                .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Header principal
            HStack {
                Text("Mon compte")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "questionmark.circle")
                    Text("Aide")
                }
                .font(.subheadline)
                .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(MonMentaleColors.headerBackground)
    }
    
    // MARK: - Privacy Section
    private var privacySection: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "lock.shield")
                    .foregroundColor(MonMentaleColors.primaryBlue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Votre santé. Vos données.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(MonMentaleColors.textPrimary)
                    
                    Text("Le respect de la confidentialité de vos données est notre priorité absolue.")
                        .font(.subheadline)
                        .foregroundColor(MonMentaleColors.textSecondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(MonMentaleColors.primaryBlue.opacity(0.1))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(MonMentaleColors.neutralGray),
                alignment: .bottom
            )
            
            Button("Découvrir nos engagements") {
                // Action pour découvrir les engagements
            }
            .font(.subheadline)
            .foregroundColor(MonMentaleColors.primaryBlue)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Identity Section
    private var identitySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Identité")
            
            AccountMenuItem(
                icon: "person.circle",
                title: "Mon profil",
                subtitle: "Timothée BERTHELOT",
                action: {}
            )
            
            AccountMenuItem(
                icon: "person.3",
                title: "Mes proches",
                subtitle: "Ajoutez et gérez les profils de vos proches",
                action: {}
            )
        }
    }
    
    // MARK: - Connection Section
    private var connectionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Connexion")
            
            AccountMenuItem(
                icon: "phone",
                title: "Téléphone",
                subtitle: "06 59 24 68 85",
                rightContent: {
                    HStack(spacing: 8) {
                        Text("Vérifié")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .clipShape(Capsule())
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textTertiary)
                    }
                },
                action: { showingPhoneChange = true }
            )
            
            AccountMenuItem(
                icon: "envelope",
                title: "E-mail",
                subtitle: "timothee.berthelot1@gmail.com",
                rightContent: {
                    HStack(spacing: 8) {
                        Text("Vérifié")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .clipShape(Capsule())
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textTertiary)
                    }
                },
                action: { showingEmailChange = true }
            )
            
            AccountMenuItem(
                icon: "lock",
                title: "Mot de passe",
                subtitle: "••••••••••••",
                action: { showingPasswordChange = true }
            )
        }
    }
    
    // MARK: - Payment Section
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Paiement et facturation")
            
            AccountMenuItem(
                icon: "gear",
                title: "Paramètres de paiement en ligne",
                subtitle: "Gérez vos paiements en ligne avec les soignants",
                action: { showingPaymentSettings = true }
            )
            
            AccountMenuItem(
                icon: "creditcard",
                title: "Moyens de paiement",
                subtitle: "Vos cartes bancaires pour les paiements de vos consultations",
                action: { showingPaymentSettings = true }
            )
        }
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Paramètres")
            
            AccountMenuItem(
                icon: "globe",
                title: "Pays",
                subtitle: "Pays où vous avez besoin de soins",
                rightContent: {
                    HStack(spacing: 8) {
                        Text("🇫🇷")
                            .font(.title3)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textTertiary)
                    }
                },
                action: {}
            )
            
            AccountMenuItem(
                icon: "globe",
                title: "Langue",
                subtitle: "Langue du compte",
                rightContent: {
                    HStack(spacing: 8) {
                        Text("Français")
                            .font(.subheadline)
                            .foregroundColor(MonMentaleColors.textPrimary)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textTertiary)
                    }
                },
                action: { showingLanguageSelector = true }
            )
            
            AccountMenuItem(
                icon: "key",
                title: "Double authentification",
                subtitle: "Protection supplémentaire lorsque vous vous connectez à votre compte",
                rightContent: {
                    HStack(spacing: 8) {
                        Text("Activée")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .clipShape(Capsule())
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textTertiary)
                    }
                },
                action: {}
            )
            
            AccountMenuItem(
                icon: "shield.checkered",
                title: "Documents chiffrés",
                subtitle: "Tous vos documents protégés avec le plus haut standard de sécurité",
                rightContent: {
                    HStack(spacing: 8) {
                        Text("Activé")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .clipShape(Capsule())
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textTertiary)
                    }
                },
                action: {}
            )
        }
    }
    
    // MARK: - Advanced Privacy Section
    private var advancedPrivacySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Confidentialité")
            
            AccountMenuItem(
                icon: "person.circle",
                title: "Mes préférences",
                action: {}
            )
            
            AccountMenuItem(
                icon: "doc.text",
                title: "Informations légales",
                action: {}
            )
            
            AccountMenuItem(
                icon: "trash",
                title: "Supprimer mon compte",
                textColor: .red,
                action: { showingDeleteAccount = true }
            )
        }
    }
    
    // MARK: - Logout Section
    private var logoutSection: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(MonMentaleColors.neutralGray)
            
            Button(action: {
                // Action de déconnexion
            }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                        .foregroundColor(.red)
                        .font(.title3)
                    
                    Text("Déconnexion")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.textTertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
    }
    
    // MARK: - Version Section
    private var versionSection: some View {
        VStack(spacing: 8) {
            Text("v1.0.0")
                .font(.caption)
                .foregroundColor(MonMentaleColors.textTertiary)
                .padding(.top, 16)
        }
    }
    
    // MARK: - Helper Methods
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(MonMentaleColors.textSecondary)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
}

// MARK: - Account Menu Item
struct AccountMenuItem<RightContent: View>: View {
    let icon: String
    let title: String
    let subtitle: String?
    let textColor: Color
    let rightContent: (() -> RightContent)?
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        textColor: Color = MonMentaleColors.textPrimary,
        @ViewBuilder rightContent: (() -> RightContent)? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.textColor = textColor
        self.rightContent = rightContent
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(MonMentaleColors.primaryBlue)
                    .font(.title3)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(textColor)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textSecondary)
                    }
                }
                
                Spacer()
                
                if let rightContent = rightContent {
                    rightContent()
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.textTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Modals

struct PasswordChangeModal: View {
    @Binding var isPresented: Bool
    @State private var oldPassword = ""
    @State private var newPassword = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ancien mot de passe (requis)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    SecureField("••••••••", text: $oldPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Nouveau mot de passe (requis)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        SecureField("••••••••", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Votre mot de passe doit comporter au moins 8 caractères. Il doit contenir des lettres et au moins un caractère spécial.")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textSecondary)
                    }
                }
                
                Spacer()
                
                Button("ENREGISTRER") {
                    isPresented = false
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(MonMentaleColors.primaryBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(24)
            .navigationTitle("Modifier votre mot de passe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title2)
                }
            }
        }
    }
}

struct EmailChangeModal: View {
    @Binding var isPresented: Bool
    @State private var newEmail = "timothee.berthelot1@gmail.com"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nouvel e-mail")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Ex : dupont.pierre@example.com")
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.textSecondary)
                    
                    TextField("timothee.berthelot1@gmail.com", text: $newEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                Button("SUIVANT") {
                    isPresented = false
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(MonMentaleColors.primaryBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(24)
            .navigationTitle("Modifier l'e-mail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title2)
                }
            }
        }
    }
}

struct PhoneChangeModal: View {
    @Binding var isPresented: Bool
    @State private var newPhone = "06 59 24 68 85"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nouveau téléphone")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("06 59 24 68 85", text: $newPhone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                Button("ENREGISTRER") {
                    isPresented = false
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(MonMentaleColors.primaryBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(24)
            .navigationTitle("Modifier le téléphone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title2)
                }
            }
        }
    }
}

struct PaymentSettingsModal: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "creditcard")
                        .font(.system(size: 60))
                        .foregroundColor(MonMentaleColors.primaryBlue)
                    
                    Text("Aucun moyen de paiement enregistré")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Vous pouvez ajouter un moyen de paiement lorsque vous prenez un rendez-vous")
                        .font(.subheadline)
                        .foregroundColor(MonMentaleColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Moyens de paiement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("✕") {
                        isPresented = false
                    }
                    .font(.title2)
                }
            }
        }
    }
}

// MARK: - Preview
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LocalizationManager.shared)
    }
}

