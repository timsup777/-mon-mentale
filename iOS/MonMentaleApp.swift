import SwiftUI

@main
struct MonMentaleApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var localizationManager = LocalizationManager.shared
    
    init() {
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoading {
                LoadingView()
                    .environmentObject(localizationManager)
            } else {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(localizationManager)
                    .onAppear {
                        setupApp()
                    }
            }
        }
    }
    
    private func configureAppearance() {
        // Configuration de l'apparence globale
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private func setupApp() {
        // Démarrer le chargement
        appState.isLoading = true
        
        Task {
            // Simuler un chargement de 3 secondes
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            // Terminer le chargement
            await MainActor.run {
                appState.isLoading = false
            }
        }
    }
}

// MARK: - App State Management

@MainActor
class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // Initialisation
    }
}

// MARK: - User Model

struct User: Codable, Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let userType: UserType
    
    enum UserType: String, Codable, CaseIterable {
        case patient = "patient"
        case psychologist = "psychologist"
        case psychiatrist = "psychiatrist"
    }
}

// MARK: - Localization Manager

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String = "fr"
    
    private init() {}
    
    func setLanguage(_ language: String) {
        currentLanguage = language
    }
    
    func localizedString(for key: String) -> String {
        // Pour la démo, retournons simplement la clé
        return key
    }
}

// MARK: - Color Palette

struct MonMentaleColors {
    // MARK: - Primary Colors (Pastel pour santé mentale)
    static let primaryBlue = Color(red: 0.6, green: 0.8, blue: 0.95) // Bleu ciel doux
    static let primaryBlueDark = Color(red: 0.4, green: 0.6, blue: 0.85) // Bleu plus profond
    static let primaryBlueLight = Color(red: 0.8, green: 0.9, blue: 0.98) // Bleu très clair
    
    // MARK: - Secondary Colors (Rose pastel)
    static let secondaryPink = Color(red: 0.95, green: 0.8, blue: 0.85) // Rose poudré
    static let secondaryPinkDark = Color(red: 0.85, green: 0.6, blue: 0.75) // Rose plus profond
    static let secondaryPinkLight = Color(red: 0.98, green: 0.9, blue: 0.92) // Rose très clair
    
    // MARK: - Accent Colors (Pastel complémentaires)
    static let accentPurple = Color(red: 0.7, green: 0.6, blue: 0.9) // Lavande
    static let complementaryGreen = Color(red: 0.7, green: 0.9, blue: 0.8) // Vert menthe
    static let anxiety = Color(red: 0.9, green: 0.7, blue: 0.7) // Rouge doux pour l'anxiété
    static let depression = Color(red: 0.6, green: 0.7, blue: 0.9) // Bleu doux pour la dépression
    static let stress = Color(red: 0.9, green: 0.85, blue: 0.6) // Jaune doux pour le stress
    
    // MARK: - Neutral Colors
    static let neutralGrayLight = Color(red: 0.9, green: 0.9, blue: 0.9) // Gris très clair
    static let neutralGrayMedium = Color(red: 0.8, green: 0.8, blue: 0.85) // Gris clair
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
}

// MARK: - Loading View

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ZStack {
            // Arrière-plan avec dégradé pastel
            LinearGradient(
                gradient: Gradient(colors: [
                    MonMentaleColors.primaryBlue.opacity(0.1),
                    MonMentaleColors.secondaryPink.opacity(0.1),
                    MonMentaleColors.accentPurple.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Icône Psi (Ψ) animée
                ZStack {
                    // Cercle de fond avec animation de pulsation
                    Circle()
                        .fill(MonMentaleColors.primaryBlue.opacity(0.1))
                        .frame(width: 200, height: 200)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.6)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    // Cercle intérieur
                    Circle()
                        .fill(MonMentaleColors.primaryBlue.opacity(0.2))
                        .frame(width: 150, height: 150)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    // Icône Psi (Ψ) principale
                    PsiIconView()
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                // Texte de chargement
                VStack(spacing: 16) {
                    Text("Mon Mentale")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(MonMentaleColors.textPrimary)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.5), value: showContent)
                    
                    Text("Votre compagnon de santé mentale")
                        .font(.headline)
                        .foregroundColor(MonMentaleColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeInOut(duration: 0.8).delay(0.8), value: showContent)
                    
                    // Indicateur de chargement
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(MonMentaleColors.primaryBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.2 : 0.8)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(1.0), value: showContent)
                }
                
                Spacer()
                
                // Version de l'app
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(MonMentaleColors.textTertiary)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8).delay(1.2), value: showContent)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showContent = true
            }
        }
    }
}

// MARK: - Psi Icon View

struct PsiIconView: View {
    var body: some View {
        ZStack {
            // Dessin de la lettre Psi (Ψ) avec des formes SwiftUI
            
            // Tige verticale centrale
            RoundedRectangle(cornerRadius: 2)
                .fill(MonMentaleColors.primaryBlue)
                .frame(width: 12, height: 60)
                .offset(y: 5)
            
            // Bras gauche (courbe supérieure gauche)
            Path { path in
                let centerX: CGFloat = 0
                let centerY: CGFloat = -15
                let radius: CGFloat = 25
                
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false
                )
            }
            .stroke(MonMentaleColors.primaryBlue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
            
            // Bras droit (courbe supérieure droite)
            Path { path in
                let centerX: CGFloat = 0
                let centerY: CGFloat = -15
                let radius: CGFloat = 25
                
                path.addArc(
                    center: CGPoint(x: centerX, y: centerY),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false
                )
            }
            .stroke(MonMentaleColors.primaryBlue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
        }
        .frame(width: 50, height: 50)
    }
}

// MARK: - Content View

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedMood: String?
    @State private var showMoodSelector = false
    @State private var hasSelectedMoodToday = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Mood Prompt Section
                    if !hasSelectedMoodToday {
                        moodPromptSection
                    } else {
                        moodStatusSection
                    }
                    
