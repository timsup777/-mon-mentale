import Foundation
import SwiftUI

// MARK: - Localization Manager
// Gestionnaire de localisation pour le support multilingue

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .french
    @Published var bundle: Bundle = Bundle.main
    
    private init() {
        loadSavedLanguage()
    }
    
    // MARK: - Supported Languages
    enum Language: String, CaseIterable, Identifiable {
        case french = "fr"
        case german = "de"
        case italian = "it"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .french:
                return "Français"
            case .german:
                return "Deutsch"
            case .italian:
                return "Italiano"
            }
        }
        
        var flag: String {
            switch self {
            case .french:
                return "🇫🇷"
            case .german:
                return "🇩🇪"
            case .italian:
                return "🇮🇹"
            }
        }
        
        var locale: Locale {
            switch self {
            case .french:
                return Locale(identifier: "fr_FR")
            case .german:
                return Locale(identifier: "de_DE")
            case .italian:
                return Locale(identifier: "it_IT")
            }
        }
    }
    
    // MARK: - Language Management
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        bundle = Bundle.main
        
        // Sauvegarder la préférence
        UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
        
        // Mettre à jour le bundle de localisation
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        }
        
        // Notifier les changements
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    private func loadSavedLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            setLanguage(language)
        } else {
            // Utiliser la langue du système
            let systemLanguage = Locale.current.languageCode ?? "fr"
            let language = Language(rawValue: systemLanguage) ?? .french
            setLanguage(language)
        }
    }
    
    // MARK: - String Localization
    
    func localizedString(for key: String, comment: String = "") -> String {
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = localizedString(for: key)
        return String(format: format, arguments: arguments)
    }
}

// MARK: - String Extension for Localization
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return LocalizationManager.shared.localizedString(for: self, arguments: arguments)
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

// MARK: - Localized Keys
// Clés de localisation centralisées pour éviter les erreurs de frappe

struct LocalizedKeys {
    
    // MARK: - Common
    struct Common {
        static let ok = "common.ok"
        static let cancel = "common.cancel"
        static let save = "common.save"
        static let delete = "common.delete"
        static let edit = "common.edit"
        static let done = "common.done"
        static let loading = "common.loading"
        static let error = "common.error"
        static let success = "common.success"
        static let warning = "common.warning"
        static let info = "common.info"
        static let retry = "common.retry"
        static let close = "common.close"
        static let next = "common.next"
        static let previous = "common.previous"
        static let search = "common.search"
        static let filter = "common.filter"
        static let sort = "common.sort"
        static let refresh = "common.refresh"
    }
    
    // MARK: - App
    struct App {
        static let name = "app.name"
        static let tagline = "app.tagline"
        static let welcome = "app.welcome"
        static let getStarted = "app.get_started"
    }
    
    // MARK: - Authentication
    struct Auth {
        static let login = "auth.login"
        static let register = "auth.register"
        static let logout = "auth.logout"
        static let email = "auth.email"
        static let password = "auth.password"
        static let confirmPassword = "auth.confirm_password"
        static let firstName = "auth.first_name"
        static let lastName = "auth.last_name"
        static let forgotPassword = "auth.forgot_password"
        static let resetPassword = "auth.reset_password"
        static let loginTitle = "auth.login_title"
        static let registerTitle = "auth.register_title"
        static let loginSubtitle = "auth.login_subtitle"
        static let registerSubtitle = "auth.register_subtitle"
        static let alreadyHaveAccount = "auth.already_have_account"
        static let dontHaveAccount = "auth.dont_have_account"
        static let loginError = "auth.login_error"
        static let registerError = "auth.register_error"
        static let emailRequired = "auth.email_required"
        static let passwordRequired = "auth.password_required"
        static let firstNameRequired = "auth.first_name_required"
        static let lastNameRequired = "auth.last_name_required"
        static let passwordTooShort = "auth.password_too_short"
        static let passwordsDontMatch = "auth.passwords_dont_match"
        static let invalidEmail = "auth.invalid_email"
    }
    
    // MARK: - User Roles
    struct UserRole {
        static let patient = "user_role.patient"
        static let psychologue = "user_role.psychologue"
        static let psychiatre = "user_role.psychiatre"
        static let admin = "user_role.admin"
    }
    
