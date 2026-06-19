import SwiftUI
import FirebaseAuth

// MARK: - Session Manager (Single Responsibility: manages auth state only)
final class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isAdmin: Bool = false
    @Published var currentUserEmail: String = ""

    static let shared = SessionManager()
    private var authListener: AuthStateDidChangeListenerHandle?

    private init() {
        listenToAuthChanges()
    }

    private func listenToAuthChanges() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
                self?.currentUserEmail = user?.email ?? ""
            }
        }
    }

    func loginAsAdmin() {
        isAdmin = true
        isLoggedIn = true
    }

    func logout() {
        try? Auth.auth().signOut()
        isAdmin = false
        isLoggedIn = false
        currentUserEmail = ""
    }
}
