import SwiftUI

// MARK: - Home View Style Doctolib avec couleurs pastel
// Page d'accueil inspirée de Doctolib mais adaptée pour la santé mentale

struct HomeViewDoctolibStyle: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingSearch = false
    @State private var showingMoodSelector = false
    @State private var currentMood: MoodLevel = .okay
    @State private var hasSelectedMoodToday = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header principal style Doctolib
                    headerSection
                    
                    // Section de recherche
                    searchSection
                    
                    // Section d'humeur (fonctionnalité unique Mon Mentale)
                    if !hasSelectedMoodToday {
                        moodPromptSection
                    } else {
                        moodStatusSection
                    }
                    
                    // Section des prochains rappels santé mentale
                    healthRemindersSection
                    
                    // Section des statistiques
                    statisticsSection
                    
                    // Section des praticiens recommandés
                    recommendedPractitionersSection
                }
            }
            .background(MonMentaleColors.backgroundPrimary)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSearch) {
            SearchViewDoctolibStyle()
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
        VStack(spacing: 0) {
            // Status bar simulé
            HStack {
                Text("17:34")
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
            VStack(spacing: 16) {
                HStack {
                    // Drapeau français
                    Text("🇫🇷")
                        .font(.title2)
                    
                    Spacer()
                    
                    // Logo Mon Mentale
                    Text("Mon Mentale")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Icône de notification
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                // Titre principal
                Text("Vivez en meilleure santé mentale")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Barre de recherche
                Button(action: { showingSearch = true }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(MonMentaleColors.textSecondary)
                        
                        Text("RECHERCHER")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(MonMentaleColors.textSecondary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(
            ZStack {
                MonMentaleColors.headerBackground
                
                // Formes décoratives pastel
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(MonMentaleColors.secondaryPink.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .offset(x: 20, y: -20)
                    }
                    Spacer()
                    HStack {
                        Circle()
                            .fill(MonMentaleColors.accentPurple.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .offset(x: -30, y: 20)
                        Spacer()
                    }
                }
            }
        )
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: 16) {
            // Cartes de recherche horizontales
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    SearchCard(
                        title: "Besoin de contacter votre psychologue suite à un rendez-vous ?",
                        image: "person.circle",
                        color: MonMentaleColors.primaryBlue
                    )
                    
                    SearchCard(
                        title: "Bilan de santé mentale recommandé",
                        image: "brain.head.profile",
                        color: MonMentaleColors.secondaryPink
                    )
                    
                    SearchCard(
                        title: "Séances de méditation guidée",
                        image: "leaf",
                        color: MonMentaleColors.complementaryGreen
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Mood Prompt Section
    private var moodPromptSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Comment vous sentez-vous aujourd'hui ?")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(MonMentaleColors.textPrimary)
                
                Spacer()
                
                Button(action: { showingMoodSelector = true }) {
                    Image(systemName: "hand.tap.fill")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.primaryBlue)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: hasSelectedMoodToday)
                }
            }
            .padding(.horizontal, 16)
            
            // Mini barre d'humeur
            HStack(spacing: 8) {
                ForEach(MoodLevel.allCases, id: \.self) { mood in
                    Circle()
                        .fill(mood.color.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(MonMentaleColors.backgroundCard)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(MonMentaleColors.neutralGray),
            alignment: .bottom
        )
    }
    
    // MARK: - Mood Status Section
    private var moodStatusSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Votre humeur aujourd'hui")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(MonMentaleColors.textPrimary)
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(currentMood.color.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Circle()
                                .fill(currentMood.color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: currentMood.icon)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentMood.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(MonMentaleColors.textPrimary)
                            
                            Text(currentMood.description)
                                .font(.caption)
                                .foregroundColor(MonMentaleColors.textSecondary)
                        }
                        
                        Spacer()
                    }
                }
                
                Button(action: { showingMoodSelector = true }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(MonMentaleColors.primaryBlue)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(MonMentaleColors.backgroundCard)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(MonMentaleColors.neutralGray),
            alignment: .bottom
        )
    }
    
    // MARK: - Health Reminders Section
    private var healthRemindersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Prochains rappels santé mentale")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(MonMentaleColors.textPrimary)
                
                Spacer()
                
                Text("Nouveau")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(MonMentaleColors.primaryBlue)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 16)
            
            // Carte de rappel
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(MonMentaleColors.primaryBlue.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundColor(MonMentaleColors.primaryBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Prenez soin de votre bien-être mental")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(MonMentaleColors.textPrimary)
                        
                        Text("Recommandé une fois par semaine")
                            .font(.caption)
                            .foregroundColor(MonMentaleColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.textTertiary)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("PRENDRE RENDEZ-VOUS")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(MonMentaleColors.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(16)
            .background(MonMentaleColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mon Mentale en chiffres")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(MonMentaleColors.textPrimary)
                .padding(.horizontal, 16)
            
            HStack(spacing: 16) {
                StatisticCard(
                    number: "80 millions",
                    description: "de personnes mieux soignées",
                    color: MonMentaleColors.primaryBlue
                )
                
                StatisticCard(
                    number: "400.000",
                    description: "psychologues et psychiatres",
                    color: MonMentaleColors.secondaryPink
                )
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Recommended Practitioners Section
    private var recommendedPractitionersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommandés pour vous")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(MonMentaleColors.textPrimary)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.recommendedPractitioners) { practitioner in
                        PractitionerCardDoctolibStyle(practitioner: practitioner)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Helper Methods
    private func checkMoodSelectionStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastMoodSelection = UserDefaults.standard.object(forKey: "lastMoodSelection") as? Date
        
        if let lastSelection = lastMoodSelection,
           Calendar.current.isDate(lastSelection, inSameDayAs: today) {
            hasSelectedMoodToday = true
            
            if let moodData = UserDefaults.standard.data(forKey: "currentMood"),
               let mood = try? JSONDecoder().decode(MoodLevel.self, from: moodData) {
                currentMood = mood
            }
        } else {
            hasSelectedMoodToday = false
        }
    }
}

// MARK: - Supporting Views

struct SearchCard: View {
    let title: String
    let image: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(MonMentaleColors.textPrimary)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(width: 200, height: 120)
        .background(MonMentaleColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct StatisticCard: View {
    let number: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(number)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(description)
                .font(.caption)
                .foregroundColor(MonMentaleColors.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(MonMentaleColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PractitionerCardDoctolibStyle: View {
    let practitioner: Practitioner
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(MonMentaleColors.primaryGradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(practitioner.name.prefix(1))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(practitioner.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(MonMentaleColors.textPrimary)
                    
                    Text(practitioner.specialization)
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.textSecondary)
                }
                
                Spacer()
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.warning)
                    
                    Text(String(format: "%.1f", practitioner.rating))
                        .font(.caption)
                        .foregroundColor(MonMentaleColors.textPrimary)
                }
                
                Spacer()
                
                Text(practitioner.priceText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(MonMentaleColors.primaryBlue)
            }
        }
        .padding(16)
        .frame(width: 200)
        .background(MonMentaleColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Search View Style Doctolib
struct SearchViewDoctolibStyle: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Text("Rechercher")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(MonMentaleColors.headerBackground)
                
                // Contenu de recherche
                VStack(spacing: 20) {
                    // Barre de recherche
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(MonMentaleColors.textSecondary)
                        
                        TextField("Nom, spécialité, établissement...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(MonMentaleColors.searchBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    
                    // Résultats de recherche
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(0..<10) { index in
                                PractitionerCardDoctolibStyle(
                                    practitioner: Practitioner(
                                        id: "\(index)",
                                        userId: "user\(index)",
                                        name: "Dr. Praticien \(index + 1)",
                                        specialization: "Psychologue",
                                        specializations: ["Psychologie clinique"],
                                        description: "Description du praticien",
                                        approach: "Approche thérapeutique",
                                        experience: 5 + index,
                                        languages: ["Français"],
                                        licenseNumber: "PSY\(index)",
                                        university: "Université",
                                        graduationYear: 2020 - index,
                                        rating: 4.0 + Double(index) * 0.1,
                                        totalReviews: 50 + index * 10,
                                        price: 50.0 + Double(index) * 5,
                                        consultationTypes: [.presentiel, .teleconsultation],
                                        address: Address(
                                            street: "Rue \(index)",
                                            city: "Paris",
                                            postalCode: "75001",
                                            country: "France",
                                            coordinates: nil
                                        ),
                                        availability: Availability(
                                            monday: [],
                                            tuesday: [],
                                            wednesday: [],
                                            thursday: [],
                                            friday: [],
                                            saturday: [],
                                            sunday: []
                                        ),
                                        isVerified: true,
                                        isActive: true,
                                        avatar: nil,
                                        createdAt: Date(),
                                        updatedAt: Date()
                                    )
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .background(MonMentaleColors.backgroundPrimary)
        }
    }
}

// MARK: - Preview
struct HomeViewDoctolibStyle_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewDoctolibStyle()
            .environmentObject(LocalizationManager.shared)
    }
}

