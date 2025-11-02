import SwiftUI

// MARK: - Main Tab View Style Doctolib
// Navigation principale inspirée de Doctolib avec couleurs pastel

struct MainTabViewDoctolibStyle: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Accueil
            HomeViewDoctolibStyle()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text(LocalizedKeys.Navigation.home.localized)
                }
                .tag(0)
            
            // Rendez-vous
            AppointmentsViewDoctolibStyle()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar.fill" : "calendar")
                    Text(LocalizedKeys.Navigation.appointments.localized)
                }
                .tag(1)
            
            // Santé mentale
            MentalHealthView()
                .tabItem {
                    ZStack {
                        Image(systemName: selectedTab == 2 ? "heart.fill" : "heart")
                        if selectedTab == 2 {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        }
                    }
                    Text("Santé")
                }
                .tag(2)
            
            // Messages
            MessagesViewDoctolibStyle()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "envelope.fill" : "envelope")
                    Text(LocalizedKeys.Navigation.messages.localized)
                }
                .tag(3)
            
            // Compte
            AccountView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.circle.fill" : "person.circle")
                    Text("Compte")
                }
                .tag(4)
        }
        .accentColor(MonMentaleColors.primaryBlue)
        .background(MonMentaleColors.backgroundPrimary)
    }
}

// MARK: - Appointments View Style Doctolib
struct AppointmentsViewDoctolibStyle: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Mes rendez-vous")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(MonMentaleColors.headerBackground)
                
                // Onglets
                HStack(spacing: 0) {
                    TabButton(
                        title: "À venir",
                        isSelected: selectedTab == 0
                    ) {
                        selectedTab = 0
                    }
                    
                    TabButton(
                        title: "Passés",
                        isSelected: selectedTab == 1
                    ) {
                        selectedTab = 1
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(MonMentaleColors.backgroundCard)
                
                // Contenu
                if selectedTab == 0 {
                    UpcomingAppointmentsViewDoctolibStyle()
                } else {
                    PastAppointmentsViewDoctolibStyle()
                }
            }
            .background(MonMentaleColors.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Mental Health View
struct MentalHealthView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header avec titre
                    VStack(spacing: 16) {
                        Text("Votre compagnon de santé au quotidien")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(MonMentaleColors.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Section 1: Accès aux soins
                    HealthFeatureCard(
                        icon: "calendar",
                        title: "Accédez aux soins plus facilement",
                        description: "Réservez des consultations vidéo ou en présentiel, et recevez des rappels pour ne jamais les manquer.",
                        color: MonMentaleColors.primaryBlue
                    )
                    
                    // Section 2: Soins personnalisés
                    HealthFeatureCard(
                        icon: "message",
                        title: "Bénéficiez de soins personnalisés",
                        description: "Échangez avec vos soignants par message, obtenez des conseils préventifs et recevez des soins quand vous en avez besoin.",
                        color: MonMentaleColors.secondaryPink
                    )
                    
                    // Section 3: Gestion de la santé
                    HealthFeatureCard(
                        icon: "heart",
                        title: "Gérez votre santé mentale",
                        description: "Rassemblez facilement toutes vos informations de santé mentale et celles de ceux qui comptent pour vous.",
                        color: MonMentaleColors.complementaryGreen
                    )
                    
                    // Statistiques
                    VStack(spacing: 16) {
                        Text("Mon Mentale en chiffres")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(MonMentaleColors.textPrimary)
                        
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
                    }
                    .padding(.horizontal, 16)
                }
            }
            .background(MonMentaleColors.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Messages View Style Doctolib
struct MessagesViewDoctolibStyle: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Mes messages")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(MonMentaleColors.headerBackground)
                
                // Contenu principal
                VStack(spacing: 24) {
                    // Illustration
                    VStack(spacing: 16) {
                        Image(systemName: "envelope")
                            .font(.system(size: 60))
                            .foregroundColor(MonMentaleColors.primaryBlue)
                        
                        Text("Envoyez facilement des messages aux soignants")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(MonMentaleColors.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("Échangez des messages avec vos soignants. Posez une question sur des résultats d'examen, demandez un courrier d'adressage, et plus encore.")
                            .font(.subheadline)
                            .foregroundColor(MonMentaleColors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Voir comment envoyer une demande") {
                            // Action
                        }
                        .font(.subheadline)
                        .foregroundColor(MonMentaleColors.primaryBlue)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Bouton d'action flottant
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Envoyer un message")
                        }
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(MonMentaleColors.primaryBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(MonMentaleColors.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Upcoming Appointments View Style Doctolib
struct UpcomingAppointmentsViewDoctolibStyle: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Message d'état vide
                VStack(spacing: 16) {
                    Image(systemName: "calendar")
                        .font(.system(size: 60))
                        .foregroundColor(MonMentaleColors.primaryBlue)
                    
                    Text("Aucun rendez-vous à venir")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(MonMentaleColors.textPrimary)
                    
                    Text("Prenez votre santé en main. Réservez facilement votre prochain rendez-vous sur Mon Mentale.")
                        .font(.subheadline)
                        .foregroundColor(MonMentaleColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("PRENDRE RENDEZ-VOUS")
                        }
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(MonMentaleColors.primaryBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }
                .padding(.top, 60)
                
                Spacer()
            }
        }
        .background(MonMentaleColors.backgroundPrimary)
    }
}

// MARK: - Past Appointments View Style Doctolib
struct PastAppointmentsViewDoctolibStyle: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Aucun rendez-vous passé")
                    .font(.headline)
                    .foregroundColor(MonMentaleColors.textPrimary)
                    .padding(.top, 60)
                
                Spacer()
            }
        }
        .background(MonMentaleColors.backgroundPrimary)
    }
}

// MARK: - Supporting Views

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? MonMentaleColors.primaryBlue : MonMentaleColors.textSecondary)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isSelected ? MonMentaleColors.primaryBlue : Color.clear)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct HealthFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(MonMentaleColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(MonMentaleColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .background(MonMentaleColors.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: MonMentaleColors.textPrimary.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
struct MainTabViewDoctolibStyle_Previews: PreviewProvider {
    static var previews: some View {
        MainTabViewDoctolibStyle(selectedTab: .constant(0))
            .environmentObject(AppState())
            .environmentObject(LocalizationManager.shared)
    }
}