    // MARK: - Mood
    struct Mood {
        static let title = "mood.title"
        static let subtitle = "mood.subtitle"
        static let howDoYouFeel = "mood.how_do_you_feel"
        static let evaluateMood = "mood.evaluate_mood"
        static let todayMood = "mood.today_mood"
        static let terrible = "mood.terrible"
        static let bad = "mood.bad"
        static let okay = "mood.okay"
        static let good = "mood.good"
        static let great = "mood.great"
        static let excellent = "mood.excellent"
        static let terribleDescription = "mood.terrible_description"
        static let badDescription = "mood.bad_description"
        static let okayDescription = "mood.okay_description"
        static let goodDescription = "mood.good_description"
        static let greatDescription = "mood.great_description"
        static let excellentDescription = "mood.excellent_description"
        static let save = "mood.save"
        static let skip = "mood.skip"
        static let journal = "mood.journal"
        static let meditate = "mood.meditate"
        static let breathe = "mood.breathe"
    }
    
    // MARK: - Navigation
    struct Navigation {
        static let home = "navigation.home"
        static let search = "navigation.search"
        static let appointments = "navigation.appointments"
        static let messages = "navigation.messages"
        static let profile = "navigation.profile"
        static let settings = "navigation.settings"
        static let back = "navigation.back"
        static let forward = "navigation.forward"
    }
    
    // MARK: - Home
    struct Home {
        static let title = "home.title"
        static let greeting = "home.greeting"
        static let howDoYouFeelToday = "home.how_do_you_feel_today"
        static let searchPlaceholder = "home.search_placeholder"
        static let appointments = "home.appointments"
        static let thisWeek = "home.this_week"
        static let sessions = "home.sessions"
        static let thisMonth = "home.this_month"
        static let progress = "home.progress"
        static let goals = "home.goals"
        static let upcomingAppointments = "home.upcoming_appointments"
        static let seeAll = "home.see_all"
        static let noAppointments = "home.no_appointments"
        static let noAppointmentsMessage = "home.no_appointments_message"
        static let bookAppointment = "home.book_appointment"
        static let recommended = "home.recommended"
        static let recommendedForYou = "home.recommended_for_you"
        static let wellnessResources = "home.wellness_resources"
        static let meditation = "home.meditation"
        static let exercises = "home.exercises"
        static let journal = "home.journal"
        static let relaxation = "home.relaxation"
    }
    
    // MARK: - Appointments
    struct Appointments {
        static let title = "appointments.title"
        static let upcoming = "appointments.upcoming"
        static let past = "appointments.past"
        static let cancelled = "appointments.cancelled"
        static let noAppointments = "appointments.no_appointments"
        static let noAppointmentsMessage = "appointments.no_appointments_message"
        static let bookNew = "appointments.book_new"
        static let status = "appointments.status"
        static let scheduled = "appointments.scheduled"
        static let confirmed = "appointments.confirmed"
        static let inProgress = "appointments.in_progress"
        static let completed = "appointments.completed"
        static let cancelledStatus = "appointments.cancelled_status"
        static let noShow = "appointments.no_show"
    }
    
    // MARK: - Practitioners
    struct Practitioners {
        static let title = "practitioners.title"
        static let specialization = "practitioners.specialization"
        static let experience = "practitioners.experience"
        static let rating = "practitioners.rating"
        static let price = "practitioners.price"
        static let perSession = "practitioners.per_session"
        static let yearsExperience = "practitioners.years_experience"
        static let verified = "practitioners.verified"
        static let available = "practitioners.available"
        static let consultationTypes = "practitioners.consultation_types"
        static let presentiel = "practitioners.presentiel"
        static let teleconsultation = "practitioners.teleconsultation"
        static let domicile = "practitioners.domicile"
        static let languages = "practitioners.languages"
        static let description = "practitioners.description"
        static let approach = "practitioners.approach"
    }
    
    // MARK: - Profile
    struct Profile {
        static let title = "profile.title"
        static let personalInfo = "profile.personal_info"
        static let paymentMethods = "profile.payment_methods"
        static let notifications = "profile.notifications"
        static let helpSupport = "profile.help_support"
        static let settings = "profile.settings"
        static let sessions = "profile.sessions"
        static let thisMonth = "profile.this_month"
        static let progress = "profile.progress"
        static let goals = "profile.goals"
    }
    
    // MARK: - Settings
    struct Settings {
        static let title = "settings.title"
        static let language = "settings.language"
        static let notifications = "settings.notifications"
        static let privacy = "settings.privacy"
        static let about = "settings.about"
        static let version = "settings.version"
        static let support = "settings.support"
        static let terms = "settings.terms"
        static let privacyPolicy = "settings.privacy_policy"
    }
}

// MARK: - Localized String Extensions
extension LocalizedKeys {
    static func localized(_ key: String) -> String {
        return key.localized
    }
}

