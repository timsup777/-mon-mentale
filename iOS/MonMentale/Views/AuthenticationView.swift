import SwiftUI

// MARK: - Authentication View
// Vue d'authentification avec design pastel fluide

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isLoginMode = true
    @State private var showingForgotPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header avec logo
                    headerSection
                    
                    // Formulaire d'authentification
                    formSection
                    
                    // Actions supplémentaires
                    additionalActionsSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
            }
            .background(MonMentaleColors.backgroundGradient)
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Logo avec animation
            ZStack {
                Circle()
                    .fill(MonMentaleColors.primaryGradient)
                    .frame(width: 120, height: 120)
                    .scaleEffect(viewModel.isLoading ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: viewModel.isLoading)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Mon Mentale")
                    .largeTitleStyle()
                    .foregroundColor(MonMentaleColors.primaryBlueDark)
                
                Text("Votre bien-être mental, notre priorité")
                    .bodyStyle()
                    .multilineTextAlignment(.center)
                    .foregroundColor(MonMentaleColors.textSecondary)
            }
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        MonMentaleCard(style: .elevated) {
            VStack(spacing: 24) {
                // Toggle Login/Register
                Picker("Mode", selection: $isLoginMode) {
                    Text("Connexion").tag(true)
                    Text("Inscription").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(MonMentaleColors.neutralGray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Champs du formulaire
                VStack(spacing: 20) {
                    if !isLoginMode {
                        // Prénom et nom pour l'inscription
                        HStack(spacing: 16) {
                            MonMentaleTextField(
                                title: "Prénom",
                                placeholder: "Votre prénom",
                                text: $viewModel.firstName,
                                errorMessage: viewModel.firstNameError
                            )
                            
                            MonMentaleTextField(
                                title: "Nom",
                                placeholder: "Votre nom",
                                text: $viewModel.lastName,
                                errorMessage: viewModel.lastNameError
                            )
                        }
                    }
                    
                    MonMentaleTextField(
                        title: "Email",
                        placeholder: "votre@email.com",
                        text: $viewModel.email,
                        errorMessage: viewModel.emailError
                    )
                    
                    MonMentaleTextField(
                        title: "Mot de passe",
                        placeholder: "Votre mot de passe",
                        text: $viewModel.password,
                        isSecure: true,
                        errorMessage: viewModel.passwordError
                    )
                    
                    if !isLoginMode {
                        MonMentaleTextField(
                            title: "Confirmer le mot de passe",
                            placeholder: "Confirmez votre mot de passe",
                            text: $viewModel.confirmPassword,
                            isSecure: true,
                            errorMessage: viewModel.confirmPasswordError
                        )
                        
                        // Sélection du rôle
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Je suis un(e)")
                                .calloutStyle()
                            
                            Picker("Rôle", selection: $viewModel.userRole) {
                                Text("Patient").tag(UserRole.patient)
                                Text("Psychologue").tag(UserRole.psychologue)
                                Text("Psychiatre").tag(UserRole.psychiatre)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                }
                
                // Bouton principal
                if viewModel.isLoading {
                    MonMentaleLoadingView(message: isLoginMode ? "Connexion..." : "Inscription...")
                } else {
                    MonMentaleButton(
                        title: isLoginMode ? "Se connecter" : "S'inscrire",
                        style: .primary
                    ) {
                        Task {
                            if isLoginMode {
                                await viewModel.login()
                            } else {
                                await viewModel.register()
                            }
                        }
                    }
                }
                
                // Message d'erreur
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .calloutStyle()
                        .foregroundColor(MonMentaleColors.error)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    // MARK: - Additional Actions Section
    private var additionalActionsSection: some View {
        VStack(spacing: 16) {
            if isLoginMode {
                Button("Mot de passe oublié ?") {
                    showingForgotPassword = true
                }
                .calloutStyle()
                .foregroundColor(MonMentaleColors.primaryBlue)
            }
            
            HStack {
                Text(isLoginMode ? "Pas encore de compte ?" : "Déjà un compte ?")
                    .subheadlineStyle()
                
                Button(isLoginMode ? "S'inscrire" : "Se connecter") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isLoginMode.toggle()
                        viewModel.clearErrors()
                    }
                }
                .calloutStyle()
                .foregroundColor(MonMentaleColors.primaryBlue)
                .fontWeight(.semibold)
            }
        }
    }
}

// MARK: - Authentication ViewModel
@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var userRole: UserRole = .patient
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Validation errors
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    
    private let authService = AuthenticationService.shared
    
    func login() async {
        guard validateLoginForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = await authService.login(email: email, password: password)
            
            if result.success {
                // Connexion réussie
                print("Connexion réussie")
            } else {
                errorMessage = result.error ?? "Erreur de connexion"
            }
        } catch {
            errorMessage = "Erreur de connexion"
        }
        
        isLoading = false
    }
    
    func register() async {
        guard validateRegisterForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let userData = UserRegistrationData(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                role: userRole
            )
            
            let result = await authService.register(userData: userData)
            
            if result.success {
                // Inscription réussie
                print("Inscription réussie")
            } else {
                errorMessage = result.error ?? "Erreur d'inscription"
            }
        } catch {
            errorMessage = "Erreur d'inscription"
        }
        
        isLoading = false
    }
    
    private func validateLoginForm() -> Bool {
        clearErrors()
        var isValid = true
        
        if email.isEmpty {
            emailError = "L'email est requis"
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Format d'email invalide"
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Le mot de passe est requis"
            isValid = false
        }
        
        return isValid
    }
    
    private func validateRegisterForm() -> Bool {
        clearErrors()
        var isValid = true
        
        if firstName.isEmpty {
            firstNameError = "Le prénom est requis"
            isValid = false
        }
        
        if lastName.isEmpty {
            lastNameError = "Le nom est requis"
            isValid = false
        }
        
        if email.isEmpty {
            emailError = "L'email est requis"
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Format d'email invalide"
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Le mot de passe est requis"
            isValid = false
        } else if password.count < 6 {
            passwordError = "Le mot de passe doit contenir au moins 6 caractères"
            isValid = false
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "La confirmation du mot de passe est requise"
            isValid = false
        } else if password != confirmPassword {
            confirmPasswordError = "Les mots de passe ne correspondent pas"
            isValid = false
        }
        
        return isValid
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func clearErrors() {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        firstNameError = nil
        lastNameError = nil
        errorMessage = nil
    }
}

// MARK: - Supporting Types
struct UserRegistrationData {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let role: UserRole
}

struct AuthResult {
    let success: Bool
    let error: String?
}

// MARK: - Authentication Service
class AuthenticationService {
    static let shared = AuthenticationService()
    
    private init() {}
    
    func login(email: String, password: String) async -> AuthResult {
        // Simuler un appel API
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 secondes
        
        // Pour la démo, accepter n'importe quel email/password
        if !email.isEmpty && !password.isEmpty {
            return AuthResult(success: true, error: nil)
        } else {
            return AuthResult(success: false, error: "Email ou mot de passe incorrect")
        }
    }
    
    func register(userData: UserRegistrationData) async -> AuthResult {
        // Simuler un appel API
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 secondes
        
        // Pour la démo, accepter toute inscription
        return AuthResult(success: true, error: nil)
    }
}

// MARK: - Forgot Password View
struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 50))
                        .foregroundColor(MonMentaleColors.primaryBlue)
                    
                    Text("Mot de passe oublié")
                        .title2Style()
                    
                    Text("Entrez votre email pour recevoir un lien de réinitialisation")
                        .bodyStyle()
                        .multilineTextAlignment(.center)
                        .foregroundColor(MonMentaleColors.textSecondary)
                }
                
                // Formulaire
                MonMentaleCard(style: .standard) {
                    VStack(spacing: 20) {
                        MonMentaleTextField(
                            title: "Email",
                            placeholder: "votre@email.com",
                            text: $email
                        )
                        
                        if isLoading {
                            MonMentaleLoadingView(message: "Envoi en cours...")
                        } else {
                            MonMentaleButton(
                                title: "Envoyer le lien",
                                style: .primary
                            ) {
                                sendResetLink()
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 40)
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle("Réinitialisation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Email envoyé", isPresented: $showingSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Un lien de réinitialisation a été envoyé à votre adresse email.")
        }
    }
    
    private func sendResetLink() {
        isLoading = true
        
        Task {
            // Simuler l'envoi d'email
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 secondes
            
            isLoading = false
            showingSuccess = true
        }
    }
}

// MARK: - Preview
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}

