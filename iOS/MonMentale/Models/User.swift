import Foundation

// MARK: - User Model
// Modèle utilisateur avec support Codable pour l'API

struct User: Codable, Identifiable, Hashable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let phone: String?
    let dateOfBirth: Date?
    let gender: Gender?
    let avatar: String?
    let role: UserRole
    let isVerified: Bool
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var initials: String {
        let firstInitial = firstName.prefix(1).uppercased()
        let lastInitial = lastName.prefix(1).uppercased()
        return "\(firstInitial)\(lastInitial)"
    }
    
    var displayName: String {
        "\(firstName) \(lastName.prefix(1))."
    }
}

// MARK: - User Role
enum UserRole: String, Codable, CaseIterable {
    case patient = "patient"
    case psychologue = "psychologue"
    case psychiatre = "psychiatre"
    case admin = "admin"
    
    var displayName: String {
        switch self {
        case .patient:
            return "Patient"
        case .psychologue:
            return "Psychologue"
        case .psychiatre:
            return "Psychiatre"
        case .admin:
            return "Administrateur"
        }
    }
    
    var icon: String {
        switch self {
        case .patient:
            return "person.circle"
        case .psychologue:
            return "brain.head.profile"
        case .psychiatre:
            return "stethoscope"
        case .admin:
            return "gear"
        }
    }
}

// MARK: - Gender
enum Gender: String, Codable, CaseIterable {
    case male = "homme"
    case female = "femme"
    case other = "autre"
    
    var displayName: String {
        switch self {
        case .male:
            return "Homme"
        case .female:
            return "Femme"
        case .other:
            return "Autre"
        }
    }
}

// MARK: - Practitioner Model
struct Practitioner: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let name: String
    let specialization: String
    let specializations: [String]
    let description: String?
    let approach: String?
    let experience: Int
    let languages: [String]
    let licenseNumber: String
    let university: String
    let graduationYear: Int
    let rating: Double
    let totalReviews: Int
    let price: Double
    let consultationTypes: [ConsultationType]
    let address: Address
    let availability: Availability
    let isVerified: Bool
    let isActive: Bool
    let avatar: String?
    let createdAt: Date
    let updatedAt: Date
    
    var displaySpecialization: String {
        specializations.joined(separator: ", ")
    }
    
    var experienceText: String {
        if experience == 0 {
            return "Débutant"
        } else if experience == 1 {
            return "1 an d'expérience"
        } else {
            return "\(experience) ans d'expérience"
        }
    }
    
    var ratingText: String {
        String(format: "%.1f", rating)
    }
    
    var priceText: String {
        "\(Int(price))€/session"
    }
}

// MARK: - Consultation Type
enum ConsultationType: String, Codable, CaseIterable {
    case presentiel = "presentiel"
    case teleconsultation = "teleconsultation"
    case domicile = "domicile"
    
    var displayName: String {
        switch self {
        case .presentiel:
            return "En cabinet"
        case .teleconsultation:
            return "Téléconsultation"
        case .domicile:
            return "À domicile"
        }
    }
    
    var icon: String {
        switch self {
        case .presentiel:
            return "building.2"
        case .teleconsultation:
            return "video"
        case .domicile:
            return "house"
        }
    }
}

// MARK: - Address
struct Address: Codable, Hashable {
    let street: String
    let city: String
    let postalCode: String
    let country: String
    let coordinates: Coordinates?
    
    var fullAddress: String {
        "\(street), \(postalCode) \(city), \(country)"
    }
    
    var shortAddress: String {
        "\(city), \(country)"
    }
}

// MARK: - Coordinates
struct Coordinates: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Availability
struct Availability: Codable, Hashable {
    let monday: [TimeSlot]
    let tuesday: [TimeSlot]
    let wednesday: [TimeSlot]
    let thursday: [TimeSlot]
    let friday: [TimeSlot]
    let saturday: [TimeSlot]
    let sunday: [TimeSlot]
    
    func timeSlots(for day: Weekday) -> [TimeSlot] {
        switch day {
        case .monday:
            return monday
        case .tuesday:
            return tuesday
        case .wednesday:
            return wednesday
        case .thursday:
            return thursday
        case .friday:
            return friday
        case .saturday:
            return saturday
        case .sunday:
            return sunday
        }
    }
}

// MARK: - Time Slot
struct TimeSlot: Codable, Hashable {
    let start: String
    let end: String
    
    var startTime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: start)
    }
    
    var endTime: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: end)
    }
    
    var displayText: String {
        "\(start) - \(end)"
    }
}

// MARK: - Weekday
enum Weekday: String, CaseIterable {
    case monday = "lundi"
    case tuesday = "mardi"
    case wednesday = "mercredi"
    case thursday = "jeudi"
    case friday = "vendredi"
    case saturday = "samedi"
    case sunday = "dimanche"
    
    var displayName: String {
        switch self {
        case .monday:
            return "Lundi"
        case .tuesday:
            return "Mardi"
        case .wednesday:
            return "Mercredi"
        case .thursday:
            return "Jeudi"
        case .friday:
            return "Vendredi"
        case .saturday:
            return "Samedi"
        case .sunday:
            return "Dimanche"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return "Lun"
        case .tuesday:
            return "Mar"
        case .wednesday:
            return "Mer"
        case .thursday:
            return "Jeu"
        case .friday:
            return "Ven"
        case .saturday:
            return "Sam"
        case .sunday:
            return "Dim"
        }
    }
}

// MARK: - Appointment Model
struct Appointment: Codable, Identifiable, Hashable {
    let id: String
    let patientId: String
    let practitionerId: String
    let practitioner: Practitioner
    let date: Date
    let time: String
    let duration: Int
    let type: ConsultationType
    let status: AppointmentStatus
    let reason: String?
    let notes: String?
    let price: Double
    let location: AppointmentLocation?
    let createdAt: Date
    let updatedAt: Date
    
    var service: String {
        switch type {
        case .presentiel:
            return "Consultation en cabinet"
        case .teleconsultation:
            return "Téléconsultation"
        case .domicile:
            return "Consultation à domicile"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date).capitalized
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}

// MARK: - Appointment Status
enum AppointmentStatus: String, Codable, CaseIterable {
    case scheduled = "scheduled"
    case confirmed = "confirmed"
    case inProgress = "in_progress"
    case completed = "completed"
    case cancelled = "cancelled"
    case noShow = "no_show"
    
    var displayName: String {
        switch self {
        case .scheduled:
            return "Programmé"
        case .confirmed:
            return "Confirmé"
        case .inProgress:
            return "En cours"
        case .completed:
            return "Terminé"
        case .cancelled:
            return "Annulé"
        case .noShow:
            return "Absent"
        }
    }
    
    var color: String {
        switch self {
        case .scheduled:
            return "primary"
        case .confirmed:
            return "success"
        case .inProgress:
            return "warning"
        case .completed:
            return "info"
        case .cancelled:
            return "error"
        case .noShow:
            return "error"
        }
    }
}

// MARK: - Appointment Location
struct AppointmentLocation: Codable, Hashable {
    let type: ConsultationType
    let address: Address?
    let meetingLink: String?
    
    var displayText: String {
        switch type {
        case .presentiel:
            return address?.fullAddress ?? "Adresse non spécifiée"
        case .teleconsultation:
            return "Lien de visioconférence"
        case .domicile:
            return "À domicile"
        }
    }
}

