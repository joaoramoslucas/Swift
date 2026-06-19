import Foundation

// MARK: - Login ViewModel (Single Responsibility: authentication logic)
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isAdmin: Bool = false

    private let authService: AuthServiceProtocol
    private let adminEmail = "admgeral@gmail.com"

    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }

    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    func login(completion: @escaping (Bool, Bool) -> Void) {
        guard isFormValid else { return }
        errorMessage = nil
        isLoading = true

        if email.lowercased() == adminEmail {
            loginAsAdmin(completion: completion)
        } else {
            loginAsUser(completion: completion)
        }
    }

    private func loginAsAdmin(completion: @escaping (Bool, Bool) -> Void) {
        APIService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAdmin = true
                    self?.isLoggedIn = true
                    completion(true, true)
                case .failure:
                    self?.errorMessage = "Credenciais inválidas."
                    completion(false, false)
                }
            }
        }
    }

    private func loginAsUser(completion: @escaping (Bool, Bool) -> Void) {
        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAdmin = false
                    self?.isLoggedIn = true
                    completion(true, false)
                case .failure:
                    self?.errorMessage = "Email ou senha incorretos."
                    completion(false, false)
                }
            }
        }
    }
}
