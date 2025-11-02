import SwiftUI

// MARK: - Main Content View
// Vue principale avec navigation fluide et design pastel

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if appState.isAuthenticated {
                MainTabView(selectedTab: $selectedTab)
            } else {
                AuthenticationView()
            }
        }
        .background(MonMentaleColors.backgroundGradient)
        .ignoresSafeArea()
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Accueil
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Accueil")
                }
                .tag(0)
            
            // Recherche
            SearchView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                    Text("Rechercher")
                }
                .tag(1)
            
            // Rendez-vous
            AppointmentsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "calendar.circle.fill" : "calendar.circle")
                    Text("Rendez-vous")
                }
                .tag(2)
            
            // Messages
            MessagesView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "message.circle.fill" : "message.circle")
                    Text("Messages")
                }
                .tag(3)
            
            // Profil
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.circle.fill" : "person.circle")
                    Text("Profil")
                }
                .tag(4)
        }
        .accentColor(MonMentaleColors.primaryBlue)
        .background(MonMentaleColors.backgroundPrimary)
    }
}

// MARK: - Home View
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingSearch = false
    @State private var showingMoodSelector = false
    @State private var currentMood: MoodLevel = .okay
    @State private var hasSelectedMoodToday = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header avec salutation
                    headerSection
                    
                    // Section d'humeur
                    if !hasSelectedMoodToday {
                        moodPromptSection
                    } else {
                        moodStatusSection
                    }
                    
                    // Statistiques rapides
                    statsSection
                    
                    // Rendez-vous à venir
                    upcomingAppointmentsSection
                    
                    // Praticiens recommandés
                    recommendedPractitionersSection
                    
                    // Ressources bien-être
                    wellnessResourcesSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle(LocalizedKeys.App.name.localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSearch = true }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchView()
        }
        .sheet(isPresented: $showingMoodSelector) {
            MoodSelectorModal(isPresented: $showingMoodSelector)
        }
        .onAppear {
            viewModel.loadData()
            checkMoodSelectionStatus()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        MonMentaleCard(style: .gradient) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedKeys.Home.greeting.localized)
                            .calloutStyle()
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(LocalizedKeys.Home.how_do_you_feel_today.localized)
                            .title2Style()
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Bouton d'état d'humeur
                    Button(action: { 
                        showingMoodSelector = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            if hasSelectedMoodToday {
                                // Afficher l'humeur sélectionnée
                                Image(systemName: currentMood.icon)
                                    .font(.title2)
                                    .foregroundColor(.white)
                            } else {
                                // Afficher l'invitation à sélectionner
                                VStack(spacing: 2) {
                                    Image(systemName: "face.smiling")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 6, height: 6)
                                }
                            }
                        }
                    }
                    .scaleEffect(hasSelectedMoodToday ? 1.0 : 1.1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasSelectedMoodToday)
                }
                
                // Barre de recherche rapide
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(LocalizedKeys.Home.search_placeholder.localized)
                        .calloutStyle()
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Rendez-vous",
                value: "3",
                subtitle: "Cette semaine",
                color: MonMentaleColors.primaryBlue
            )
            
            StatCard(
                title: "Sessions",
                value: "12",
                subtitle: "Ce mois",
                color: MonMentaleColors.secondaryPink
            )
            
            StatCard(
                title: "Progrès",
                value: "85%",
                subtitle: "Objectifs",
                color: MonMentaleColors.complementaryGreen
            )
        }
    }
    
    // MARK: - Upcoming Appointments Section
    private var upcomingAppointmentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Rendez-vous à venir")
                    .title3Style()
                
                Spacer()
                
                Button("Voir tout") {
                    // Navigation vers la liste complète
                }
                .calloutStyle()
                .foregroundColor(MonMentaleColors.primaryBlue)
            }
            
            if viewModel.upcomingAppointments.isEmpty {
                MonMentaleEmptyState(
                    icon: "calendar.badge.clock",
                    title: "Aucun rendez-vous",
                    message: "Vous n'avez pas de rendez-vous programmé pour le moment.",
                    actionTitle: "Prendre rendez-vous"
                ) {
                    // Action pour prendre rendez-vous
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.upcomingAppointments) { appointment in
                        AppointmentCard(appointment: appointment)
                    }
                }
            }
        }
    }
    
    // MARK: - Recommended Practitioners Section
    private var recommendedPractitionersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recommandés pour vous")
                    .title3Style()
                
                Spacer()
                
                Button("Voir tout") {
                    // Navigation vers la recherche
                }
                .calloutStyle()
                .foregroundColor(MonMentaleColors.primaryBlue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.recommendedPractitioners) { practitioner in
                        PractitionerCard(practitioner: practitioner)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Wellness Resources Section
    private var wellnessResourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ressources bien-être")
                .title3Style()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                WellnessResourceCard(
                    title: "Méditation",
                    icon: "leaf.fill",
                    color: MonMentaleColors.calm
                )
                
                WellnessResourceCard(
                    title: "Exercices",
                    icon: "figure.walk",
                    color: MonMentaleColors.wellness
                )
                
                WellnessResourceCard(
                    title: "Journal",
                    icon: "book.fill",
                    color: MonMentaleColors.therapy
                )
                
                WellnessResourceCard(
                    title: "Relaxation",
                    icon: "heart.fill",
                    color: MonMentaleColors.anxiety
                )
            }
        }
    }
    
    // MARK: - Mood Prompt Section
    private var moodPromptSection: some View {
        MonMentaleCard(style: .elevated) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comment vous sentez-vous ?")
                            .title3Style()
                        
                        Text("Prenez un moment pour évaluer votre humeur")
                            .subheadlineStyle()
                    }
                    
                    Spacer()
                    
                    // Animation d'invitation
                    VStack(spacing: 4) {
                        Image(systemName: "hand.tap.fill")
                            .font(.title2)
                            .foregroundColor(MonMentaleColors.primaryBlue)
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: hasSelectedMoodToday)
                        
                        Text("Touchez")
                            .captionStyle()
                            .foregroundColor(MonMentaleColors.textSecondary)
                    }
                }
                
                // Mini barre d'humeur
                HStack(spacing: 8) {
                    ForEach(MoodLevel.allCases, id: \.self) { mood in
                        Circle()
                            .fill(mood.color.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                }
                
                MonMentaleButton(
                    title: "Évaluer mon humeur",
                    style: .primary
                ) {
                    showingMoodSelector = true
                }
            }
        }
    }
    
    // MARK: - Mood Status Section
    private var moodStatusSection: some View {
        MonMentaleCard(style: .gradient) {
            HStack(spacing: 16) {
                // Cercle d'humeur
                ZStack {
                    Circle()
                        .fill(currentMood.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .fill(currentMood.color)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: currentMood.icon)
                                .font(.title3)
                                .foregroundColor(.white)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Votre humeur aujourd'hui")
                        .calloutStyle()
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(currentMood.displayName)
                        .title3Style()
                        .foregroundColor(.white)
                    
                    Text(currentMood.description)
                        .subheadlineStyle()
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    showingMoodSelector = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func checkMoodSelectionStatus() {
        // Vérifier si l'utilisateur a déjà sélectionné son humeur aujourd'hui
        let today = Calendar.current.startOfDay(for: Date())
        let lastMoodSelection = UserDefaults.standard.object(forKey: "lastMoodSelection") as? Date
        
        if let lastSelection = lastMoodSelection,
           Calendar.current.isDate(lastSelection, inSameDayAs: today) {
            hasSelectedMoodToday = true
            
            // Récupérer l'humeur sauvegardée
            if let moodData = UserDefaults.standard.data(forKey: "currentMood"),
               let mood = try? JSONDecoder().decode(MoodLevel.self, from: moodData) {
                currentMood = mood
            }
        } else {
            hasSelectedMoodToday = false
        }
    }
    
    private func saveMood(_ mood: MoodLevel) {
        currentMood = mood
        hasSelectedMoodToday = true
        
        // Sauvegarder dans UserDefaults
        UserDefaults.standard.set(Date(), forKey: "lastMoodSelection")
        
        if let moodData = try? JSONEncoder().encode(mood) {
            UserDefaults.standard.set(moodData, forKey: "currentMood")
        }
        
        // Envoyer à l'API si nécessaire
        // viewModel.saveMood(mood)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        MonMentaleCard(style: .standard) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .captionStyle()
                
                Text(value)
                    .title2Style()
                    .foregroundColor(color)
                
                Text(subtitle)
                    .footnoteStyle()
            }
        }
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        MonMentaleCard(style: .outlined) {
            HStack(spacing: 16) {
                // Avatar du praticien
                Circle()
                    .fill(MonMentaleColors.primaryGradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(appointment.practitioner.name.prefix(1))
                            .title3Style()
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.practitioner.name)
                        .calloutStyle()
                    
                    Text(appointment.service)
                        .subheadlineStyle()
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(MonMentaleColors.textSecondary)
                        Text(appointment.time)
                            .footnoteStyle()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(appointment.date)
                        .footnoteStyle()
                    
                    MonMentaleBadge(text: appointment.status, style: .primary)
                }
            }
        }
    }
}

struct PractitionerCard: View {
    let practitioner: Practitioner
    
    var body: some View {
        MonMentaleCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 12) {
                // Photo du praticien
                RoundedRectangle(cornerRadius: 12)
                    .fill(MonMentaleColors.primaryGradient)
                    .frame(height: 120)
                    .overlay(
                        VStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(practitioner.name)
                        .calloutStyle()
                    
                    Text(practitioner.specialization)
                        .subheadlineStyle()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(MonMentaleColors.warning)
                        Text(String(format: "%.1f", practitioner.rating))
                            .footnoteStyle()
                    }
                    
                    Text("\(practitioner.price)€/session")
                        .footnoteStyle()
                        .foregroundColor(MonMentaleColors.primaryBlue)
                }
            }
        }
        .frame(width: 200)
    }
}

struct WellnessResourceCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        MonMentaleCard(style: .standard) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .calloutStyle()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
            .environmentObject(AuthenticationManager())
    }
}