                    // Search Section
                    searchSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Recent Appointments
                    recentAppointmentsSection
                }
                .padding()
            }
            .navigationTitle("Mon Mentale")
            .background(MonMentaleColors.backgroundPrimary)
        }
        .sheet(isPresented: $showMoodSelector) {
            MoodSelectorModal(selectedMood: $selectedMood, isPresented: $showMoodSelector)
        }
        .onAppear {
            checkMoodSelectionStatus()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bonjour ! 👋")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(MonMentaleColors.textPrimary)
            
            Text("Comment vous sentez-vous aujourd'hui ?")
                .font(.body)
                .foregroundColor(MonMentaleColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(MonMentaleColors.backgroundCard)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var moodPromptSection: some View {
        VStack(spacing: 16) {
            Text("Prenez un moment pour évaluer votre humeur")
                .font(.headline)
                .foregroundColor(MonMentaleColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showMoodSelector = true
            }) {
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                    Text("Sélectionner mon humeur")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding()
                .background(MonMentaleColors.primaryBlue)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(MonMentaleColors.primaryBlueLight)
        .cornerRadius(16)
    }
    
    private var moodStatusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(MonMentaleColors.success)
                Text("Humeur enregistrée")
                    .font(.headline)
                    .foregroundColor(MonMentaleColors.textPrimary)
                Spacer()
            }
            
            if let mood = selectedMood {
                Text("Vous vous sentez : \(mood)")
                    .font(.body)
                    .foregroundColor(MonMentaleColors.textSecondary)
            }
        }
        .padding()
        .background(MonMentaleColors.success.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trouver un professionnel")
                .font(.headline)
                .foregroundColor(MonMentaleColors.textPrimary)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(MonMentaleColors.textTertiary)
                
                TextField("Rechercher un psychologue ou psychiatre...", text: .constant(""))
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(MonMentaleColors.searchBackground)
            .cornerRadius(12)
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actions rapides")
                .font(.headline)
                .foregroundColor(MonMentaleColors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickActionCard(
                    title: "Prendre RDV",
                    icon: "calendar",
                    color: MonMentaleColors.primaryBlue
                )
                
                QuickActionCard(
                    title: "Mes RDV",
                    icon: "list.bullet",
                    color: MonMentaleColors.secondaryPink
                )
                
                QuickActionCard(
                    title: "Messages",
                    icon: "message",
                    color: MonMentaleColors.accentPurple
                )
                
                QuickActionCard(
                    title: "Profil",
                    icon: "person",
                    color: MonMentaleColors.complementaryGreen
                )
            }
        }
    }
    
    private var recentAppointmentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rendez-vous récents")
                .font(.headline)
                .foregroundColor(MonMentaleColors.textPrimary)
            
            VStack(spacing: 8) {
                AppointmentRow(
                    title: "Dr. Martin",
                    specialty: "Psychologue",
                    date: "Aujourd'hui, 14h30",
                    status: "Confirmé"
                )
                
                AppointmentRow(
                    title: "Dr. Dubois",
                    specialty: "Psychiatre",
                    date: "Demain, 10h00",
                    status: "En attente"
                )
            }
        }
    }
    
    private func checkMoodSelectionStatus() {
        let today = DateFormatter().string(from: Date())
        let lastMoodDate = UserDefaults.standard.string(forKey: "lastMoodDate")
        hasSelectedMoodToday = lastMoodDate == today
        selectedMood = UserDefaults.standard.string(forKey: "selectedMood")
    }
    
    private func saveMood(_ mood: String) {
        let today = DateFormatter().string(from: Date())
        UserDefaults.standard.set(today, forKey: "lastMoodDate")
        UserDefaults.standard.set(mood, forKey: "selectedMood")
        selectedMood = mood
        hasSelectedMoodToday = true
    }
}

// MARK: - Supporting Views

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(MonMentaleColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(MonMentaleColors.backgroundCard)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct AppointmentRow: View {
    let title: String
    let specialty: String
    let date: String
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(MonMentaleColors.textPrimary)
                
                Text(specialty)
                    .font(.caption)
                    .foregroundColor(MonMentaleColors.textSecondary)
                
                Text(date)
                    .font(.caption)
                    .foregroundColor(MonMentaleColors.textTertiary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(MonMentaleColors.primaryBlue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(MonMentaleColors.primaryBlue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(MonMentaleColors.backgroundCard)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct MoodSelectorModal: View {
    @Binding var selectedMood: String?
    @Binding var isPresented: Bool
    
    let moods = [
        ("Très bien", "😊", MonMentaleColors.success),
        ("Bien", "😌", MonMentaleColors.complementaryGreen),
        ("Neutre", "😐", MonMentaleColors.neutralGrayMedium),
        ("Fatigué", "😴", MonMentaleColors.warning),
        ("Anxieux", "😰", MonMentaleColors.anxiety),
        ("Triste", "😢", MonMentaleColors.depression)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Comment vous sentez-vous ?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(MonMentaleColors.textPrimary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(moods, id: \.0) { mood in
                        MoodButton(
                            title: mood.0,
                            emoji: mood.1,
                            color: mood.2,
                            isSelected: selectedMood == mood.0
                        ) {
                            selectedMood = mood.0
                            isPresented = false
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sélectionner l'humeur")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Fermer") {
                isPresented = false
            })
        }
    }
}

struct MoodButton: View {
    let title: String
    let emoji: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.largeTitle)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(MonMentaleColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? color.opacity(0.2) : MonMentaleColors.backgroundCard)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

