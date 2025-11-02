import SwiftUI

// MARK: - Placeholder Views
// Vues temporaires pour les écrans non encore implémentés

// MARK: - Search View
struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedFilters: Set<String> = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Barre de recherche
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(MonMentaleColors.textSecondary)
                    
                    TextField("Rechercher un psychologue...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(MonMentaleColors.backgroundCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(MonMentaleColors.neutralGray, lineWidth: 1)
                )
                
                // Filtres
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(title: "Psychologue", isSelected: selectedFilters.contains("psychologue"))
                        FilterChip(title: "Psychiatre", isSelected: selectedFilters.contains("psychiatre"))
                        FilterChip(title: "Téléconsultation", isSelected: selectedFilters.contains("teleconsultation"))
                        FilterChip(title: "Près de moi", isSelected: selectedFilters.contains("nearby"))
                    }
                    .padding(.horizontal, 16)
                }
                
                // Résultats
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<10) { index in
                            PractitionerCard(
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
            .padding(.horizontal, 16)
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle("Rechercher")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Appointments View
struct AppointmentsView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Onglets
                Picker("Type", selection: $selectedTab) {
                    Text("À venir").tag(0)
                    Text("Passés").tag(1)
                    Text("Annulés").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                // Contenu
                TabView(selection: $selectedTab) {
                    UpcomingAppointmentsView()
                        .tag(0)
                    
                    PastAppointmentsView()
                        .tag(1)
                    
                    CancelledAppointmentsView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle("Rendez-vous")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Messages View
struct MessagesView: View {
    var body: some View {
        NavigationView {
            MonMentaleEmptyState(
                icon: "message.circle",
                title: "Messages",
                message: "Vos conversations avec vos praticiens apparaîtront ici.",
                actionTitle: "Commencer une conversation"
            ) {
                // Action pour commencer une conversation
            }
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @State private var showingSettings = false
    @State private var showingLanguageSelector = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profil utilisateur
                    MonMentaleCard(style: .elevated) {
                        VStack(spacing: 16) {
                            // Avatar
                            Circle()
                                .fill(MonMentaleColors.primaryGradient)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text("JD")
                                        .title2Style()
                                        .foregroundColor(.white)
                                )
                            
                            VStack(spacing: 8) {
                                Text("John Doe")
                                    .title2Style()
                                
                                Text("john.doe@email.com")
                                    .subheadlineStyle()
                                    .foregroundColor(MonMentaleColors.textSecondary)
                                
                                MonMentaleBadge(text: "Patient", style: .primary)
                            }
                        }
                    }
                    
                    // Statistiques
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Sessions",
                            value: "12",
                            subtitle: "Ce mois",
                            color: MonMentaleColors.primaryBlue
                        )
                        
                        StatCard(
                            title: "Progrès",
                            value: "85%",
                            subtitle: "Objectifs",
                            color: MonMentaleColors.complementaryGreen
                        )
                    }
                    
                    // Menu des options
                    VStack(spacing: 12) {
                        ProfileMenuItem(
                            icon: "person.circle",
                            title: LocalizedKeys.Profile.personal_info.localized,
                            color: MonMentaleColors.primaryBlue
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: LocalizedKeys.Profile.payment_methods.localized,
                            color: MonMentaleColors.secondaryPink
                        )
                        
                        ProfileMenuItem(
                            icon: "bell",
                            title: LocalizedKeys.Profile.notifications.localized,
                            color: MonMentaleColors.accentPurple
                        )
                        
                        // Sélecteur de langue
                        ProfileMenuItem(
                            icon: "globe",
                            title: LocalizedKeys.Settings.language.localized,
                            color: MonMentaleColors.complementaryGreen
                        ) {
                            showingLanguageSelector = true
                        }
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle",
                            title: LocalizedKeys.Profile.help_support.localized,
                            color: MonMentaleColors.complementaryGreen
                        )
                        
                        ProfileMenuItem(
                            icon: "gear",
                            title: LocalizedKeys.Profile.settings.localized,
                            color: MonMentaleColors.neutralGrayDark
                        ) {
                            showingSettings = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(MonMentaleColors.backgroundGradient)
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingLanguageSelector) {
            LanguageSelectorModal(isPresented: $showingLanguageSelector)
        }
    }
}

// MARK: - Supporting Views

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: (() -> Void)?
    
    init(title: String, isSelected: Bool, action: (() -> Void)? = nil) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            Text(title)
                .calloutStyle()
                .foregroundColor(isSelected ? .white : MonMentaleColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? MonMentaleColors.primaryBlue : MonMentaleColors.backgroundCard
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(MonMentaleColors.primaryBlue, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct UpcomingAppointmentsView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<5) { index in
                    AppointmentCard(
                        appointment: Appointment(
                            id: "\(index)",
                            patientId: "patient1",
                            practitionerId: "practitioner1",
                            practitioner: Practitioner(
                                id: "practitioner1",
                                userId: "user1",
                                name: "Dr. Marie Dubois",
                                specialization: "Psychologue",
                                specializations: ["Psychologie clinique"],
                                description: "Description",
                                approach: "Approche",
                                experience: 5,
                                languages: ["Français"],
                                licenseNumber: "PSY123",
                                university: "Université",
                                graduationYear: 2020,
                                rating: 4.5,
                                totalReviews: 100,
                                price: 60.0,
                                consultationTypes: [.presentiel],
                                address: Address(
                                    street: "Rue de la Paix",
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
                            ),
                            date: Calendar.current.date(byAdding: .day, value: index + 1, to: Date()) ?? Date(),
                            time: "14:30",
                            duration: 45,
                            type: .presentiel,
                            status: .confirmed,
                            reason: "Suivi thérapeutique",
                            notes: nil,
                            price: 60.0,
                            location: nil,
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

struct PastAppointmentsView: View {
    var body: some View {
        MonMentaleEmptyState(
            icon: "clock.arrow.circlepath",
            title: "Aucun rendez-vous passé",
            message: "Vos rendez-vous terminés apparaîtront ici."
        )
    }
}

struct CancelledAppointmentsView: View {
    var body: some View {
        MonMentaleEmptyState(
            icon: "xmark.circle",
            title: "Aucun rendez-vous annulé",
            message: "Vos rendez-vous annulés apparaîtront ici."
        )
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: (() -> Void)?
    
    init(icon: String, title: String, color: Color, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .calloutStyle()
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(MonMentaleColors.textTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(MonMentaleColors.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Paramètres")
                    .title1Style()
                
                Spacer()
                
                MonMentaleEmptyState(
                    icon: "gear",
                    title: "Paramètres",
                    message: "Les paramètres de l'application seront disponibles ici."
                )
                
                Spacer()
            }
            .padding()
            .background(MonMentaleColors.backgroundGradient)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}
