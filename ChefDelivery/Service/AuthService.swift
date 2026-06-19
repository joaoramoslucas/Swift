import Foundation
import FirebaseAuth

// MARK: - Auth Service Implementation
final class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    private init() {}

    func login(email: String, password: String, completion: @escaping (Result<AuthResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let authResult = AuthResult(
                    userId: user.uid,
                    email: user.email ?? "",
                    isAdmin: false
                )
                completion(.success(authResult))
            }
        }
    }

    func register(email: String, password: String, completion: @escaping (Result<AuthResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let authResult = AuthResult(
                    userId: user.uid,
                    email: user.email ?? "",
                    isAdmin: false
                )
                completion(.success(authResult))
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
    }

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
}
