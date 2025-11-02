import SwiftUI
import Combine
import UserNotifications
import BackgroundTasks

@main
struct MonMentaleApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var localizationManager = LocalizationManager.shared
    
    init() {
        configureAppearance()
        configureNotifications()
    }
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoading {
                LoadingViewWithProgress()
                    .environmentObject(localizationManager)
            } else {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(authManager)
                    .environmentObject(notificationManager)
                    .environmentObject(locationManager)
                    .environmentObject(localizationManager)
                    .onAppear {
                        setupApp()
                    }
            }
        }
        .backgroundTask(.appRefresh("com.monmentale.refresh")) {
            await handleBackgroundRefresh()
        }
    }
    
    // MARK: - App Configuration
    
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
        
        // Configuration des onglets
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    private func configureNotifications() {
        UNUserNotificationCenter.current().delegate = notificationManager
    }
    
    private func setupApp() {
        // Démarrer le chargement
        appState.isLoading = true
        
        Task {
            // Simuler un chargement de 3 secondes
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            // Charger les données de l'application
            await authManager.checkAuthenticationStatus()
            await notificationManager.requestPermission()
            
            // Terminer le chargement
            await MainActor.run {
                appState.isLoading = false
            }
        }
    }
    
    private func handleBackgroundRefresh() async {
        // Gestion des tâches en arrière-plan
        await notificationManager.scheduleUpcomingAppointmentReminders()
    }
}

// MARK: - App State Management

@MainActor
class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let keychain = KeychainManager()
    
    init() {
        loadUserFromKeychain()
    }
    
    func setUser(_ user: User) {
        currentUser = user
        isAuthenticated = true
        saveUserToKeychain(user)
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        clearUserFromKeychain()
    }
    
    private func loadUserFromKeychain() {
        if let userData = keychain.getData(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    private func saveUserToKeychain(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            keychain.set(userData, forKey: "currentUser")
        }
    }
    
    private func clearUserFromKeychain() {
        keychain.delete(forKey: "currentUser")
    }
}

// MARK: - Keychain Manager

class KeychainManager {
    private let service = "com.monmentale.app"
    
    func set(_ data: Data, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status == errSecSuccess ? result as? Data : nil
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
