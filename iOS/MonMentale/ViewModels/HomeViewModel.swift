import Foundation
import Combine

// MARK: - Home ViewModel
// ViewModel pour l'écran d'accueil avec gestion des données

@MainActor
class HomeViewModel: ObservableObject {
    @Published var upcomingAppointments: [Appointment] = []
    @Published var recommendedPractitioners: [Practitioner] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        // Charger les données en parallèle
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.loadUpcomingAppointments() }
                group.addTask { await self.loadRecommendedPractitioners() }
            }
            
            isLoading = false
        }
    }
    
    private func loadUpcomingAppointments() async {
        do {
            // Simuler un appel API
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 seconde
            
            // Données mockées pour la démo
            upcomingAppointments = [
                Appointment(
                    id: "1",
                    patientId: "patient1",
                    practitionerId: "practitioner1",
                    practitioner: Practitioner(
                        id: "practitioner1",
                        userId: "user1",
                        name: "Dr. Marie Dubois",
                        specialization: "Psychologue clinique",
                        specializations: ["Psychologie clinique", "Thérapie cognitive"],
                        description: "Spécialisée dans la thérapie cognitive et comportementale",
                        approach: "Approche humaniste et cognitive",
                        experience: 8,
                        languages: ["Français", "Anglais"],
                        licenseNumber: "PSY123456",
                        university: "Université de Paris",
                        graduationYear: 2015,
                        rating: 4.8,
                        totalReviews: 127,
                        price: 60.0,
                        consultationTypes: [.presentiel, .teleconsultation],
                        address: Address(
                            street: "123 Rue de la Paix",
                            city: "Paris",
                            postalCode: "75001",
                            country: "France",
                            coordinates: Coordinates(latitude: 48.8566, longitude: 2.3522)
                        ),
                        availability: Availability(
                            monday: [TimeSlot(start: "09:00", end: "17:00")],
                            tuesday: [TimeSlot(start: "09:00", end: "17:00")],
                            wednesday: [TimeSlot(start: "09:00", end: "17:00")],
                            thursday: [TimeSlot(start: "09:00", end: "17:00")],
                            friday: [TimeSlot(start: "09:00", end: "17:00")],
                            saturday: [],
                            sunday: []
                        ),
                        isVerified: true,
                        isActive: true,
                        avatar: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    ),
                    date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                    time: "14:30",
                    duration: 45,
                    type: .presentiel,
                    status: .confirmed,
                    reason: "Suivi thérapeutique",
                    notes: nil,
                    price: 60.0,
                    location: AppointmentLocation(
                        type: .presentiel,
                        address: Address(
                            street: "123 Rue de la Paix",
                            city: "Paris",
                            postalCode: "75001",
                            country: "France",
                            coordinates: Coordinates(latitude: 48.8566, longitude: 2.3522)
                        ),
                        meetingLink: nil
                    ),
                    createdAt: Date(),
                    updatedAt: Date()
                )
            ]
        } catch {
            errorMessage = "Erreur lors du chargement des rendez-vous"
        }
    }
    
    private func loadRecommendedPractitioners() async {
        do {
            // Simuler un appel API
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 seconde
            
            // Données mockées pour la démo
            recommendedPractitioners = [
                Practitioner(
                    id: "practitioner2",
                    userId: "user2",
                    name: "Dr. Jean Martin",
                    specialization: "Psychiatre",
                    specializations: ["Psychiatrie générale", "Addictologie"],
                    description: "Psychiatre spécialisé dans les troubles de l'humeur",
                    approach: "Approche intégrative",
                    experience: 12,
                    languages: ["Français"],
                    licenseNumber: "PSY789012",
                    university: "Université de Lyon",
                    graduationYear: 2011,
                    rating: 4.9,
                    totalReviews: 89,
                    price: 80.0,
                    consultationTypes: [.presentiel, .teleconsultation],
                    address: Address(
                        street: "456 Avenue des Champs",
                        city: "Lyon",
                        postalCode: "69001",
                        country: "France",
                        coordinates: Coordinates(latitude: 45.7640, longitude: 4.8357)
                    ),
                    availability: Availability(
                        monday: [TimeSlot(start: "08:00", end: "18:00")],
                        tuesday: [TimeSlot(start: "08:00", end: "18:00")],
                        wednesday: [TimeSlot(start: "08:00", end: "18:00")],
                        thursday: [TimeSlot(start: "08:00", end: "18:00")],
                        friday: [TimeSlot(start: "08:00", end: "18:00")],
                        saturday: [TimeSlot(start: "09:00", end: "13:00")],
                        sunday: []
                    ),
                    isVerified: true,
                    isActive: true,
                    avatar: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                Practitioner(
                    id: "practitioner3",
                    userId: "user3",
                    name: "Dr. Sophie Laurent",
                    specialization: "Psychologue",
                    specializations: ["Psychologie de l'enfant", "Thérapie familiale"],
                    description: "Spécialisée dans la psychologie de l'enfant et de l'adolescent",
                    approach: "Approche systémique",
                    experience: 6,
                    languages: ["Français", "Espagnol"],
                    licenseNumber: "PSY345678",
                    university: "Université de Toulouse",
                    graduationYear: 2017,
                    rating: 4.7,
                    totalReviews: 156,
                    price: 55.0,
                    consultationTypes: [.presentiel, .teleconsultation, .domicile],
                    address: Address(
                        street: "789 Rue de la République",
                        city: "Toulouse",
                        postalCode: "31000",
                        country: "France",
                        coordinates: Coordinates(latitude: 43.6047, longitude: 1.4442)
                    ),
                    availability: Availability(
                        monday: [TimeSlot(start: "09:00", end: "17:00")],
                        tuesday: [TimeSlot(start: "09:00", end: "17:00")],
                        wednesday: [TimeSlot(start: "09:00", end: "17:00")],
                        thursday: [TimeSlot(start: "09:00", end: "17:00")],
                        friday: [TimeSlot(start: "09:00", end: "17:00")],
                        saturday: [],
                        sunday: []
                    ),
                    isVerified: true,
                    isActive: true,
                    avatar: nil,
                    createdAt: Date(),
                    updatedAt: Date()
                )
            ]
        } catch {
            errorMessage = "Erreur lors du chargement des praticiens"
        }
    }
    
    private func loadMockData() {
        // Charger des données mockées pour la démo
        loadData()
    }
    
    func saveMood(_ mood: MoodLevel) {
        // Sauvegarder l'humeur via l'API
        Task {
            do {
                // Appel API pour sauvegarder l'humeur
                // await apiService.saveMood(mood)
                print("Humeur sauvegardée: \(mood.displayName)")
            } catch {
                errorMessage = "Erreur lors de la sauvegarde de l'humeur"
            }
        }
    }
    
    func refreshData() {
        loadData()
    }
}

// MARK: - API Service
class APIService {
    static let shared = APIService()
    
    private init() {}
    
    private let baseURL = "https://api.monmentale.com"
    
    func saveMood(_ mood: MoodLevel) async throws {
        // Implémentation de l'appel API pour sauvegarder l'humeur
        let url = URL(string: "\(baseURL)/mood")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let moodData = MoodData(mood: mood, timestamp: Date())
        request.httpBody = try JSONEncoder().encode(moodData)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
    }
}

// MARK: - Supporting Types
struct MoodData: Codable {
    let mood: MoodLevel
    let timestamp: Date
}

enum APIError: Error {
    case invalidResponse
    case networkError
    case decodingError
}

